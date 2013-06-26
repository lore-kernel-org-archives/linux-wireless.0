Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1756 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 8/9] brcmfmac: reduce firmware-signalling locking scope
 in rx path
Date: Wed, 26 Jun 2013 14:20:21 +0200
Message-ID: <1372249222-4858-9-git-send-email-arend@broadcom.com> (sfid-20130626_142045_099425_0F92633C)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the receive path a spinlock is taken upon parsing the TLV signal
header. This moves to locking to the TLV handling functions where
it protects the data structures.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   77 +++++++++++++-------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 9c6d182..386fbfc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -905,10 +905,26 @@ static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
 	return 0;
 }
 
+/* using macro so sparse checking does not complain
+ * about locking imbalance.
+ */
+#define brcmf_fws_lock(drvr, flags)				\
+do {								\
+	flags = 0;						\
+	spin_lock_irqsave(&((drvr)->fws_spinlock), (flags));	\
+} while (0)
+
+/* using macro so sparse checking does not complain
+ * about locking imbalance.
+ */
+#define brcmf_fws_unlock(drvr, flags) \
+	spin_unlock_irqrestore(&((drvr)->fws_spinlock), (flags))
+
 static
 int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry, *existing;
+	ulong flags;
 	u8 mac_handle;
 	u8 ifidx;
 	u8 *addr;
@@ -922,8 +938,10 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 		if (entry->occupied) {
 			brcmf_dbg(TRACE, "deleting %s mac %pM\n",
 				  entry->name, addr);
+			brcmf_fws_lock(fws->drvr, flags);
 			brcmf_fws_macdesc_cleanup(fws, entry, -1);
 			brcmf_fws_macdesc_deinit(entry);
+			brcmf_fws_unlock(fws->drvr, flags);
 		} else
 			fws->stats.mac_update_failed++;
 		return 0;
@@ -932,11 +950,13 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	existing = brcmf_fws_macdesc_lookup(fws, addr);
 	if (IS_ERR(existing)) {
 		if (!entry->occupied) {
+			brcmf_fws_lock(fws->drvr, flags);
 			entry->mac_handle = mac_handle;
 			brcmf_fws_macdesc_init(entry, addr, ifidx);
 			brcmf_fws_macdesc_set_name(fws, entry);
 			brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 					BRCMF_FWS_PSQ_LEN);
+			brcmf_fws_unlock(fws->drvr, flags);
 			brcmf_dbg(TRACE, "add %s mac %pM\n", entry->name, addr);
 		} else {
 			fws->stats.mac_update_failed++;
@@ -944,11 +964,13 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	} else {
 		if (entry != existing) {
 			brcmf_dbg(TRACE, "copy mac %s\n", existing->name);
+			brcmf_fws_lock(fws->drvr, flags);
 			memcpy(entry, existing,
 			       offsetof(struct brcmf_fws_mac_descriptor, psq));
 			entry->mac_handle = mac_handle;
 			brcmf_fws_macdesc_deinit(existing);
 			brcmf_fws_macdesc_set_name(fws, entry);
+			brcmf_fws_unlock(fws->drvr, flags);
 			brcmf_dbg(TRACE, "relocate %s mac %pM\n", entry->name,
 				  addr);
 		} else {
@@ -964,7 +986,9 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 					    u8 type, u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry;
+	ulong flags;
 	u8 mac_handle;
+	int ret;
 
 	mac_handle = data[0];
 	entry = &fws->desc.nodes[mac_handle & 0x1F];
@@ -972,26 +996,30 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 		fws->stats.mac_ps_update_failed++;
 		return -ESRCH;
 	}
+	brcmf_fws_lock(fws->drvr, flags);
 	/* a state update should wipe old credits */
 	entry->requested_credit = 0;
 	entry->requested_packet = 0;
 	if (type == BRCMF_FWS_TYPE_MAC_OPEN) {
 		entry->state = BRCMF_FWS_STATE_OPEN;
-		return BRCMF_FWS_RET_OK_SCHEDULE;
+		ret = BRCMF_FWS_RET_OK_SCHEDULE;
 	} else {
 		entry->state = BRCMF_FWS_STATE_CLOSE;
 		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_BK, false);
 		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_BE, false);
 		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_VI, false);
 		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_VO, true);
+		ret = BRCMF_FWS_RET_OK_NOSCHEDULE;
 	}
-	return BRCMF_FWS_RET_OK_NOSCHEDULE;
+	brcmf_fws_unlock(fws->drvr, flags);
+	return ret;
 }
 
 static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 					      u8 type, u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry;
+	ulong flags;
 	u8 ifidx;
 	int ret;
 
