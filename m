Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2746 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968552Ab3HJK14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/12] brcmfmac: no fws locking outside fws module.
Date: Sat, 10 Aug 2013 12:27:23 +0200
Message-ID: <1376130450-29746-6-git-send-email-arend@broadcom.com> (sfid-20130810_122822_800182_703AA554)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

FWS uses locking to protect its data while being called from
various entries. On bus_txdata the lock was kept resulting in
unnecessary long locking, but also creating possibility for
deadlock. This update changes the locking to release lock when
bus_txdata is called.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   1 -
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 127 ++++++++++-----------
 2 files changed, 62 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index df94d0e..1273dfd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -558,7 +558,6 @@ struct brcmf_pub {
 	struct brcmf_fweh_info fweh;
 
 	struct brcmf_fws_info *fws;
-	spinlock_t fws_spinlock;
 
 	struct brcmf_ampdu_rx_reorder
 		*reorder_flows[BRCMF_AMPDU_RX_REORDER_MAXFLOWS];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 15fc807..82f9140 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -422,6 +422,8 @@ struct brcmf_fws_macdesc_table {
 
 struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
+	spinlock_t spinlock;
+	ulong flags;
 	struct brcmf_fws_stats stats;
 	struct brcmf_fws_hanger hanger;
 	enum brcmf_fws_fcmode fcmode;
@@ -484,6 +486,18 @@ static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
 }
 #undef BRCMF_FWS_TLV_DEF
 
+static void brcmf_fws_lock(struct brcmf_fws_info *fws)
+		__acquires(&fws->spinlock)
+{
+	spin_lock_irqsave(&fws->spinlock, fws->flags);
+}
+
+static void brcmf_fws_unlock(struct brcmf_fws_info *fws)
+		__releases(&fws->spinlock)
+{
+	spin_unlock_irqrestore(&fws->spinlock, fws->flags);
+}
+
 static bool brcmf_fws_ifidx_match(struct sk_buff *skb, void *arg)
 {
 	u32 ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
@@ -870,8 +884,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		skcb->state = BRCMF_FWS_SKBSTATE_TIM;
 		bus = fws->drvr->bus_if;
 		err = brcmf_fws_hdrpush(fws, skb);
-		if (err == 0)
+		if (err == 0) {
+			brcmf_fws_unlock(fws);
 			err = brcmf_bus_txdata(bus, skb);
+			brcmf_fws_lock(fws);
+		}
 		if (err)
 			brcmu_pkt_buf_free_skb(skb);
 		return true;
@@ -906,26 +923,10 @@ static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
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
 static
 int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry, *existing;
-	ulong flags;
 	u8 mac_handle;
 	u8 ifidx;
 	u8 *addr;
@@ -939,10 +940,10 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 		if (entry->occupied) {
 			brcmf_dbg(TRACE, "deleting %s mac %pM\n",
 				  entry->name, addr);
-			brcmf_fws_lock(fws->drvr, flags);
+			brcmf_fws_lock(fws);
 			brcmf_fws_macdesc_cleanup(fws, entry, -1);
 			brcmf_fws_macdesc_deinit(entry);
-			brcmf_fws_unlock(fws->drvr, flags);
+			brcmf_fws_unlock(fws);
 		} else
 			fws->stats.mac_update_failed++;
 		return 0;
@@ -951,13 +952,13 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	existing = brcmf_fws_macdesc_lookup(fws, addr);
 	if (IS_ERR(existing)) {
 		if (!entry->occupied) {
-			brcmf_fws_lock(fws->drvr, flags);
+			brcmf_fws_lock(fws);
 			entry->mac_handle = mac_handle;
 			brcmf_fws_macdesc_init(entry, addr, ifidx);
 			brcmf_fws_macdesc_set_name(fws, entry);
 			brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 					BRCMF_FWS_PSQ_LEN);
-			brcmf_fws_unlock(fws->drvr, flags);
+			brcmf_fws_unlock(fws);
 			brcmf_dbg(TRACE, "add %s mac %pM\n", entry->name, addr);
 		} else {
 			fws->stats.mac_update_failed++;
@@ -965,13 +966,13 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	} else {
 		if (entry != existing) {
 			brcmf_dbg(TRACE, "copy mac %s\n", existing->name);
-			brcmf_fws_lock(fws->drvr, flags);
+			brcmf_fws_lock(fws);
 			memcpy(entry, existing,
 			       offsetof(struct brcmf_fws_mac_descriptor, psq));
 			entry->mac_handle = mac_handle;
 			brcmf_fws_macdesc_deinit(existing);
 			brcmf_fws_macdesc_set_name(fws, entry);
-			brcmf_fws_unlock(fws->drvr, flags);
+			brcmf_fws_unlock(fws);
 			brcmf_dbg(TRACE, "relocate %s mac %pM\n", entry->name,
 				  addr);
 		} else {
@@ -987,7 +988,6 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 					    u8 type, u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry;
-	ulong flags;
 	u8 mac_handle;
 	int ret;
 
@@ -997,7 +997,7 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 		fws->stats.mac_ps_update_failed++;
 		return -ESRCH;
 	}
-	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_lock(fws);
 	/* a state update should wipe old credits */
 	entry->requested_credit = 0;
 	entry->requested_packet = 0;
@@ -1012,7 +1012,7 @@ static int brcmf_fws_macdesc_state_indicate(struct brcmf_fws_info *fws,
 		brcmf_fws_tim_update(fws, entry, BRCMF_FWS_FIFO_AC_VO, true);
 		ret = BRCMF_FWS_RET_OK_NOSCHEDULE;
 	}
-	brcmf_fws_unlock(fws->drvr, flags);
+	brcmf_fws_unlock(fws);
 	return ret;
 }
 
@@ -1020,7 +1020,6 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 					      u8 type, u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry;
-	ulong flags;
 	u8 ifidx;
 	int ret;
 
@@ -1039,7 +1038,7 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 
 	brcmf_dbg(TRACE, "%s (%d): %s\n", brcmf_fws_get_tlv_name(type), type,
 		  entry->name);
-	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_lock(fws);
 	switch (type) {
 	case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		entry->state = BRCMF_FWS_STATE_OPEN;
@@ -1051,10 +1050,10 @@ static int brcmf_fws_interface_state_indicate(struct brcmf_fws_info *fws,
 		break;
 	default:
 		ret = -EINVAL;
-		brcmf_fws_unlock(fws->drvr, flags);
+		brcmf_fws_unlock(fws);
 		goto fail;
 	}
-	brcmf_fws_unlock(fws->drvr, flags);
+	brcmf_fws_unlock(fws);
 	return ret;
 
 fail:
@@ -1066,7 +1065,6 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 				      u8 *data)
 {
 	struct brcmf_fws_mac_descriptor *entry;
-	ulong flags;
 
 	entry = &fws->desc.nodes[data[1] & 0x1F];
 	if (!entry->occupied) {
@@ -1080,14 +1078,14 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 	brcmf_dbg(TRACE, "%s (%d): %s cnt %d bmp %d\n",
 		  brcmf_fws_get_tlv_name(type), type, entry->name,
 		  data[0], data[2]);
-	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_lock(fws);
 	if (type == BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT)
 		entry->requested_credit = data[0];
 	else
 		entry->requested_packet = data[0];
 
 	entry->ac_bitmap = data[2];
-	brcmf_fws_unlock(fws->drvr, flags);
+	brcmf_fws_unlock(fws);
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
@@ -1385,7 +1383,6 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 					     u8 *data)
 {
-	ulong flags;
 	int i;
 
 	if (fws->fcmode != BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
@@ -1394,19 +1391,18 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 	}
 
 	brcmf_dbg(DATA, "enter: data %pM\n", data);
-	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_lock(fws);
 	for (i = 0; i < BRCMF_FWS_FIFO_COUNT; i++)
 		brcmf_fws_return_credits(fws, i, data[i]);
 
 	brcmf_dbg(DATA, "map: credit %x delay %x\n", fws->fifo_credit_map,
 		  fws->fifo_delay_map);
-	brcmf_fws_unlock(fws->drvr, flags);
+	brcmf_fws_unlock(fws);
 	return BRCMF_FWS_RET_OK_SCHEDULE;
 }
 
 static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 {
-	ulong lflags;
 	__le32 status_le;
 	u32 status;
 	u32 hslot;
@@ -1420,9 +1416,9 @@ static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 	hslot = brcmf_txstatus_get_field(status, HSLOT);
 	genbit = brcmf_txstatus_get_field(status, GENERATION);
 
-	brcmf_fws_lock(fws->drvr, lflags);
+	brcmf_fws_lock(fws);
 	brcmf_fws_txs_process(fws, flags, hslot, genbit);
-	brcmf_fws_unlock(fws->drvr, lflags);
+	brcmf_fws_unlock(fws);
 	return BRCMF_FWS_RET_OK_NOSCHEDULE;
 }
 
@@ -1442,7 +1438,6 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 {
 	struct brcmf_fws_info *fws = ifp->drvr->fws;
 	int i;
-	ulong flags;
 	u8 *credits = data;
 
 	if (e->datalen < BRCMF_FWS_FIFO_COUNT) {
@@ -1455,7 +1450,7 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 	fws->creditmap_received = true;
 
 	brcmf_dbg(TRACE, "enter: credits %pM\n", credits);
-	brcmf_fws_lock(ifp->drvr, flags);
+	brcmf_fws_lock(fws);
 	for (i = 0; i < ARRAY_SIZE(fws->fifo_credit); i++) {
 		if (*credits)
 			fws->fifo_credit_map |= 1 << i;
@@ -1464,7 +1459,7 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 		fws->fifo_credit[i] = *credits++;
 	}
 	brcmf_fws_schedule_deq(fws);
-	brcmf_fws_unlock(ifp->drvr, flags);
+	brcmf_fws_unlock(fws);
 	return 0;
 }
 
@@ -1473,12 +1468,11 @@ static int brcmf_fws_notify_bcmc_credit_support(struct brcmf_if *ifp,
 						void *data)
 {
 	struct brcmf_fws_info *fws = ifp->drvr->fws;
-	ulong flags;
 
-	brcmf_fws_lock(ifp->drvr, flags);
+	brcmf_fws_lock(fws);
 	if (fws)
 		fws->bcmc_credit_check = true;
-	brcmf_fws_unlock(ifp->drvr, flags);
+	brcmf_fws_unlock(fws);
 	return 0;
 }
 
@@ -1702,17 +1696,22 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		return PTR_ERR(entry);
 
 	brcmf_fws_precommit_skb(fws, fifo, skb);
+	entry->transit_count++;
+	if (entry->suppressed)
+		entry->suppr_transit_count++;
+	brcmf_fws_unlock(fws);
 	rc = brcmf_bus_txdata(bus, skb);
+	brcmf_fws_lock(fws);
 	brcmf_dbg(DATA, "%s flags %X htod %X bus_tx %d\n", entry->name,
 		  skcb->if_flags, skcb->htod, rc);
 	if (rc < 0) {
+		entry->transit_count--;
+		if (entry->suppressed)
+			entry->suppr_transit_count--;
 		brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
 		goto rollback;
 	}
 
-	entry->transit_count++;
-	if (entry->suppressed)
-		entry->suppr_transit_count++;
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
 	if (brcmf_skb_if_flags_get_field(skb, REQUESTED))
@@ -1749,7 +1748,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	struct brcmf_fws_info *fws = drvr->fws;
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
-	ulong flags;
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
 	bool pae = eh->h_proto == htons(ETH_P_PAE);
@@ -1770,7 +1768,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	if (!multicast)
 		fifo = brcmf_fws_prio2fifo[skb->priority];
 
-	brcmf_fws_lock(drvr, flags);
+	brcmf_fws_lock(fws);
 	if (fifo != BRCMF_FWS_FIFO_AC_BE && fifo < BRCMF_FWS_FIFO_BCMC)
 		fws->borrow_defer_timestamp = jiffies +
 					      BRCMF_FWS_BORROW_DEFER_PERIOD;
@@ -1790,7 +1788,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		}
 		brcmu_pkt_buf_free_skb(skb);
 	}
-	brcmf_fws_unlock(drvr, flags);
+	brcmf_fws_unlock(fws);
 	return 0;
 }
 
@@ -1825,17 +1823,16 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 void brcmf_fws_del_interface(struct brcmf_if *ifp)
 {
 	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
-	ulong flags;
 
 	if (!entry)
 		return;
 
-	brcmf_fws_lock(ifp->drvr, flags);
+	brcmf_fws_lock(ifp->drvr->fws);
 	ifp->fws_desc = NULL;
 	brcmf_dbg(TRACE, "deleting %s\n", entry->name);
 	brcmf_fws_macdesc_deinit(entry);
 	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
-	brcmf_fws_unlock(ifp->drvr, flags);
+	brcmf_fws_unlock(ifp->drvr->fws);
 }
 
 static void brcmf_fws_dequeue_worker(struct work_struct *worker)
@@ -1843,7 +1840,6 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	struct brcmf_fws_info *fws;
 	struct brcmf_pub *drvr;
 	struct sk_buff *skb;
-	ulong flags;
 	int fifo;
 	u32 hslot;
 	u32 ifidx;
@@ -1852,7 +1848,7 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	fws = container_of(worker, struct brcmf_fws_info, fws_dequeue_work);
 	drvr = fws->drvr;
 
-	brcmf_fws_lock(drvr, flags);
+	brcmf_fws_lock(fws);
 	for (fifo = BRCMF_FWS_FIFO_BCMC; fifo >= 0 && !fws->bus_flow_blocked;
 	     fifo--) {
 		if (!brcmf_fws_fc_active(fws)) {
@@ -1865,7 +1861,9 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 								     INDEX);
 				brcmf_proto_hdrpush(drvr, ifidx, 0, skb);
 				/* Use bus module to send data frame */
+				brcmf_fws_unlock(fws);
 				ret = brcmf_bus_txdata(drvr->bus_if, skb);
+				brcmf_fws_lock(fws);
 				if (ret < 0)
 					brcmf_txfinalize(drvr, skb, false);
 				if (fws->bus_flow_blocked)
@@ -1900,7 +1898,7 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 			}
 		}
 	}
