Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4843 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab3FFLTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:19:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/22] brcmfmac: reducing debug logging in
 firmware-signalling code
Date: Thu, 6 Jun 2013 13:17:51 +0200
Message-ID: <1370517487-14395-7-git-send-email-arend@broadcom.com> (sfid-20130606_131928_255178_09B7A2DB)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug logging in firmware-signalling code was rather extensive and
for a large part in the data path. This patch removes large part or the
level is changed to DATA level.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  124 ++++++++++----------
 2 files changed, 66 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 5a774493..2fee9b6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -179,7 +179,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh;
 
-	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
+	brcmf_dbg(DATA, "Enter, idx=%d\n", ifp->bssidx);
 
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
@@ -287,7 +287,7 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 	u8 ifidx;
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(DATA, "Enter\n");
 
 	skb_queue_walk_safe(skb_list, skb, pnext) {
 		skb_unlink(skb, skb_list);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index d080874..73e3e1d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -343,6 +343,7 @@ enum brcmf_fws_mac_desc_state {
  * @transit_count: packet in transit to firmware.
  */
 struct brcmf_fws_mac_descriptor {
+	char name[16];
 	u8 occupied;
 	u8 mac_handle;
 	u8 interface_id;
@@ -508,7 +509,6 @@ static void brcmf_fws_hanger_init(struct brcmf_fws_hanger *hanger)
 {
 	int i;
 
-	brcmf_dbg(TRACE, "enter\n");
 	memset(hanger, 0, sizeof(*hanger));
 	for (i = 0; i < ARRAY_SIZE(hanger->items); i++)
 		hanger->items[i].state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
@@ -518,7 +518,6 @@ static u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 {
 	u32 i;
 
-	brcmf_dbg(TRACE, "enter\n");
 	i = (h->slot_pos + 1) % BRCMF_FWS_HANGER_MAXITEMS;
 
 	while (i != h->slot_pos) {
@@ -534,14 +533,12 @@ static u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 	h->failed_slotfind++;
 	i = BRCMF_FWS_HANGER_MAXITEMS;
 done:
-	brcmf_dbg(TRACE, "exit: %d\n", i);
 	return i;
 }
 
 static int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
 					   struct sk_buff *pkt, u32 slot_id)
 {
-	brcmf_dbg(TRACE, "enter\n");
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
 		return -ENOENT;
 
@@ -561,7 +558,6 @@ static int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 					  u32 slot_id, struct sk_buff **pktout,
 					  bool remove_item)
 {
-	brcmf_dbg(TRACE, "enter\n");
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
 		return -ENOENT;
 
@@ -584,8 +580,6 @@ static int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 						   u32 slot_id, u8 gen)
 {
-	brcmf_dbg(TRACE, "enter\n");
-
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
 		return -ENOENT;
 
@@ -604,7 +598,6 @@ static int brcmf_fws_hanger_get_genbit(struct brcmf_fws_hanger *hanger,
 					      struct sk_buff *pkt, u32 slot_id,
 					      int *gen)
 {
-	brcmf_dbg(TRACE, "enter\n");
 	*gen = 0xff;
 
 	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
@@ -628,7 +621,6 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 	int i;
 	enum brcmf_fws_hanger_item_state s;
 
-	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 	for (i = 0; i < ARRAY_SIZE(h->items); i++) {
 		s = h->items[i].state;
 		if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE ||
@@ -645,6 +637,19 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 	}
 }
 
+static void brcmf_fws_macdesc_set_name(struct brcmf_fws_info *fws,
+				       struct brcmf_fws_mac_descriptor *desc)
+{
+	if (desc == &fws->desc.other)
+		strlcpy(desc->name, "MAC-OTHER", sizeof(desc->name));
+	else if (desc->mac_handle)
+		scnprintf(desc->name, sizeof(desc->name), "MAC-%d:%d",
+			  desc->mac_handle, desc->interface_id);
+	else
+		scnprintf(desc->name, sizeof(desc->name), "MACIF:%d",
+			  desc->interface_id);
+}
+
 static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
 					  u8 *addr, u8 ifidx)
 {
@@ -676,7 +681,6 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 	struct brcmf_fws_mac_descriptor *entry;
 	int i;
 
-	brcmf_dbg(TRACE, "enter: ea=%pM\n", ea);
 	if (ea == NULL)
 		return ERR_PTR(-EINVAL);
 
@@ -698,8 +702,6 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, struct brcmf_if *ifp,
 	bool multicast;
 	enum nl80211_iftype iftype;
 
-	brcmf_dbg(TRACE, "enter: idx=%d\n", ifp->bssidx);
-
 	multicast = is_multicast_ether_addr(da);
 	iftype = brcmf_cfg80211_get_iftype(ifp);
 
@@ -720,7 +722,6 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, struct brcmf_if *ifp,
 		entry = &fws->desc.other;
 
 done:
-	brcmf_dbg(TRACE, "exit: entry=%p\n", entry);
 	return entry;
 }
 
@@ -753,11 +754,7 @@ static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_info *fws,
 				       struct brcmf_fws_mac_descriptor *entry,
 				       int ifidx)
 {
-	brcmf_dbg(TRACE, "enter: entry=(ea=%pM, ifid=%d), ifidx=%d\n",
-		  entry->ea, entry->interface_id, ifidx);
 	if (entry->occupied && (ifidx == -1 || ifidx == entry->interface_id)) {
-		brcmf_dbg(TRACE, "flush psq: ifidx=%d, qlen=%d\n",
-			  ifidx, entry->psq.len);
 		brcmf_fws_psq_flush(fws, &entry->psq, ifidx);
 		entry->occupied = !!(entry->psq.len);
 	}
@@ -773,7 +770,6 @@ static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
 	int prec;
 	u32 hslot;
 
-	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 	txq = brcmf_bus_gettxq(fws->drvr->bus_if);
 	if (IS_ERR(txq)) {
 		brcmf_dbg(TRACE, "no txq to clean up\n");
@@ -799,7 +795,6 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 	struct brcmf_fws_mac_descriptor *table;
 	bool (*matchfn)(struct sk_buff *, void *) = NULL;
 
-	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 	if (fws == NULL)
 		return;
 
@@ -820,7 +815,6 @@ static void brcmf_fws_tim_update(struct brcmf_fws_info *ctx,
 				 struct brcmf_fws_mac_descriptor *entry,
 				 int prec)
 {
-	brcmf_dbg(TRACE, "enter: ea=%pM\n", entry->ea);
 	if (entry->state == BRCMF_FWS_STATE_CLOSE) {
 		/* check delayedQ and suppressQ in one call using bitmap */
 		if (brcmu_pktq_mlen(&entry->psq, 3 << (prec * 2)) == 0)
@@ -877,8 +871,9 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 
 	entry = &fws->desc.nodes[mac_handle & 0x1F];
 	if (type == BRCMF_FWS_TYPE_MACDESC_DEL) {
-		brcmf_dbg(TRACE, "deleting mac %pM idx %d\n", addr, ifidx);
 		if (entry->occupied) {
+			brcmf_dbg(TRACE, "deleting %s mac %pM\n",
+				  entry->name, addr);
 			brcmf_fws_mac_desc_cleanup(fws, entry, -1);
 			brcmf_fws_clear_mac_descriptor(entry);
 		} else
@@ -886,25 +881,28 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 		return 0;
 	}
 
-	brcmf_dbg(TRACE,
-		  "add mac %pM handle %u idx %d\n", addr, mac_handle, ifidx);
 	existing = brcmf_fws_mac_descriptor_lookup(fws, addr);
 	if (IS_ERR(existing)) {
 		if (!entry->occupied) {
 			entry->mac_handle = mac_handle;
 			brcmf_fws_init_mac_descriptor(entry, addr, ifidx);
+			brcmf_fws_macdesc_set_name(fws, entry);
 			brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 					BRCMF_FWS_PSQ_LEN);
+			brcmf_dbg(TRACE, "add %s mac %pM\n", entry->name, addr);
 		} else {
 			fws->stats.mac_update_failed++;
 		}
 	} else {
 		if (entry != existing) {
-			brcmf_dbg(TRACE, "relocate mac\n");
+			brcmf_dbg(TRACE, "copy mac %s\n", existing->name);
 			memcpy(entry, existing,
 			       offsetof(struct brcmf_fws_mac_descriptor, psq));
 			entry->mac_handle = mac_handle;
 			brcmf_fws_clear_mac_descriptor(existing);
+			brcmf_fws_macdesc_set_name(fws, entry);
+			brcmf_dbg(TRACE, "relocate %s mac %pM\n", entry->name,
+				  addr);
 		} else {
 			brcmf_dbg(TRACE, "use existing\n");
 			WARN_ON(entry->mac_handle != mac_handle);
@@ -928,6 +926,8 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 		return -ESRCH;
 	}
 
+	brcmf_dbg(TRACE, "%s (%d): %s\n", brcmf_fws_get_tlv_name(type), type,
+		  entry->name);
 	/* a state update should wipe old credits? */
 	entry->requested_credit = 0;
 	if (type == BRCMF_FWS_TYPE_MAC_OPEN) {
@@ -950,7 +950,6 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 
 	ifidx = data[0];
 
-	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 	if (ifidx >= BRCMF_MAX_IFS) {
 		ret = -ERANGE;
 		goto fail;
@@ -962,6 +961,8 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 		goto fail;
 	}
 
+	brcmf_dbg(TRACE, "%s (%d): %s\n", brcmf_fws_get_tlv_name(type), type,
+		  entry->name);
 	switch (type) {
 	case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		entry->state = BRCMF_FWS_STATE_OPEN;
@@ -992,6 +993,9 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 		return -ESRCH;
 	}
 
+	brcmf_dbg(TRACE, "%s (%d): %s cnt %d bmp %d\n",
+		  brcmf_fws_get_tlv_name(type), type, entry->name,
+		  data[0], data[2]);
 	if (type == BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT)
 		entry->requested_credit = data[0];
 	else
@@ -1108,7 +1112,7 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 		return -ENOENT;
 	}
 
-	brcmf_dbg(TRACE, "enter: ea=%pM, qlen=%d\n", entry->ea, entry->psq.len);
+	brcmf_dbg(DATA, "enter: fifo %d skb %p\n", fifo, p);
 	if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED) {
 		prec += 1;
 		qfull_stat = &fws->stats.supprq_full_error;
@@ -1202,7 +1206,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 	}
 	p = NULL;
 done:
-	brcmf_dbg(TRACE, "exit: fifo %d skb %p\n", fifo, p);
+	brcmf_dbg(DATA, "exit: fifo %d skb %p\n", fifo, p);
 	return p;
 }
 
@@ -1221,6 +1225,9 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 		entry->suppress_count = brcmu_pktq_mlen(&entry->psq,
 							1 << (fifo * 2 + 1));
 		entry->suppr_transit_count = entry->transit_count;
+		brcmf_dbg(DATA, "suppress %s: supp_cnt %d transit %d\n",
+			  entry->name, entry->suppress_count,
+			  entry->transit_count);
 	}
 
 	entry->generation = genbit;
@@ -1244,17 +1251,17 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 }
 
 static int
-brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
+brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 			   u32 genbit)
 {
 	u32 fifo;
 	int ret;
 	bool remove_from_hanger = true;
 	struct sk_buff *skb;
+	struct brcmf_skbuff_cb *skcb;
 	struct brcmf_fws_mac_descriptor *entry = NULL;
 
-	brcmf_dbg(TRACE, "status: flags=0x%X, hslot=%d\n",
-		  flags, hslot);
+	brcmf_dbg(DATA, "flags %d\n", flags);
 
 	if (flags == BRCMF_FWS_TXSTATUS_DISCARD)
 		fws->stats.txs_discard++;
@@ -1276,12 +1283,16 @@ brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 		return ret;
 	}
 
-	entry = brcmf_skbcb(skb)->mac;
+	skcb = brcmf_skbcb(skb);
+	entry = skcb->mac;
 	if (WARN_ON(!entry)) {
 		brcmu_pkt_buf_free_skb(skb);
 		return -EINVAL;
 	}
 
+	brcmf_dbg(DATA, "%s flags %X htod %X\n", entry->name, skcb->if_flags,
+		  skcb->htod);
+
 	/* pick up the implicit credit from this packet */
 	fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
 	if (fws->fcmode == BRCMF_FWS_FCMODE_IMPLIED_CREDIT ||
@@ -1311,11 +1322,11 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 		return BRCMF_FWS_RET_OK_NOSCHEDULE;
 	}
 
-	brcmf_dbg(TRACE, "enter: data %pM\n", data);
+	brcmf_dbg(DATA, "enter: data %pM\n", data);
 	for (i = 0; i < BRCMF_FWS_FIFO_COUNT; i++)
 		brcmf_fws_return_credits(fws, i, data[i]);
 
-	brcmf_dbg(INFO, "map: credit %x delay %x\n", fws->fifo_credit_map,
+	brcmf_dbg(DATA, "map: credit %x delay %x\n", fws->fifo_credit_map,
 		  fws->fifo_delay_map);
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
@@ -1335,7 +1346,7 @@ static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 	hslot = brcmf_txstatus_get_field(status, HSLOT);
 	genbit = brcmf_txstatus_get_field(status, GENERATION);
 
-	return brcmf_fws_txstatus_process(fws, flags, hslot, genbit);
+	return brcmf_fws_txs_process(fws, flags, hslot, genbit);
 }
 
 static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
@@ -1343,7 +1354,7 @@ static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
 	__le32 timestamp;
 
 	memcpy(&timestamp, &data[2], sizeof(timestamp));
-	brcmf_dbg(INFO, "received: seq %d, timestamp %d\n", data[1],
+	brcmf_dbg(CTL, "received: seq %d, timestamp %d\n", data[1],
 		  le32_to_cpu(timestamp));
 	return 0;
 }
@@ -1404,7 +1415,7 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	s32 status;
 	s32 err;
 
-	brcmf_dbg(TRACE, "enter: ifidx %d, skblen %u, sig %d\n",
+	brcmf_dbg(HDRS, "enter: ifidx %d, skblen %u, sig %d\n",
 		  ifidx, skb->len, signal_len);
 
 	WARN_ON(signal_len > skb->len);
@@ -1438,8 +1449,9 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		len = signal_data[1];
 		data = signal_data + 2;
 
-		brcmf_dbg(INFO, "tlv type=%d (%s), len=%d, data[0]=%d\n", type,
-			  brcmf_fws_get_tlv_name(type), len, *data);
+		brcmf_dbg(HDRS, "tlv type=%s (%d), len=%d (%d)\n",
+			  brcmf_fws_get_tlv_name(type), type, len,
+			  brcmf_fws_get_tlv_len(fws, type));
 
 		/* abort parsing when length invalid */
 		if (data_len < len + 2)
@@ -1522,8 +1534,6 @@ static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	u8 fillers;
 	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
 
-	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u, pkttag=0x%08X\n",
-		  entry->ea, entry->interface_id, le32_to_cpu(pkttag));
 	if (entry->send_tim_signal)
 		data_offset += 2 + BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN;
 
@@ -1708,7 +1718,7 @@ static int brcmf_fws_borrow_credit(struct brcmf_fws_info *fws)
 			fws->fifo_credit[lender_ac]--;
 			if (fws->fifo_credit[lender_ac] == 0)
 				fws->fifo_credit_map &= ~(1 << lender_ac);
-			brcmf_dbg(TRACE, "borrow credit from: %d\n", lender_ac);
+			brcmf_dbg(DATA, "borrow credit from: %d\n", lender_ac);
 			return 0;
 		}
 	}