@@ -1010,17 +1038,24 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 
 	brcmf_dbg(TRACE, "%s (%d): %s\n", brcmf_fws_get_tlv_name(type), type,
 		  entry->name);
+	brcmf_fws_lock(fws->drvr, flags);
 	switch (type) {
 	case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		entry->state = BRCMF_FWS_STATE_OPEN;
-		return BRCMF_FWS_RET_OK_SCHEDULE;
+		ret = BRCMF_FWS_RET_OK_SCHEDULE;
+		break;
 	case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
 		entry->state = BRCMF_FWS_STATE_CLOSE;
-		return BRCMF_FWS_RET_OK_NOSCHEDULE;
+		ret = BRCMF_FWS_RET_OK_NOSCHEDULE;
+		break;
 	default:
 		ret = -EINVAL;
-		break;
+		brcmf_fws_unlock(fws->drvr, flags);
+		goto fail;
 	}
+	brcmf_fws_unlock(fws->drvr, flags);
+	return ret;
+
 fail:
 	fws->stats.if_update_failed++;
 	return ret;
@@ -1030,6 +1065,7 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 				      u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry;
+	ulong flags;
 
 	entry = &fws->desc.nodes[data[1] & 0x1F];
 	if (!entry->occupied) {
@@ -1043,12 +1079,14 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 	brcmf_dbg(TRACE, "%s (%d): %s cnt %d bmp %d\n",
 		  brcmf_fws_get_tlv_name(type), type, entry->name,
 		  data[0], data[2]);
+	brcmf_fws_lock(fws->drvr, flags);
 	if (type == BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT)
 		entry->requested_credit = data[0];
 	else
 		entry->requested_packet = data[0];
 
 	entry->ac_bitmap = data[2];
+	brcmf_fws_unlock(fws->drvr, flags);
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
@@ -1345,6 +1383,7 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 					     u8 *data)
 {
+	ulong flags;
 	int i;
 
 	if (fws->fcmode != BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
@@ -1353,16 +1392,19 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 	}
 
 	brcmf_dbg(DATA, "enter: data %pM\n", data);
+	brcmf_fws_lock(fws->drvr, flags);
 	for (i = 0; i < BRCMF_FWS_FIFO_COUNT; i++)
 		brcmf_fws_return_credits(fws, i, data[i]);
 
 	brcmf_dbg(DATA, "map: credit %x delay %x\n", fws->fifo_credit_map,
 		  fws->fifo_delay_map);
+	brcmf_fws_unlock(fws->drvr, flags);
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
 static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 {
+	ulong lflags;
 	__le32 status_le;
 	u32 status;
 	u32 hslot;
@@ -1376,7 +1418,10 @@ static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 	hslot = brcmf_txstatus_get_field(status, HSLOT);
 	genbit = brcmf_txstatus_get_field(status, GENERATION);
 
-	return brcmf_fws_txs_process(fws, flags, hslot, genbit);
+	brcmf_fws_lock(fws->drvr, lflags);
+	brcmf_fws_txs_process(fws, flags, hslot, genbit);
+	brcmf_fws_unlock(fws->drvr, lflags);
+	return BRCMF_FWS_RET_OK_NOSCHEDULE;
 }
 
 static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
@@ -1389,21 +1434,6 @@ static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
 	return 0;
 }
 
-/* using macro so sparse checking does not complain
- * about locking imbalance.
- */
-#define brcmf_fws_lock(drvr, flags)				\
-do {								\
-	flags = 0;						\
-	spin_lock_irqsave(&((drvr)->fws_spinlock), (flags));	\
-} while (0)
-
-/* using macro so sparse checking does not complain
- * about locking imbalance.
- */
-#define brcmf_fws_unlock(drvr, flags) \
-	spin_unlock_irqrestore(&((drvr)->fws_spinlock), (flags))
-
 static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 				       const struct brcmf_event_msg *e,
 				       void *data)
@@ -1454,7 +1484,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb)
 {
 	struct brcmf_fws_info *fws = drvr->fws;
-	ulong flags;
 	u8 *signal_data;
 	s16 data_len;
 	u8 type;
@@ -1474,9 +1503,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		return 0;
 	}
 
-	/* lock during tlv parsing */
-	brcmf_fws_lock(drvr, flags);
-
 	fws->stats.header_pulls++;
 	data_len = signal_len;
 	signal_data = skb->data;
@@ -1570,7 +1596,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	if (skb->len == 0)
 		fws->stats.header_only_pkt++;
 
-	brcmf_fws_unlock(drvr, flags);
 	return 0;
 }
 
-- 
1.7.10.4


