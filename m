Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC9DC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE5EA20880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfA1Pms (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:48 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:25405 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfA1Pmr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:47 -0500
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881354"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:32 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037504"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:31 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 06/12] wil6210: support up to 20 stations in AP mode
Date:   Mon, 28 Jan 2019 17:36:20 +0200
Message-Id: <1548689786-23288-7-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

New FW added support for upto 20 clients in AP mode. Change the driver
to support this as well. FW reports it's max supported associations in
WMI_READY_EVENT. Some WMI commands/events use cidxtid field which is
limited to 16 cids. Use new cid/tid fields instead.

For Rx packets cid from rx descriptor is limited to 3 bits (0..7),
to find the real cid, compare transmitter address with the stored
stations mac address in the driver sta array.

EDMA FW still supports 8 stations. Extending the support to 20
stations will come later.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  10 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |  22 ++--
 drivers/net/wireless/ath/wil6210/main.c       |   8 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |   4 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  10 +-
 drivers/net/wireless/ath/wil6210/trace.h      |   3 +-
 drivers/net/wireless/ath/wil6210/txrx.c       | 142 ++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/txrx.h       |  26 +++++
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |   6 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  27 ++---
 drivers/net/wireless/ath/wil6210/wmi.c        |  79 +++++++++++---
 11 files changed, 245 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 955571f..8d5b388 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -391,7 +391,7 @@ static int wil_find_cid_by_idx(struct wil6210_priv *wil, u8 mid, int idx)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		if (wil->sta[i].status == wil_sta_unused)
 			continue;
 		if (wil->sta[i].mid != mid)
@@ -1778,7 +1778,8 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	/* wake default net queue - used mainly for multicast */
 	if (wil->config.q_per_sta)
-		wil_update_cid_net_queues_bh(wil, vif, WIL6210_MAX_CID, false);
+		wil_update_cid_net_queues_bh(wil, vif,
+					     wil->config.max_assoc_sta, false);
 
 	goto out; /* success */
 
@@ -1971,7 +1972,8 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 
 	/* stop default net queue - used mainly for multicast */
 	if (wil->config.q_per_sta)
-		wil_update_cid_net_queues_bh(wil, vif, WIL6210_MAX_CID, true);
+		wil_update_cid_net_queues_bh(wil, vif,
+					     wil->config.max_assoc_sta, true);
 
 	if (last)
 		__wil_down(wil);