@@ -1721,12 +1731,8 @@ static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	int *credit = &fws->fifo_credit[fifo];
 
-	brcmf_dbg(TRACE, "enter: ac=%d, credits=%d\n", fifo, *credit);
-
-	if (!brcmf_fws_macdesc_use_credit(entry, skb)) {
-		brcmf_dbg(TRACE, "exit: no creditcheck set\n");
+	if (!brcmf_fws_macdesc_use_credit(entry, skb))
 		return 0;
-	}
 
 	if (fifo != BRCMF_FWS_FIFO_AC_BE)
 		fws->borrow_defer_timestamp = jiffies +
@@ -1738,13 +1744,13 @@ static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
 		    brcmf_fws_borrow_credit(fws) == 0)
 			return 0;
 
-		brcmf_dbg(TRACE, "exit: ac=%d, credits depleted\n", fifo);
+		brcmf_dbg(DATA, "exit: ac=%d, credits depleted\n", fifo);
 		return -ENAVAIL;
 	}
 	(*credit)--;
 	if (!(*credit))
 		fws->fifo_credit_map &= ~(1 << fifo);
-	brcmf_dbg(TRACE, "exit: ac=%d, credits=%d\n", fifo, *credit);
+	brcmf_dbg(DATA, "exit: ac=%d, credits=%d\n", fifo, *credit);
 	return 0;
 }
 
