Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1674 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968547Ab3HJK1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/12] brcmfmac: always use worker thread for tx data.
Date: Sat, 10 Aug 2013 12:27:22 +0200
Message-ID: <1376130450-29746-5-git-send-email-arend@broadcom.com> (sfid-20130810_122816_691318_0075928C)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When fw signalling is disabled tx is sent immediately. Using
queues and worker thread allows usb to do synchronous autopm. This
patch makes fws use queues and worker thread even if signalling is
not supported by FW or not enabled.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    | 13 +--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 96 ++++++++++++----------
 3 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 3943fb8..df94d0e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -557,7 +557,6 @@ struct brcmf_pub {
 
 	struct brcmf_fweh_info fweh;
 
-	bool fw_signals;
 	struct brcmf_fws_info *fws;
 	spinlock_t fws_spinlock;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9bc2785..e067aec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -278,18 +278,10 @@ void brcmf_txflowblock(struct device *dev, bool state)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
-	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (brcmf_fws_fc_active(drvr->fws)) {
-		brcmf_fws_bus_blocked(drvr, state);
-	} else {
-		for (i = 0; i < BRCMF_MAX_IFS; i++)
-			brcmf_txflowblock_if(drvr->iflist[i],
-					     BRCMF_NETIF_STOP_REASON_BLOCK_BUS,
-					     state);
-	}
+	brcmf_fws_bus_blocked(drvr, state);
 }
 
 static void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
@@ -534,7 +526,7 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 		skb_unlink(skb, skb_list);
 
 		/* process and remove protocol-specific header */
-		ret = brcmf_proto_hdrpull(drvr, drvr->fw_signals, &ifidx, skb);
+		ret = brcmf_proto_hdrpull(drvr, true, &ifidx, skb);
 		ifp = drvr->iflist[ifidx];
 
 		if (ret || !ifp || !ifp->ndev) {
@@ -1109,7 +1101,6 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
-	drvr->fw_signals = true;
 	ret = brcmf_fws_init(drvr);
 	if (ret < 0)
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 438c7b9..15fc807 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -425,6 +425,7 @@ struct brcmf_fws_info {
 	struct brcmf_fws_stats stats;
 	struct brcmf_fws_hanger hanger;
 	enum brcmf_fws_fcmode fcmode;
+	bool fw_signals;
 	bool bcmc_credit_check;
 	struct brcmf_fws_macdesc_table desc;
 	struct workqueue_struct *fws_wq;
@@ -1160,7 +1161,8 @@ static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 static void brcmf_fws_schedule_deq(struct brcmf_fws_info *fws)
 {
 	/* only schedule dequeue when there are credits for delayed traffic */
-	if (fws->fifo_credit_map & fws->fifo_delay_map)
+	if ((fws->fifo_credit_map & fws->fifo_delay_map) ||
+	    (!brcmf_fws_fc_active(fws) && fws->fifo_delay_map))
 		queue_work(fws->fws_wq, &fws->fws_dequeue_work);
 }
 
@@ -1498,8 +1500,10 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 
 	WARN_ON(signal_len > skb->len);
 
+	if (!signal_len)
+		return 0;
 	/* if flow control disabled, skip to packet data and leave */
-	if (!signal_len || !drvr->fw_signals) {
+	if (!fws->fw_signals) {
 		skb_pull(skb, signal_len);
 		return 0;
 	}
@@ -1749,7 +1753,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
 	bool pae = eh->h_proto == htons(ETH_P_PAE);
-	int ret;
 
 	brcmf_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
 	/* determine the priority */
@@ -1760,17 +1763,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	if (pae)
 		atomic_inc(&ifp->pend_8021x_cnt);
 
-	if (!brcmf_fws_fc_active(fws)) {
-		/* If the protocol uses a data header, apply it */
-		brcmf_proto_hdrpush(drvr, ifp->ifidx, 0, skb);
-
-		/* Use bus module to send data frame */
-		ret = brcmf_bus_txdata(drvr->bus_if, skb);
-		if (ret < 0)
-			brcmf_txfinalize(drvr, skb, false);
-		return ret;
-	}
-
 	/* set control buffer information */
 	skcb->if_flags = 0;
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
@@ -1818,7 +1810,7 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 	struct brcmf_fws_info *fws = ifp->drvr->fws;
 	struct brcmf_fws_mac_descriptor *entry;
 
-	if (!ifp->ndev || !ifp->drvr->fw_signals)
+	if (!ifp->ndev)
 		return;
 
 	entry = &fws->desc.iface[ifp->ifidx];
@@ -1849,15 +1841,38 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 {
 	struct brcmf_fws_info *fws;
+	struct brcmf_pub *drvr;
 	struct sk_buff *skb;
 	ulong flags;
 	int fifo;
+	u32 hslot;
+	u32 ifidx;
+	int ret;
 
 	fws = container_of(worker, struct brcmf_fws_info, fws_dequeue_work);
+	drvr = fws->drvr;
 
-	brcmf_fws_lock(fws->drvr, flags);
+	brcmf_fws_lock(drvr, flags);
 	for (fifo = BRCMF_FWS_FIFO_BCMC; fifo >= 0 && !fws->bus_flow_blocked;
 	     fifo--) {
+		if (!brcmf_fws_fc_active(fws)) {
+			while ((skb = brcmf_fws_deq(fws, fifo)) != NULL) {
+				hslot = brcmf_skb_htod_tag_get_field(skb,
+								     HSLOT);
+				brcmf_fws_hanger_poppkt(&fws->hanger, hslot,
+							&skb, true);
+				ifidx = brcmf_skb_if_flags_get_field(skb,
+								     INDEX);
+				brcmf_proto_hdrpush(drvr, ifidx, 0, skb);
+				/* Use bus module to send data frame */
+				ret = brcmf_bus_txdata(drvr->bus_if, skb);
+				if (ret < 0)
+					brcmf_txfinalize(drvr, skb, false);
+				if (fws->bus_flow_blocked)
+					break;
+			}
+			continue;
+		}
 		while ((fws->fifo_credit[fifo]) || ((!fws->bcmc_credit_check) &&
 		       (fifo == BRCMF_FWS_FIFO_BCMC))) {
 			skb = brcmf_fws_deq(fws, fifo);
@@ -1885,17 +1900,15 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 			}
 		}
 	}
-	brcmf_fws_unlock(fws->drvr, flags);
+	brcmf_fws_unlock(drvr, flags);
 }
 
 int brcmf_fws_init(struct brcmf_pub *drvr)
 {
+	struct brcmf_fws_info *fws;
 	u32 tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS;
 	int rc;
 
-	if (!drvr->fw_signals)
-		return 0;
-
 	spin_lock_init(&drvr->fws_spinlock);
 
 	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
@@ -1904,20 +1917,21 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
+	fws = drvr->fws;
 	/* set linkage back */
-	drvr->fws->drvr = drvr;
-	drvr->fws->fcmode = fcmode;
+	fws->drvr = drvr;
+	fws->fcmode = fcmode;
 
-	drvr->fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
-	if (drvr->fws->fws_wq == NULL) {
+	fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
+	if (fws->fws_wq == NULL) {
 		brcmf_err("workqueue creation failed\n");
 		rc = -EBADF;
 		goto fail;
 	}
-	INIT_WORK(&drvr->fws->fws_dequeue_work, brcmf_fws_dequeue_worker);
+	INIT_WORK(&fws->fws_dequeue_work, brcmf_fws_dequeue_worker);
 
 	/* enable firmware signalling if fcmode active */
-	if (drvr->fws->fcmode != BRCMF_FWS_FCMODE_NONE)
+	if (fws->fcmode != BRCMF_FWS_FCMODE_NONE)
 		tlv |= BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
 		       BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS |
 		       BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE |
@@ -1937,34 +1951,33 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
-	/* setting the iovar may fail if feature is unsupported
+	/* Setting the iovar may fail if feature is unsupported
 	 * so leave the rc as is so driver initialization can
-	 * continue.
+	 * continue. Set mode back to none indicating not enabled.
 	 */
+	fws->fw_signals = true;
 	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv)) {
 		brcmf_err("failed to set bdcv2 tlv signaling\n");
-		goto fail_event;
+		fws->fcmode = BRCMF_FWS_FCMODE_NONE;
+		fws->fw_signals = false;
 	}
 
 	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "ampdu_hostreorder", 1))
 		brcmf_dbg(INFO, "enabling AMPDU host-reorder failed\n");
 
