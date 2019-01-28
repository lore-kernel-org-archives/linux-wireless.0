Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10108C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC21820880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfA1Pmy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:54 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:25405 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfA1Pmv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:51 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881352"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:30 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037502"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:30 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 04/12] wil6210: add support for AC queues per station
Date:   Mon, 28 Jan 2019 17:36:18 +0200
Message-Id: <1548689786-23288-5-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Until now all stations (notably in AP mode) would share the same
queue/s exposed via netdev. This meant that whenever a single
station's ring became full all queues got stopped.

With the queues per station feature each station will have its own
net queue/s and it will not block other stations' transmission in
case its vring is full.

Driver will add queue/s per station when creating a new netdev.
The mapping between a station and its queues will be by sta cid.
Once a new sta connects the driver will open its queues
(can be one or four AC queues) for transmit. The driver uses the
same logic of ring capacity usage to wake the net queues.

Last four netdev queues are used for unclassified traffic
(e.g. when there's no cid for given DA) which is mostly multicast.

This feature is controlled by a q_per_sta module param
which is disabled by default.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c     |   8 ++
 drivers/net/wireless/ath/wil6210/main.c         |  14 ++-
 drivers/net/wireless/ath/wil6210/netdev.c       |  58 +++++++---
 drivers/net/wireless/ath/wil6210/txrx.c         | 148 ++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c    |   4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h      |  24 +++-
 drivers/net/wireless/ath/wil6210/wil_platform.h |   2 +
 drivers/net/wireless/ath/wil6210/wmi.c          |   2 +-
 8 files changed, 227 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 0bd2d73..955571f 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1776,6 +1776,10 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		goto err_bcast;
 
+	/* wake default net queue - used mainly for multicast */
+	if (wil->config.q_per_sta)
+		wil_update_cid_net_queues_bh(wil, vif, WIL6210_MAX_CID, false);
+
 	goto out; /* success */
 
 err_bcast:
@@ -1965,6 +1969,10 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	memset(vif->gtk, 0, WMI_MAX_KEY_LEN);
 	vif->gtk_len = 0;
 
+	/* stop default net queue - used mainly for multicast */
+	if (wil->config.q_per_sta)
+		wil_update_cid_net_queues_bh(wil, vif, WIL6210_MAX_CID, true);
+
 	if (last)
 		__wil_down(wil);
 	else
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 087ab0e..aa3f3bd 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -210,6 +210,9 @@ static void wil_disconnect_cid_complete(struct wil6210_vif *vif, int cid,
 		case NL80211_IFTYPE_P2P_GO:
 			/* AP-like interface */
 			cfg80211_del_sta(ndev, sta->addr, GFP_KERNEL);
+			if (WIL_Q_PER_STA_USED(vif))
+				wil_update_cid_net_queues_bh(wil, vif,
+							     cid, true);
 			break;
 		default:
 			break;
@@ -311,12 +314,14 @@ static void _wil6210_disconnect_complete(struct wil6210_vif *vif,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		if (!wil_vif_is_connected(wil, vif->mid)) {
-			wil_update_net_queues_bh(wil, vif, NULL, true);
+			if (!WIL_Q_PER_STA_USED(vif))
+				wil_update_net_queues_bh(wil, vif, NULL, true);
 			if (test_and_clear_bit(wil_vif_fwconnected,
 					       vif->status))
 				atomic_dec(&wil->connected_vifs);
-		} else {
-			wil_update_net_queues_bh(wil, vif, NULL, false);
+		} else if (!WIL_Q_PER_STA_USED(vif)) {
+			wil_update_net_queues_bh(wil, vif,
+						 NULL, false);
 		}
 		break;
 	default:
@@ -431,6 +436,9 @@ void wil_disconnect_worker(struct work_struct *work)
 		return;
 	}
 
+	/* disconnect worker runs only from client/sta vif.
+	 * stop all queues in case failed to connect
+	 */
 	wil_update_net_queues_bh(wil, vif, NULL, true);
 	netif_carrier_off(ndev);
 	cfg80211_connect_result(ndev, NULL, NULL, 0, NULL, 0,
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index dfc9617..cb925ff 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -20,8 +20,6 @@
 #include "wil6210.h"
 #include "txrx.h"
 
-#define WIL6210_TX_QUEUES (4)
-
 bool wil_has_other_active_ifaces(struct wil6210_priv *wil,
 				 struct net_device *ndev, bool up, bool ok)
 {
@@ -101,27 +99,53 @@ static int wil_stop(struct net_device *ndev)
  * AC_BE -> queue 1
  * AC_BK -> queue 0
  */
-static u16 wil_select_queue(struct net_device *ndev,
-			    struct sk_buff *skb,
-			    struct net_device *sb_dev,
-			    select_queue_fallback_t fallback)
+static u16 wil_select_ac_queue(struct wil6210_priv *wil, struct sk_buff *skb)
 {
 	static const u16 wil_1d_to_queue[8] = {1, 0, 0, 1, 2, 2, 3, 3};
-	struct wil6210_priv *wil = ndev_to_wil(ndev);
-	u16 qid;
-
-	if (!wil->config.ac_queues)
-		return 0;
+	u16 ac_qid;
 
 	/* determine the priority */
 	if (skb->priority == 0 || skb->priority > 7)
 		skb->priority = cfg80211_classify8021d(skb, NULL);
 
-	qid = wil_1d_to_queue[skb->priority];
+	ac_qid = wil_1d_to_queue[skb->priority];
 
 	wil_dbg_txrx(wil, "select queue for priority %d -> queue %d\n",
-		     skb->priority, qid);
+		     skb->priority, ac_qid);
+
+	return ac_qid;
+}
 
+static u16 wil_select_queue(struct net_device *ndev,
+			    struct sk_buff *skb,
+			    struct net_device *sb_dev,
+			    select_queue_fallback_t fallback)
+{
+	struct wil6210_vif *vif = ndev_to_vif(ndev);
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	struct ethhdr *eth = (void *)skb->data;
+	u16 qid = 0;
+	bool mcast;
+
+	if (!WIL_Q_PER_STA_USED(vif))
+		goto out;
+
+	mcast = is_multicast_ether_addr(eth->h_dest);
+	if (mcast) {
+		qid = WIL6210_MAX_CID;
+	} else {
+		qid = wil_find_cid(wil, vif->mid, eth->h_dest);
+
+		/* the MCAST queues also used as default queues */
+		if (qid < 0)
+			qid = WIL6210_MAX_CID;
+	}
+
+out:
+	if (wil->config.ac_queues) {
+		qid *= WIL6210_TX_AC_QUEUES;
+		qid += wil_select_ac_queue(wil, skb);
+	}
 	return qid;
 }
 
@@ -345,6 +369,7 @@ struct wil6210_vif *
 	struct wireless_dev *wdev;
 	struct wil6210_vif *vif;
 	u8 mid;
+	u16 num_of_queues = 1;
 
 	mid = wil_vif_find_free_mid(wil);
 	if (mid == U8_MAX) {
@@ -353,8 +378,13 @@ struct wil6210_vif *
 	}
 
 	if (wil->config.ac_queues)
+		num_of_queues = WIL6210_TX_AC_QUEUES;
+	if (wil->config.q_per_sta)
+		num_of_queues *= (WIL6210_MAX_CID + 1);
+
+	if (num_of_queues > 1)
 		ndev = alloc_netdev_mqs(sizeof(*vif), name, name_assign_type,
-					wil_dev_setup, WIL6210_TX_QUEUES, 1);
+					wil_dev_setup, num_of_queues, 1);
 	else
 		ndev = alloc_netdev(sizeof(*vif), name, name_assign_type,
 				    wil_dev_setup);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index b79fcc7..51ff242 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1155,12 +1155,21 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 					  struct wil6210_vif *vif,
 					  struct sk_buff *skb)
 {
-	int i;
+	int i, cid;
 	struct ethhdr *eth = (void *)skb->data;
-	int cid = wil_find_cid(wil, vif->mid, eth->h_dest);
 	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
-	if (cid < 0)
+	if (WIL_Q_PER_STA_USED(vif))
+		/* assuming skb->queue_mapping was set according to cid
+		 * after calling to net_device_ops.ndo_select_queue
+		 */
+		cid = wil->config.ac_queues ?
+			skb_get_queue_mapping(skb) / WIL6210_TX_AC_QUEUES :
+			skb_get_queue_mapping(skb);
+	else
+		cid = wil_find_cid(wil, vif->mid, eth->h_dest);
+
+	if (cid < 0 || cid >= WIL6210_MAX_CID)
 		return NULL;
 
 	/* TODO: fix for multiple TID */
@@ -1934,6 +1943,91 @@ static int wil_tx_ring(struct wil6210_priv *wil, struct wil6210_vif *vif,
 	return rc;
 }
 
+static int wil_get_cid_by_ring(struct wil6210_priv *wil,
+			       struct wil6210_vif *vif,
+			       struct wil_ring *ring)
+{
+	int ring_index = ring - wil->ring_tx;
+
+	if (unlikely(ring_index < 0 || ring_index >= WIL6210_MAX_TX_RINGS)) {
+		wil_err(wil, "cid by ring 0x%p: invalid ring index %d\n",
+			ring, ring_index);
+		return WIL6210_MAX_CID;
+	}
+
+	return wil->ring2cid_tid[ring_index][0];
+}
+
+static void wil_tx_stop_cid_queues(struct wil6210_priv *wil,
+				   struct wil6210_vif *vif,
+				   int cid)
+{
+	struct net_device *ndev = vif_to_ndev(vif);
+	u16 start_qid, qid, queues_per_cid;
+
+	queues_per_cid = wil->config.ac_queues ? WIL6210_TX_AC_QUEUES : 1;
+	start_qid = cid * queues_per_cid;
+
+	wil_dbg_txrx(wil, "stop queues for cid=%d queues (%d .. %d)\n",
+		     cid, start_qid, start_qid + queues_per_cid - 1);
+
+	for (qid = start_qid; qid < start_qid + queues_per_cid; qid++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(ndev, qid);
+
+		netif_tx_stop_queue(txq);
+	}
+	if (cid < WIL6210_MAX_CID)
+		wil->sta[cid].net_queue_stopped = true;
+}
+
+static void wil_tx_wake_cid_queues(struct wil6210_priv *wil,
+				   struct wil6210_vif *vif,
+				   int cid)
+{
+	struct net_device *ndev = vif_to_ndev(vif);
+	u16 start_qid, qid, queues_per_cid;
+
+	queues_per_cid = wil->config.ac_queues ? WIL6210_TX_AC_QUEUES : 1;
+	start_qid = cid * queues_per_cid;
+
+	wil_dbg_txrx(wil, "wake queues for cid=%d queues (%d .. %d)\n",
+		     cid, start_qid, start_qid + queues_per_cid - 1);
+
+	for (qid = start_qid; qid < start_qid + queues_per_cid; qid++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(ndev, qid);
+
+		netif_tx_wake_queue(txq);
+	}
+	if (cid < WIL6210_MAX_CID)
+		wil->sta[cid].net_queue_stopped = false;
+}
+
+static inline void __wil_update_net_queues_per_sta(struct wil6210_priv *wil,
+						   struct wil6210_vif *vif,
+						   struct wil_ring *ring,
+						   bool check_stop)
+{
+	int cid;
+
+	/* ring is not null - checked by caller */
+	cid = wil_get_cid_by_ring(wil, vif, ring);
+	if (cid < WIL6210_MAX_CID &&
+	    check_stop == wil->sta[cid].net_queue_stopped)
+		/* net queues already in desired state */
+		return;
+
+	if (check_stop) {
+		/* check not enough room in the vring */
+		if (unlikely(wil_ring_avail_low(ring)))
+			wil_tx_stop_cid_queues(wil, vif, cid);
+		return;
+	}
+
+	/* check for enough room in the vring */
+	if (wil_ring_avail_high(ring))
+		wil_tx_wake_cid_queues(wil, vif, cid);
+}
+
 /**
  * Check status of tx vrings and stop/wake net queues if needed
  * It will start/stop net queues of a specific VIF net_device.
@@ -1963,13 +2057,18 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		return;
 
 	if (ring)
-		wil_dbg_txrx(wil, "vring %d, mid %d, check_stop=%d, stopped=%d",
+		wil_dbg_txrx(wil, "ring %d, mid %d, check_stop=%d, stopped=%d",
 			     (int)(ring - wil->ring_tx), vif->mid, check_stop,
 			     vif->net_queue_stopped);
 	else
 		wil_dbg_txrx(wil, "check_stop=%d, mid=%d, stopped=%d",
 			     check_stop, vif->mid, vif->net_queue_stopped);
 
+	if (ring && WIL_Q_PER_STA_USED(vif)) {
+		__wil_update_net_queues_per_sta(wil, vif, ring, check_stop);
+		return;
+	}
+
 	if (check_stop == vif->net_queue_stopped)
 		/* net queues already in desired state */
 		return;
@@ -1979,6 +2078,9 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 			/* not enough room in the vring */
 			netif_tx_stop_all_queues(vif_to_ndev(vif));
 			vif->net_queue_stopped = true;
+			if (WIL_Q_PER_STA_USED(vif))
+				for (i = 0; i < WIL6210_MAX_CID; i++)
+					wil->sta[i].net_queue_stopped = true;
 			wil_dbg_txrx(wil, "netif_tx_stop called\n");
 		}
 		return;
@@ -2010,25 +2112,55 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		wil_dbg_txrx(wil, "calling netif_tx_wake\n");
 		netif_tx_wake_all_queues(vif_to_ndev(vif));
 		vif->net_queue_stopped = false;
+		if (WIL_Q_PER_STA_USED(vif))
+			for (i = 0; i < WIL6210_MAX_CID; i++)
+				wil->sta[i].net_queue_stopped = false;
 	}
 }
 