@@ -1766,6 +1772,8 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		goto rollback;
 	}
 
+	brcmf_dbg(DATA, "%s flags %X htod %X\n", entry->name, skcb->if_flags,
+		  skcb->htod);
 	rc = brcmf_bus_txdata(bus, skb);
 	if (rc < 0)
 		goto rollback;
@@ -1818,8 +1826,8 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	if (!multicast)
 		fifo = brcmf_fws_prio2fifo[skb->priority];
 
-	brcmf_dbg(TRACE, "ea=%pM, multi=%d, fifo=%d\n", eh->h_dest,
-		  multicast, fifo);
+	brcmf_dbg(DATA, "%s mac %pM multi %d fifo %d\n", skcb->mac->name,
+		  eh->h_dest, multicast, fifo);
 
 	brcmf_fws_lock(drvr, flags);
 	if (skcb->mac->suppressed ||
@@ -1854,16 +1862,16 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 	struct brcmf_fws_info *fws = ifp->drvr->fws;
 	struct brcmf_fws_mac_descriptor *entry;
 
-	brcmf_dbg(TRACE, "enter: idx=%d, mac=%pM\n",
-		  ifp->bssidx, ifp->mac_addr);
 	if (!ifp->ndev || !ifp->drvr->fw_signals)
 		return;
 
 	entry = &fws->desc.iface[ifp->ifidx];
 	ifp->fws_desc = entry;
 	brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
+	brcmf_fws_macdesc_set_name(fws, entry);
 	brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
+	brcmf_dbg(TRACE, "added %s\n", entry->name);
 }
 
 void brcmf_fws_del_interface(struct brcmf_if *ifp)