@@ -3008,7 +3010,7 @@ static int wil_rf_sector_set_selected(struct wiphy *wiphy,
 			wil, vif->mid, WMI_INVALID_RF_SECTOR_INDEX,
 			sector_type, WIL_CID_ALL);
 		if (rc == -EINVAL) {
-			for (i = 0; i < WIL6210_MAX_CID; i++) {
+			for (i = 0; i < wil->config.max_assoc_sta; i++) {
 				if (wil->sta[i].mid != vif->mid)
 					continue;
 				rc = wil_rf_sector_wmi_set_selected(
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 835c902..e8f6d76 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -162,7 +162,7 @@ static int ring_show(struct seq_file *s, void *data)
 
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			if (cid < WIL6210_MAX_CID)
+			if (cid < wil->config.max_assoc_sta)
 				seq_printf(s,
 					   "\n%pM CID %d TID %d 1x%s BACK([%u] %u TU A%s) [%3d|%3d] idle %s\n",
 					   wil->sta[cid].addr, cid, tid,
@@ -792,14 +792,14 @@ static ssize_t wil_write_back(struct file *file, const char __user *buf,
 				"BACK: del_rx require at least 2 params\n");
 			return -EINVAL;
 		}
-		if (p1 < 0 || p1 >= WIL6210_MAX_CID) {
+		if (p1 < 0 || p1 >= wil->config.max_assoc_sta) {
 			wil_err(wil, "BACK: invalid CID %d\n", p1);
 			return -EINVAL;
 		}
 		if (rc < 4)
 			p3 = WLAN_REASON_QSTA_LEAVE_QBSS;
 		sta = &wil->sta[p1];
-		wmi_delba_rx(wil, sta->mid, mk_cidxtid(p1, p2), p3);
+		wmi_delba_rx(wil, sta->mid, p1, p2, p3);
 	} else {
 		wil_err(wil, "BACK: Unrecognized command \"%s\"\n", cmd);
 		return -EINVAL;
@@ -1243,7 +1243,7 @@ static int bf_show(struct seq_file *s, void *data)
 
 	memset(&reply, 0, sizeof(reply));
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		u32 status;
 
 		cmd.cid = i;
@@ -1340,7 +1340,7 @@ static int link_show(struct seq_file *s, void *data)
 	if (!sinfo)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		struct wil6210_vif *vif;
@@ -1542,7 +1542,7 @@ static int sta_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int i, tid, mcs;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		u8 aid = 0;
@@ -1651,7 +1651,7 @@ static int wil_tx_latency_debugfs_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int i, bin;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		u8 aid = 0;
@@ -1740,7 +1740,7 @@ static ssize_t wil_tx_latency_write(struct file *file, const char __user *buf,
 		size_t sz = sizeof(u64) * WIL_NUM_LATENCY_BINS;
 
 		wil->tx_latency_res = val;
-		for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		for (i = 0; i < wil->config.max_assoc_sta; i++) {
 			struct wil_sta_info *sta = &wil->sta[i];
 
 			kfree(sta->tx_latency_bins);
@@ -1825,7 +1825,7 @@ static void wil_link_stats_debugfs_show_vif(struct wil6210_vif *vif,
 	}
 
 	seq_printf(s, "TSF %lld\n", vif->fw_stats_tsf);
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		if (wil->sta[i].status == wil_sta_unused)
 			continue;
 		if (wil->sta[i].mid != vif->mid)
@@ -2439,7 +2439,7 @@ void wil6210_debugfs_remove(struct wil6210_priv *wil)
 	wil->debug = NULL;
 
 	kfree(wil->dbg_data.data_arr);
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++)
+	for (i = 0; i < wil->config.max_assoc_sta; i++)
 		kfree(wil->sta[i].tx_latency_bins);
 
 	/* free pmc memory without sending command to fw, as it will
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index aa3f3bd..1c2823b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -174,7 +174,7 @@ static bool wil_vif_is_connected(struct wil6210_priv *wil, u8 mid)
 {
 	int i;
 
-	for (i = 0; i < WIL6210_MAX_CID; i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		if (wil->sta[i].mid == mid &&
 		    wil->sta[i].status == wil_sta_connected)
 			return true;
@@ -280,7 +280,7 @@ static void _wil6210_disconnect_complete(struct wil6210_vif *vif,
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect complete all\n");
-		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
+		for (cid = 0; cid < wil->config.max_assoc_sta; cid++)
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	}
 
@@ -395,7 +395,7 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 			wil_disconnect_cid(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect all\n");
-		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
+		for (cid = 0; cid < wil->config.max_assoc_sta; cid++)
 			wil_disconnect_cid(vif, cid, reason_code);
 	}
 
@@ -1875,7 +1875,7 @@ int wil_find_cid(struct wil6210_priv *wil, u8 mid, const u8 *mac)
 	int i;
 	int rc = -ENOENT;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < wil->config.max_assoc_sta; i++) {
 		if (wil->sta[i].mid == mid &&
 		    wil->sta[i].status != wil_sta_unused &&
 		    ether_addr_equal(wil->sta[i].addr, mac)) {
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index cb925ff..2077898 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -132,13 +132,13 @@ static u16 wil_select_queue(struct net_device *ndev,
 
 	mcast = is_multicast_ether_addr(eth->h_dest);
 	if (mcast) {
-		qid = WIL6210_MAX_CID;
+		qid = wil->config.max_assoc_sta;
 	} else {
 		qid = wil_find_cid(wil, vif->mid, eth->h_dest);
 
 		/* the MCAST queues also used as default queues */
 		if (qid < 0)
-			qid = WIL6210_MAX_CID;
+			qid = wil->config.max_assoc_sta;
 	}
 
 out:
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 983bd00..dd02142 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2014-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -307,8 +307,8 @@ static u16 wil_agg_size(struct wil6210_priv *wil, u16 req_agg_wsize)
 }
 
 /* Block Ack - Rx side (recipient) */
-int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
-			 u8 cidxtid, u8 dialog_token, __le16 ba_param_set,
+int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid, u8 cid, u8 tid,
+			 u8 dialog_token, __le16 ba_param_set,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl)
 __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 {
@@ -316,7 +316,6 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
 	u16 agg_timeout = le16_to_cpu(ba_timeout);
 	u16 seq_ctrl = le16_to_cpu(ba_seq_ctrl);
 	struct wil_sta_info *sta;
-	u8 cid, tid;
 	u16 agg_wsize = 0;
 	/* bit 0: A-MSDU supported
 	 * bit 1: policy (should be 0 for us)
@@ -335,10 +334,9 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
 	int rc = 0;
 
 	might_sleep();
-	parse_cidxtid(cidxtid, &cid, &tid);
 
 	/* sanity checks */
-	if (cid >= WIL6210_MAX_CID) {
+	if (cid >= wil->config.max_assoc_sta) {
 		wil_err(wil, "BACK: invalid CID %d\n", cid);
 		rc = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/ath/wil6210/trace.h b/drivers/net/wireless/ath/wil6210/trace.h
index 853abc3..36ebfcf 100644
--- a/drivers/net/wireless/ath/wil6210/trace.h
+++ b/drivers/net/wireless/ath/wil6210/trace.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2013-2016 Qualcomm Atheros, Inc.
+ * Copyright (c) 2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -181,7 +182,7 @@
 		__entry->seq = wil_rxdesc_seq(d);
 		__entry->mcs = wil_rxdesc_mcs(d);
 	),
-	TP_printk("index %d len %d mid %d cid %d tid %d mcs %d seq 0x%03x"
+	TP_printk("index %d len %d mid %d cid (%%8) %d tid %d mcs %d seq 0x%03x"
 		  " type 0x%1x subtype 0x%1x", __entry->index, __entry->len,
 		  __entry->mid, __entry->cid, __entry->tid, __entry->mcs,
 		  __entry->seq, __entry->type, __entry->subtype)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 00996f1..a09e0d3 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -362,6 +362,79 @@ static bool wil_is_rx_idle(struct wil6210_priv *wil)
 	return true;
 }
 
+static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
+{
+	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
+	int mid = wil_rxdesc_mid(d);
+	struct wil6210_vif *vif = wil->vifs[mid];
+	/* cid from DMA descriptor is limited to 3 bits.
+	 * In case of cid>=8, the value would be cid modulo 8 and we need to
+	 * find real cid by locating the transmitter (ta) inside sta array
+	 */
+	int cid = wil_rxdesc_cid(d);
+	unsigned int snaplen = wil_rx_snaplen(wil);
+	struct ethhdr *eth;
+	struct ieee80211_hdr_3addr *hdr;
+	int i;
+	unsigned char *ta;
+	u8 ftype;
+
+	/* in monitor mode there are no connections */
+	if (vif->wdev.iftype == NL80211_IFTYPE_MONITOR)
+		return cid;
+
+	ftype = wil_rxdesc_ftype(d) << 2;
+	if (likely(ftype == IEEE80211_FTYPE_DATA)) {
+		if (unlikely(skb->len < ETH_HLEN + snaplen)) {
+			wil_err_ratelimited(wil,
+					    "Short data frame, len = %d\n",
+					    skb->len);
+			return -ENOENT;
+		}
+		eth = (void *)skb->data;
+		ta = eth->h_source;
+	} else {
+		if (unlikely(skb->len < sizeof(struct ieee80211_hdr_3addr))) {
+			wil_err_ratelimited(wil, "Short frame, len = %d\n",
+					    skb->len);
+			return -ENOENT;
+		}
+		hdr = (void *)skb->data;
+		ta = hdr->addr2;
+	}
+
+	if (wil->config.max_assoc_sta <= WIL6210_RX_DESC_MAX_CID)
+		return cid;
+
+	/* assuming no concurrency between AP interfaces and STA interfaces.
+	 * multista is used only in P2P_GO or AP mode. In other modes return
+	 * cid from the rx descriptor
+	 */
+	if (vif->wdev.iftype != NL80211_IFTYPE_P2P_GO &&
+	    vif->wdev.iftype != NL80211_IFTYPE_AP)
+		return cid;
+
+	/* For Rx packets cid from rx descriptor is limited to 3 bits (0..7),
+	 * to find the real cid, compare transmitter address with the stored
+	 * stations mac address in the driver sta array
+	 */
+	for (i = cid; i < wil->config.max_assoc_sta;
+	     i += WIL6210_RX_DESC_MAX_CID) {
+		if (wil->sta[i].status != wil_sta_unused &&
+		    ether_addr_equal(wil->sta[i].addr, ta)) {
+			cid = i;
+			break;
+		}
+	}
+	if (i >= wil->config.max_assoc_sta) {
+		wil_err_ratelimited(wil, "Could not find cid for frame with transmit addr = %pM, iftype = %d, frametype = %d, len = %d\n",
+				    ta, vif->wdev.iftype, ftype, skb->len);
+		cid = -ENOENT;
+	}
+
+	return cid;
+}
+
 /**
  * reap 1 frame from @swhead
  *
@@ -387,7 +460,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	int i;
 	struct wil_net_stats *stats;
 
-	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
+	BUILD_BUG_ON(sizeof(struct skb_rx_info) > sizeof(skb->cb));
 
 again:
 	if (unlikely(wil_ring_is_empty(vring)))
@@ -419,7 +492,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("RxD ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
-	cid = wil_rxdesc_cid(d);
 	mid = wil_rxdesc_mid(d);
 	vif = wil->vifs[mid];
 
@@ -430,11 +502,9 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		goto again;
 	}
 	ndev = vif_to_ndev(vif);
-	stats = &wil->sta[cid].stats;
-
 	if (unlikely(dmalen > sz)) {
-		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
-		stats->rx_large_frame++;
+		wil_err_ratelimited(wil, "Rx size too large: %d bytes!\n",
+				    dmalen);
 		kfree_skb(skb);
 		goto again;
 	}
@@ -445,6 +515,14 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
+	cid = wil_rx_get_cid_by_skb(wil, skb);
+	if (cid == -ENOENT) {
+		kfree_skb(skb);
+		goto again;
+	}
+	wil_skb_set_cid(skb, (u8)cid);
+	stats = &wil->sta[cid].stats;
+
 	stats->last_mcs_rx = wil_rxdesc_mcs(d);
 	if (stats->last_mcs_rx < ARRAY_SIZE(stats->rx_per_mcs))
 		stats->rx_per_mcs[stats->last_mcs_rx]++;
@@ -491,13 +569,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		goto again;
 	}
 
-	if (unlikely(skb->len < ETH_HLEN + snaplen)) {
-		wil_err(wil, "Short frame, len = %d\n", skb->len);
-		stats->rx_short_frame++;
-		kfree_skb(skb);
-		goto again;
-	}
-
 	/* L4 IDENT is on when HW calculated checksum, check status
 	 * and in case of error drop the packet
 	 * higher stack layers will handle retransmission (if required)
@@ -594,7 +665,7 @@ int reverse_memcmp(const void *cs, const void *ct, size_t count)
 static int wil_rx_crypto_check(struct wil6210_priv *wil, struct sk_buff *skb)
 {
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
-	int cid = wil_rxdesc_cid(d);
+	int cid = wil_skb_get_cid(skb);
 	int tid = wil_rxdesc_tid(d);
 	int key_id = wil_rxdesc_key_id(d);
 	int mc = wil_rxdesc_mcast(d);
@@ -642,7 +713,7 @@ static void wil_get_netif_rx_params(struct sk_buff *skb, int *cid,
 {
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
 
-	*cid = wil_rxdesc_cid(d); /* always 0..7, no need to check */
+	*cid = wil_skb_get_cid(skb);
 	*security = wil_rxdesc_security(d);
 }
 
@@ -909,7 +980,6 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 				.ring_size = cpu_to_le16(size),
 			},
 			.ringid = id,
-			.cidxtid = mk_cidxtid(cid, tid),
 			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
 			.mac_ctrl = 0,
 			.to_resolution = 0,
@@ -929,6 +999,14 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 	struct wil_ring *vring = &wil->ring_tx[id];
 	struct wil_ring_tx_data *txdata = &wil->ring_tx_data[id];
 
+	if (cid >= WIL6210_RX_DESC_MAX_CID) {
+		cmd.vring_cfg.cidxtid = CIDXTID_EXTENDED_CID_TID;
+		cmd.vring_cfg.cid = cid;
+		cmd.vring_cfg.tid = tid;
+	} else {
+		cmd.vring_cfg.cidxtid = mk_cidxtid(cid, tid);
+	}
+
 	wil_dbg_misc(wil, "vring_init_tx: max_mpdu_size %d\n",
 		     cmd.vring_cfg.tx_sw_ring.max_mpdu_size);
 	lockdep_assert_held(&wil->mutex);
@@ -981,7 +1059,7 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
 	wil_vring_free(wil, vring);
-	wil->ring2cid_tid[id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[id][0] = wil->config.max_assoc_sta;
 	wil->ring2cid_tid[id][1] = 0;
 
  out:
@@ -1066,7 +1144,7 @@ static int wil_tx_vring_modify(struct wil6210_vif *vif, int ring_id, int cid,
 	txdata->dot1x_open = false;
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
-	wil->ring2cid_tid[ring_id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[ring_id][0] = wil->config.max_assoc_sta;
 	wil->ring2cid_tid[ring_id][1] = 0;
 	return rc;
 }
@@ -1113,7 +1191,7 @@ int wil_vring_init_bcast(struct wil6210_vif *vif, int id, int size)
 	if (rc)
 		goto out;
 
-	wil->ring2cid_tid[id][0] = WIL6210_MAX_CID; /* CID */
+	wil->ring2cid_tid[id][0] = wil->config.max_assoc_sta; /* CID */
 	wil->ring2cid_tid[id][1] = 0; /* TID */
 
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
@@ -1169,7 +1247,7 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 	else
 		cid = wil_find_cid(wil, vif->mid, eth->h_dest);
 
-	if (cid < 0 || cid >= WIL6210_MAX_CID)
+	if (cid < 0 || cid >= wil->config.max_assoc_sta)
 		return NULL;
 
 	/* TODO: fix for multiple TID */
@@ -1221,7 +1299,7 @@ static struct wil_ring *wil_find_tx_ring_sta(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (cid >= wil->config.max_assoc_sta) /* skip BCAST */
 			continue;
 
 		if (!wil->ring_tx_data[i].dot1x_open &&
@@ -1300,7 +1378,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (cid >= wil->config.max_assoc_sta) /* skip BCAST */
 			continue;
 		if (!wil->ring_tx_data[i].dot1x_open &&
 		    skb->protocol != cpu_to_be16(ETH_P_PAE))
@@ -1328,7 +1406,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 		if (!v2->va || txdata2->mid != vif->mid)
 			continue;
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (cid >= wil->config.max_assoc_sta) /* skip BCAST */
 			continue;
 		if (!wil->ring_tx_data[i].dot1x_open &&
 		    skb->protocol != cpu_to_be16(ETH_P_PAE))
@@ -1952,7 +2030,7 @@ static int wil_get_cid_by_ring(struct wil6210_priv *wil,
 	if (unlikely(ring_index < 0 || ring_index >= WIL6210_MAX_TX_RINGS)) {
 		wil_err(wil, "cid by ring 0x%p: invalid ring index %d\n",
 			ring, ring_index);
-		return WIL6210_MAX_CID;
+		return wil->config.max_assoc_sta;
 	}
 
 	return wil->ring2cid_tid[ring_index][0];
@@ -1976,7 +2054,7 @@ static void wil_tx_stop_cid_queues(struct wil6210_priv *wil,
 
 		netif_tx_stop_queue(txq);
 	}
-	if (cid < WIL6210_MAX_CID)
+	if (cid < wil->config.max_assoc_sta)
 		wil->sta[cid].net_queue_stopped = true;
 }
 
@@ -1998,7 +2076,7 @@ static void wil_tx_wake_cid_queues(struct wil6210_priv *wil,
 
 		netif_tx_wake_queue(txq);
 	}
-	if (cid < WIL6210_MAX_CID)
+	if (cid < wil->config.max_assoc_sta)
 		wil->sta[cid].net_queue_stopped = false;
 }
 
@@ -2011,7 +2089,7 @@ static inline void __wil_update_net_queues_per_sta(struct wil6210_priv *wil,
 
 	/* ring is not null - checked by caller */
 	cid = wil_get_cid_by_ring(wil, vif, ring);
-	if (cid < WIL6210_MAX_CID &&
+	if (cid < wil->config.max_assoc_sta &&
 	    check_stop == wil->sta[cid].net_queue_stopped)
 		/* net queues already in desired state */
 		return;
@@ -2083,7 +2161,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 			netif_tx_stop_all_queues(vif_to_ndev(vif));
 			vif->net_queue_stopped = true;
 			if (WIL_Q_PER_STA_USED(vif))
-				for (i = 0; i < WIL6210_MAX_CID; i++)
+				for (i = 0; i < wil->config.max_assoc_sta; i++)
 					wil->sta[i].net_queue_stopped = true;
 			wil_dbg_txrx(wil, "netif_tx_stop called\n");
 		}
@@ -2117,7 +2195,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		netif_tx_wake_all_queues(vif_to_ndev(vif));
 		vif->net_queue_stopped = false;
 		if (WIL_Q_PER_STA_USED(vif))
-			for (i = 0; i < WIL6210_MAX_CID; i++)
+			for (i = 0; i < wil->config.max_assoc_sta; i++)
 				wil->sta[i].net_queue_stopped = false;
 	}
 }
@@ -2152,7 +2230,7 @@ void wil_update_cid_net_queues_bh(struct wil6210_priv *wil,
 		return;
 	}
 
-	if (cid < WIL6210_MAX_CID &&
+	if (cid < wil->config.max_assoc_sta &&
 	    should_stop == wil->sta[cid].net_queue_stopped)
 		/* net queues already in desired state */
 		return;
@@ -2304,7 +2382,7 @@ int wil_tx_complete(struct wil6210_vif *vif, int ringid)
 
 	used_before_complete = wil_ring_used_tx(vring);
 
-	if (cid < WIL6210_MAX_CID)
+	if (cid < wil->config.max_assoc_sta)
 		stats = &wil->sta[cid].stats;
 
 	while (!wil_ring_is_empty(vring)) {
@@ -2413,7 +2491,7 @@ static void wil_get_reorder_params(struct wil6210_priv *wil,
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
 
 	*tid = wil_rxdesc_tid(d);
-	*cid = wil_rxdesc_cid(d);
+	*cid = wil_skb_get_cid(skb);
 	*mid = wil_rxdesc_mid(d);
 	*seq = wil_rxdesc_seq(d);
 	*mcast = wil_rxdesc_mcast(d);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index bc81444..1aec04d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -458,6 +458,18 @@ struct vring_rx_desc {
 	union wil_rx_desc rx;
 } __packed;
 
+struct packet_rx_info {
+	u8 cid;
+};
+
+/* this struct will be stored in the skb cb buffer
+ * max length of the struct is limited to 48 bytes
+ */
+struct skb_rx_info {
+	struct vring_rx_desc rx_desc;
+	struct packet_rx_info rx_info;
+};
+
 static inline int wil_rxdesc_tid(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->mac.d0, 0, 3);
@@ -605,6 +617,20 @@ static inline bool wil_val_in_range(int val, int min, int max)
 	return val >= min && val < max;
 }
 
+static inline u8 wil_skb_get_cid(struct sk_buff *skb)
+{
+	struct skb_rx_info *skb_rx_info = (void *)skb->cb;
+
+	return skb_rx_info->rx_info.cid;
+}
+
+static inline void wil_skb_set_cid(struct sk_buff *skb, u8 cid)
+{
+	struct skb_rx_info *skb_rx_info = (void *)skb->cb;
+
+	skb_rx_info->rx_info.cid = cid;
+}
+
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev);
 void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb);
 void wil_rx_bar(struct wil6210_priv *wil, struct wil6210_vif *vif,
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 432a964..ae0d123 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -727,7 +727,7 @@ static int wil_ring_init_tx_edma(struct wil6210_vif *vif, int ring_id,
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
 	wil_ring_free_edma(wil, ring);
-	wil->ring2cid_tid[ring_id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[ring_id][0] = wil->config.max_assoc_sta;
 	wil->ring2cid_tid[ring_id][1] = 0;
 
  out:
@@ -932,7 +932,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	eop = wil_rx_status_get_eop(msg);
 
 	cid = wil_rx_status_get_cid(msg);
-	if (unlikely(!wil_val_in_range(cid, 0, WIL6210_MAX_CID))) {
+	if (unlikely(!wil_val_in_range(cid, 0, wil->config.max_assoc_sta))) {
 		wil_err(wil, "Corrupt cid=%d, sring->swhead=%d\n",
 			cid, sring->swhead);
 		rxdata->skipping = true;
@@ -1187,7 +1187,7 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 		ndev = vif_to_ndev(vif);
 
 		cid = wil->ring2cid_tid[ring_id][0];
-		if (cid < WIL6210_MAX_CID)
+		if (cid < wil->config.max_assoc_sta)
 			stats = &wil->sta[cid].stats;
 
 		wil_dbg_txrx(wil,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3f2ea37..cc46873 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -87,7 +87,8 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL_RING_SIZE_ORDER_MIN	(5)
 #define WIL_RING_SIZE_ORDER_MAX	(15)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
-#define WIL6210_MAX_CID		(8) /* HW limit */
+#define WIL6210_MAX_CID		(20) /* max number of stations */
+#define WIL6210_RX_DESC_MAX_CID	(8)  /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
 #define WIL_MAX_AMPDU_SIZE	(64 * 1024) /* FW/HW limit */
 #define WIL_MAX_AGG_WSIZE	(32) /* FW/HW limit */
@@ -448,15 +449,6 @@ static inline void parse_cidxtid(u8 cidxtid, u8 *cid, u8 *tid)
 	*tid = (cidxtid >> 4) & 0xf;
 }
 
-/**
- * wil_cid_valid - check cid is valid
- * @cid: CID value
- */
-static inline bool wil_cid_valid(u8 cid)
-{
-	return cid < WIL6210_MAX_CID;
-}
-
 struct wil6210_mbox_ring {
 	u32 base;
 	u16 entry_size; /* max. size of mbox entry, incl. all headers */
@@ -1170,6 +1162,15 @@ void wil_hex_dump_misc(const char *prefix_str, int prefix_type, int rowsize,
 }
 #endif /* defined(CONFIG_DYNAMIC_DEBUG) */
 
+/**
+ * wil_cid_valid - check cid is valid
+ * @cid: CID value
+ */
+static inline bool wil_cid_valid(struct wil6210_priv *wil, u8 cid)
+{
+	return (cid >= 0 && cid < wil->config.max_assoc_sta);
+}
+
 void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 			  size_t count);
 void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
@@ -1237,7 +1238,7 @@ int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac, u16 reason,
 int wmi_addba(struct wil6210_priv *wil, u8 mid,
 	      u8 ringid, u8 size, u16 timeout);
 int wmi_delba_tx(struct wil6210_priv *wil, u8 mid, u8 ringid, u16 reason);
-int wmi_delba_rx(struct wil6210_priv *wil, u8 mid, u8 cidxtid, u16 reason);
+int wmi_delba_rx(struct wil6210_priv *wil, u8 mid, u8 cid, u8 tid, u16 reason);
 int wmi_addba_rx_resp(struct wil6210_priv *wil,
 		      u8 mid, u8 cid, u8 tid, u8 token,
 		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout);
@@ -1250,8 +1251,8 @@ int wmi_port_allocate(struct wil6210_priv *wil, u8 mid,
 		      const u8 *mac, enum nl80211_iftype iftype);
 int wmi_port_delete(struct wil6210_priv *wil, u8 mid);
 int wmi_link_stats_cfg(struct wil6210_vif *vif, u32 type, u8 cid, u32 interval);
-int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
-			 u8 cidxtid, u8 dialog_token, __le16 ba_param_set,
+int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid, u8 cid, u8 tid,
+			 u8 dialog_token, __le16 ba_param_set,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
 int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid, u16 wsize);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0b2ecc0..d86fc31 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -766,6 +766,7 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
 	struct wil6210_priv *wil = vif_to_wil(vif);
 	struct wiphy *wiphy = wil_to_wiphy(wil);
 	struct wmi_ready_event *evt = d;
+	u8 fw_max_assoc_sta;
 
 	wil_info(wil, "FW ver. %s(SW %d); MAC %pM; %d MID's\n",
 		 wil->fw_version, le32_to_cpu(evt->sw_version),
@@ -783,6 +784,27 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
 			    evt->rfc_read_calib_result);
 		wil->fw_calib_result = evt->rfc_read_calib_result;
 	}
+
+	fw_max_assoc_sta = WIL6210_RX_DESC_MAX_CID;
+	if (len > offsetof(struct wmi_ready_event, max_assoc_sta) &&
+	    evt->max_assoc_sta > 0) {
+		fw_max_assoc_sta = evt->max_assoc_sta;
+		wil_dbg_wmi(wil, "fw reported max assoc sta %d\n",
+			    fw_max_assoc_sta);
+
+		if (fw_max_assoc_sta > WIL6210_MAX_CID) {
+			wil_dbg_wmi(wil,
+				    "fw max assoc sta %d exceeds max driver supported %d\n",
+				    fw_max_assoc_sta, WIL6210_MAX_CID);
+			fw_max_assoc_sta = WIL6210_MAX_CID;
+		}
+	}
+
+	wil->config.max_assoc_sta = min_t(uint, wil->config.max_assoc_sta,
+					  fw_max_assoc_sta);
+	wil_dbg_wmi(wil, "setting max assoc sta to %d\n",
+		    wil->config.max_assoc_sta);
+
 	wil_set_recovery_state(wil, fw_recovery_idle);
 	set_bit(wil_status_fwready, wil->status);
 	/* let the reset sequence continue */
@@ -948,7 +970,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 			evt->assoc_req_len, evt->assoc_resp_len);
 		return;
 	}
-	if (evt->cid >= WIL6210_MAX_CID) {
+	if (evt->cid >= wil->config.max_assoc_sta) {
 		wil_err(wil, "Connect CID invalid : %d\n", evt->cid);
 		return;
 	}
@@ -1210,7 +1232,7 @@ static void wmi_evt_ring_en(struct wil6210_vif *vif, int id, void *d, int len)
 		return;
 
 	cid = wil->ring2cid_tid[vri][0];
-	if (!wil_cid_valid(cid)) {
+	if (!wil_cid_valid(wil, cid)) {
 		wil_err(wil, "invalid cid %d for vring %d\n", cid, vri);
 		return;
 	}
@@ -1267,9 +1289,16 @@ static void wmi_evt_addba_rx_req(struct wil6210_vif *vif, int id,
 				 void *d, int len)
 {
 	struct wil6210_priv *wil = vif_to_wil(vif);
+	u8 cid, tid;
 	struct wmi_rcp_addba_req_event *evt = d;
 
-	wil_addba_rx_request(wil, vif->mid, evt->cidxtid, evt->dialog_token,
+	if (evt->cidxtid != CIDXTID_EXTENDED_CID_TID) {
+		parse_cidxtid(evt->cidxtid, &cid, &tid);
+	} else {
+		cid = evt->cid;
+		tid = evt->tid;
+	}
+	wil_addba_rx_request(wil, vif->mid, cid, tid, evt->dialog_token,
 			     evt->ba_param_set, evt->ba_timeout,
 			     evt->ba_seq_ctrl);
 }
@@ -1285,7 +1314,13 @@ static void wmi_evt_delba(struct wil6210_vif *vif, int id, void *d, int len)
 	struct wil_tid_ampdu_rx *r;
 
 	might_sleep();
-	parse_cidxtid(evt->cidxtid, &cid, &tid);
+
+	if (evt->cidxtid != CIDXTID_EXTENDED_CID_TID) {
+		parse_cidxtid(evt->cidxtid, &cid, &tid);
+	} else {
+		cid = evt->cid;
+		tid = evt->tid;
+	}
 	wil_dbg_wmi(wil, "DELBA MID %d CID %d TID %d from %s reason %d\n",
 		    vif->mid, cid, tid,
 		    evt->from_initiator ? "originator" : "recipient",
@@ -1400,7 +1435,7 @@ static void wil_link_stats_store_basic(struct wil6210_vif *vif,
 	u8 cid = basic->cid;
 	struct wil_sta_info *sta;
 
-	if (cid < 0 || cid >= WIL6210_MAX_CID) {
+	if (cid < 0 || cid >= wil->config.max_assoc_sta) {
 		wil_err(wil, "invalid cid %d\n", cid);
 		return;
 	}
@@ -1550,7 +1585,7 @@ static int wil_find_cid_ringid_sta(struct wil6210_priv *wil,
 			continue;
 
 		lcid = wil->ring2cid_tid[i][0];
-		if (lcid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (lcid >= wil->config.max_assoc_sta) /* skip BCAST */
 			continue;
 
 		wil_dbg_wmi(wil, "find sta -> ringid %d cid %d\n", i, lcid);
@@ -2116,11 +2151,9 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 
 	if ((cmd.pcp_max_assoc_sta > WIL6210_MAX_CID) ||
 	    (cmd.pcp_max_assoc_sta <= 0)) {
-		wil_info(wil,
-			 "Requested connection limit %u, valid values are 1 - %d. Setting to %d\n",
-			 wil->config.max_assoc_sta, WIL6210_MAX_CID,
-			 WIL6210_MAX_CID);
-		cmd.pcp_max_assoc_sta = WIL6210_MAX_CID;
+		wil_err(wil, "unexpected max_assoc_sta %d\n",
+			cmd.pcp_max_assoc_sta);
+		return -EOPNOTSUPP;
 	}
 
 	if (wil->config.disable_ap_sme &&
@@ -2648,15 +2681,22 @@ int wmi_delba_tx(struct wil6210_priv *wil, u8 mid, u8 ringid, u16 reason)
 	return wmi_send(wil, WMI_RING_BA_DIS_CMDID, mid, &cmd, sizeof(cmd));
 }
 
-int wmi_delba_rx(struct wil6210_priv *wil, u8 mid, u8 cidxtid, u16 reason)
+int wmi_delba_rx(struct wil6210_priv *wil, u8 mid, u8 cid, u8 tid, u16 reason)
 {
 	struct wmi_rcp_delba_cmd cmd = {
-		.cidxtid = cidxtid,
 		.reason = cpu_to_le16(reason),
 	};
 
-	wil_dbg_wmi(wil, "delba_rx: (CID %d TID %d reason %d)\n", cidxtid & 0xf,
-		    (cidxtid >> 4) & 0xf, reason);
+	if (cid >= WIL6210_RX_DESC_MAX_CID) {
+		cmd.cidxtid = CIDXTID_EXTENDED_CID_TID;
+		cmd.cid = cid;
+		cmd.tid = tid;
+	} else {
+		cmd.cidxtid = mk_cidxtid(cid, tid);
+	}
+
+	wil_dbg_wmi(wil, "delba_rx: (CID %d TID %d reason %d)\n", cid,
+		    tid, reason);
 
 	return wmi_send(wil, WMI_RCP_DELBA_CMDID, mid, &cmd, sizeof(cmd));
 }
@@ -2667,7 +2707,6 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil,
 {
 	int rc;
 	struct wmi_rcp_addba_resp_cmd cmd = {
-		.cidxtid = mk_cidxtid(cid, tid),
 		.dialog_token = token,
 		.status_code = cpu_to_le16(status),
 		/* bit 0: A-MSDU supported
@@ -2686,6 +2725,14 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil,
 		.evt = {.status = cpu_to_le16(WMI_FW_STATUS_FAILURE)},
 	};
 
+	if (cid >= WIL6210_RX_DESC_MAX_CID) {
+		cmd.cidxtid = CIDXTID_EXTENDED_CID_TID;
+		cmd.cid = cid;
+		cmd.tid = tid;
+	} else {
+		cmd.cidxtid = mk_cidxtid(cid, tid);
+	}
+
 	wil_dbg_wmi(wil,
 		    "ADDBA response for MID %d CID %d TID %d size %d timeout %d status %d AMSDU%s\n",
 		    mid, cid, tid, agg_wsize,
-- 
1.9.1