-	brcmf_fws_hanger_init(&drvr->fws->hanger);
-	brcmf_fws_macdesc_init(&drvr->fws->desc.other, NULL, 0);
-	brcmf_fws_macdesc_set_name(drvr->fws, &drvr->fws->desc.other);
-	brcmu_pktq_init(&drvr->fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
+	brcmf_fws_hanger_init(&fws->hanger);
+	brcmf_fws_macdesc_init(&fws->desc.other, NULL, 0);
+	brcmf_fws_macdesc_set_name(fws, &fws->desc.other);
+	brcmu_pktq_init(&fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
 
 	/* create debugfs file for statistics */
-	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
+	brcmf_debugfs_create_fws_stats(drvr, &fws->stats);
 
 	brcmf_dbg(INFO, "%s bdcv2 tlv signaling [%x]\n",
-		  drvr->fw_signals ? "enabled" : "disabled", tlv);
+		  fws->fw_signals ? "enabled" : "disabled", tlv);
 	return 0;
 
-fail_event:
-	brcmf_fweh_unregister(drvr, BRCMF_E_BCMC_CREDIT_SUPPORT);
-	brcmf_fweh_unregister(drvr, BRCMF_E_FIFO_CREDIT_MAP);
 fail:
 	brcmf_fws_deinit(drvr);
 	return rc;
@@ -1978,11 +1991,6 @@ void brcmf_fws_deinit(struct brcmf_pub *drvr)
 	if (!fws)
 		return;
 
-	/* disable firmware signalling entirely
-	 * to avoid using the workqueue.
-	 */
-	drvr->fw_signals = false;
-
 	if (drvr->fws->fws_wq)
 		destroy_workqueue(drvr->fws->fws_wq);
 
@@ -1998,7 +2006,7 @@ void brcmf_fws_deinit(struct brcmf_pub *drvr)
 
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 {
-	if (!fws)
+	if (!fws->creditmap_received)
 		return false;
 
 	return fws->fcmode != BRCMF_FWS_FCMODE_NONE;
-- 
1.8.1.3