@@ -1871,12 +1879,12 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
 	ulong flags;
 
-	brcmf_dbg(TRACE, "enter: idx=%d\n", ifp->bssidx);
 	if (!entry)
 		return;
 
 	brcmf_fws_lock(ifp->drvr, flags);
 	ifp->fws_desc = NULL;
+	brcmf_dbg(TRACE, "deleting %s\n", entry->name);
 	brcmf_fws_clear_mac_descriptor(entry);
 	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
 	brcmf_fws_unlock(ifp->drvr, flags);
@@ -1891,12 +1899,9 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 
 	fws = container_of(worker, struct brcmf_fws_info, fws_dequeue_work);
 
-	brcmf_dbg(TRACE, "enter: fws=%p\n", fws);
 	brcmf_fws_lock(fws->drvr, flags);
 	for (fifo = NL80211_NUM_ACS; fifo >= 0 && !fws->bus_flow_blocked;
 	     fifo--) {
-		brcmf_dbg(TRACE, "fifo %d credit %d\n", fifo,
-			  fws->fifo_credit[fifo]);
 		while (fws->fifo_credit[fifo]) {
 			skb = brcmf_fws_deq(fws, fifo);
 			if (!skb)
@@ -1980,14 +1985,14 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 
 	brcmf_fws_hanger_init(&drvr->fws->hanger);
 	brcmf_fws_init_mac_descriptor(&drvr->fws->desc.other, NULL, 0);
+	brcmf_fws_macdesc_set_name(drvr->fws, &drvr->fws->desc.other);
 	brcmu_pktq_init(&drvr->fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
 
 	/* create debugfs file for statistics */
 	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
 
-	/* TODO: remove upon feature delivery */
-	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
+	brcmf_dbg(INFO, "%s bdcv2 tlv signaling [%x]\n",
 		  drvr->fw_signals ? "enabled" : "disabled", tlv);
 	return 0;
 
@@ -2029,7 +2034,6 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 	if (!fws)
 		return false;
 
-	brcmf_dbg(TRACE, "enter: mode=%d\n", fws->fcmode);
 	return fws->fcmode != BRCMF_FWS_FCMODE_NONE;
 }
 
@@ -2039,7 +2043,7 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	int fifo;
 
 	brcmf_fws_lock(fws->drvr, flags);
-	brcmf_fws_txstatus_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
+	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
 				   brcmf_skb_htod_tag_get_field(skb, HSLOT), 0);
 	/* the packet never reached firmware so reclaim credit */
 	if (fws->fcmode == BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
-- 
1.7.10.4