-void wil_update_net_queues(struct wil6210_priv *wil, struct wil6210_vif *vif,
-			   struct wil_ring *ring, bool check_stop)
+void wil_update_net_queues(struct wil6210_priv *wil,
+			   struct wil6210_vif *vif,
+			   struct wil_ring *ring,
+			   bool check_stop)
 {
 	spin_lock(&wil->net_queue_lock);
 	__wil_update_net_queues(wil, vif, ring, check_stop);
 	spin_unlock(&wil->net_queue_lock);
 }
 
-void wil_update_net_queues_bh(struct wil6210_priv *wil, struct wil6210_vif *vif,
-			      struct wil_ring *ring, bool check_stop)
+void wil_update_net_queues_bh(struct wil6210_priv *wil,
+			      struct wil6210_vif *vif,
+			      struct wil_ring *ring,
+			      bool check_stop)
 {
 	spin_lock_bh(&wil->net_queue_lock);
 	__wil_update_net_queues(wil, vif, ring, check_stop);
 	spin_unlock_bh(&wil->net_queue_lock);
 }
 
+void wil_update_cid_net_queues_bh(struct wil6210_priv *wil,
+				  struct wil6210_vif *vif,
+				  int cid,
+				  bool should_stop)
+{
+	if (!WIL_Q_PER_STA_USED(vif)) {
+		wil_update_net_queues_bh(wil, vif, NULL, should_stop);
+		return;
+	}
+
+	if (cid < WIL6210_MAX_CID &&
+	    should_stop == wil->sta[cid].net_queue_stopped)
+		/* net queues already in desired state */
+		return;
+
+	spin_lock_bh(&wil->net_queue_lock);
+	if (should_stop)
+		wil_tx_stop_cid_queues(wil, vif, cid);
+	else
+		wil_tx_wake_cid_queues(wil, vif, cid);
+	spin_unlock_bh(&wil->net_queue_lock);
+}
+
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wil6210_vif *vif = ndev_to_vif(ndev);
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 05a8348..432a964 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2018 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2012-2019 The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1269,7 +1269,7 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 
 	/* shall we wake net queues? */
 	if (desc_cnt)