-	brcmf_fws_unlock(drvr, flags);
+	brcmf_fws_unlock(fws);
 }
 
 int brcmf_fws_init(struct brcmf_pub *drvr)
@@ -1909,8 +1907,6 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	u32 tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS;
 	int rc;
 
-	spin_lock_init(&drvr->fws_spinlock);
-
 	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
 	if (!drvr->fws) {
 		rc = -ENOMEM;
@@ -1918,6 +1914,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	}
 
 	fws = drvr->fws;
+
+	spin_lock_init(&fws->spinlock);
+
 	/* set linkage back */
 	fws->drvr = drvr;
 	fws->fcmode = fcmode;
@@ -1986,7 +1985,6 @@ fail:
 void brcmf_fws_deinit(struct brcmf_pub *drvr)
 {
 	struct brcmf_fws_info *fws = drvr->fws;
-	ulong flags;
 
 	if (!fws)
 		return;
@@ -1995,10 +1993,10 @@ void brcmf_fws_deinit(struct brcmf_pub *drvr)
 		destroy_workqueue(drvr->fws->fws_wq);
 
 	/* cleanup */
-	brcmf_fws_lock(drvr, flags);
+	brcmf_fws_lock(fws);
 	brcmf_fws_cleanup(fws, -1);
 	drvr->fws = NULL;
-	brcmf_fws_unlock(drvr, flags);
+	brcmf_fws_unlock(fws);
 
 	/* free top structure */
 	kfree(fws);
@@ -2014,17 +2012,16 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
-	ulong flags;
 	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
-	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_lock(fws);
 	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0);
-	brcmf_fws_unlock(fws->drvr, flags);
+	brcmf_fws_unlock(fws);
 }
 
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
-- 
1.8.1.3