-		wil_update_net_queues(wil, vif, NULL, false);
+		wil_update_net_queues(wil, vif, ring, false);
 
 	/* Update the HW tail ptr (RD ptr) */
 	wil_w(wil, sring->hwtail, (sring->swhead - 1) % sring->size);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1a8701e..3f2ea37 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -63,6 +63,8 @@
  */
 #define WIL_MAX_VIFS 4
 
+#define WIL6210_TX_AC_QUEUES (4)
+
 /**
  * extract bits [@b0:@b1] (inclusive) from the value @x
  * it should be @b0 <= @b1, or result is incorrect
@@ -752,6 +754,7 @@ struct wil_sta_info {
 	struct wil_tid_crypto_rx tid_crypto_rx[WIL_STA_TID_NUM];
 	struct wil_tid_crypto_rx group_crypto_rx;
 	u8 aid; /* 1-254; 0 if unknown/not reported */
+	u8 net_queue_stopped; /* used when q_per_sta enabled */
 };
 
 enum {
@@ -866,7 +869,7 @@ struct wil6210_vif {
 	struct list_head probe_client_pending;
 	struct mutex probe_client_mutex; /* protect @probe_client_pending */
 	struct work_struct probe_client_worker;
-	int net_queue_stopped; /* netif_tx_stop_all_queues invoked */
+	int net_queue_stopped; /* used when q_per_sta disabled */
 	bool fw_stats_ready; /* per-cid statistics are ready inside sta_info */
 	u64 fw_stats_tsf; /* measurement timestamp */
 };
@@ -1053,6 +1056,8 @@ struct wil6210_priv {
 #define vif_to_wil(v) (v->wil)
 #define vif_to_ndev(v) (v->ndev)
 #define vif_to_wdev(v) (&v->wdev)
+#define WIL_Q_PER_STA_USED(v) (vif_to_wil(v)->config.q_per_sta && \
+			       v->wdev.iftype == NL80211_IFTYPE_AP)
 
 static inline struct wil6210_vif *wdev_to_vif(struct wil6210_priv *wil,
 					      struct wireless_dev *wdev)
@@ -1330,10 +1335,19 @@ void wil6210_disconnect_complete(struct wil6210_vif *vif, const u8 *bssid,
 void wil_bcast_fini(struct wil6210_vif *vif);
 void wil_bcast_fini_all(struct wil6210_priv *wil);
 
-void wil_update_net_queues(struct wil6210_priv *wil, struct wil6210_vif *vif,
-			   struct wil_ring *ring, bool should_stop);
-void wil_update_net_queues_bh(struct wil6210_priv *wil, struct wil6210_vif *vif,
-			      struct wil_ring *ring, bool check_stop);
+void wil_update_net_queues(struct wil6210_priv *wil,
+			   struct wil6210_vif *vif,
+			   struct wil_ring *ring,
+			   bool check_stop);
+void wil_update_net_queues_bh(struct wil6210_priv *wil,
+			      struct wil6210_vif *vif,
+			      struct wil_ring *ring,
+			      bool check_stop);
+void wil_update_cid_net_queues_bh(struct wil6210_priv *wil,
+				  struct wil6210_vif *vif,
+				  int cid,
+				  bool check_stop);
+
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int wil_tx_complete(struct wil6210_vif *vif, int ringid);
 void wil6210_unmask_irq_tx(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index cab6af3..aca5d0d 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -62,6 +62,8 @@ struct wil_platform_config {
 	unsigned int max_assoc_sta;
 	/* enable access category for transmit packets, default - no */
 	u8 ac_queues;
+	/* enable allocating tx queue(s) per station, default - no */
+	u8 q_per_sta;
 };
 
 /**
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 325635a..0b2ecc0 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1077,7 +1077,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 	wil->sta[evt->cid].aid = evt->aid;
 	if (!test_and_set_bit(wil_vif_fwconnected, vif->status))
 		atomic_inc(&wil->connected_vifs);
-	wil_update_net_queues_bh(wil, vif, NULL, false);
+	wil_update_cid_net_queues_bh(wil, vif, evt->cid, false);
 
 out:
 	if (rc) {
-- 
1.9.1

