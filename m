Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF44C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 445C72075C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbfBVOVb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:31 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:22290 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbfBVOVa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:30 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017369"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:24 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285576"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:23 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 03/21] wil6210: support up to 20 stations in AP mode
Date:   Fri, 22 Feb 2019 16:21:01 +0200
Message-Id: <1550845279-16103-4-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
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
 drivers/net/wireless/ath/wil6210/cfg80211.c   |   6 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    |  20 ++--
 drivers/net/wireless/ath/wil6210/main.c       |  10 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  10 +-
 drivers/net/wireless/ath/wil6210/trace.h      |   3 +-
 drivers/net/wireless/ath/wil6210/txrx.c       | 127 +++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/txrx.h       |  26 ++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |   8 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  12 ++-
 drivers/net/wireless/ath/wil6210/wmi.c        |  79 ++++++++++++----
 10 files changed, 226 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9b2f9f5..9a9d55b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -395,7 +395,7 @@ static int wil_find_cid_by_idx(struct wil6210_priv *wil, u8 mid, int idx)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		if (wil->sta[i].status == wil_sta_unused)
 			continue;
 		if (wil->sta[i].mid != mid)
@@ -3007,7 +3007,7 @@ static int wil_rf_sector_set_selected(struct wiphy *wiphy,
 			wil, vif->mid, WMI_INVALID_RF_SECTOR_INDEX,
 			sector_type, WIL_CID_ALL);
 		if (rc == -EINVAL) {
-			for (i = 0; i < WIL6210_MAX_CID; i++) {
+			for (i = 0; i < max_assoc_sta; i++) {
 				if (wil->sta[i].mid != vif->mid)
 					continue;
 				rc = wil_rf_sector_wmi_set_selected(
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index acbf2f0..7ad4e53 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -162,7 +162,7 @@ static int ring_show(struct seq_file *s, void *data)
 
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			if (cid < WIL6210_MAX_CID)
+			if (cid < max_assoc_sta)
 				seq_printf(s,
 					   "\n%pM CID %d TID %d 1x%s BACK([%u] %u TU A%s) [%3d|%3d] idle %s\n",
 					   wil->sta[cid].addr, cid, tid,
@@ -792,14 +792,14 @@ static ssize_t wil_write_back(struct file *file, const char __user *buf,
 				"BACK: del_rx require at least 2 params\n");
 			return -EINVAL;
 		}
-		if (p1 < 0 || p1 >= WIL6210_MAX_CID) {
+		if (p1 < 0 || p1 >= max_assoc_sta) {
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
+	for (i = 0; i < max_assoc_sta; i++) {
 		u32 status;
 
 		cmd.cid = i;
@@ -1340,7 +1340,7 @@ static int link_show(struct seq_file *s, void *data)
 	if (!sinfo)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		struct wil6210_vif *vif;
@@ -1542,7 +1542,7 @@ static int sta_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int i, tid, mcs;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		u8 aid = 0;
@@ -1651,7 +1651,7 @@ static int wil_tx_latency_debugfs_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int i, bin;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		u8 aid = 0;
@@ -1740,7 +1740,7 @@ static ssize_t wil_tx_latency_write(struct file *file, const char __user *buf,
 		size_t sz = sizeof(u64) * WIL_NUM_LATENCY_BINS;
 
 		wil->tx_latency_res = val;
-		for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		for (i = 0; i < max_assoc_sta; i++) {
 			struct wil_sta_info *sta = &wil->sta[i];
 
 			kfree(sta->tx_latency_bins);
@@ -1825,7 +1825,7 @@ static void wil_link_stats_debugfs_show_vif(struct wil6210_vif *vif,
 	}
 
 	seq_printf(s, "TSF %lld\n", vif->fw_stats_tsf);
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		if (wil->sta[i].status == wil_sta_unused)
 			continue;
 		if (wil->sta[i].mid != vif->mid)
@@ -2440,7 +2440,7 @@ void wil6210_debugfs_remove(struct wil6210_priv *wil)
 	wil->debug = NULL;
 
 	kfree(wil->dbg_data.data_arr);
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++)
+	for (i = 0; i < max_assoc_sta; i++)
 		kfree(wil->sta[i].tx_latency_bins);
 
 	/* free pmc memory without sending command to fw, as it will
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 5b7de00..10de16a 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -219,7 +219,7 @@ static bool wil_vif_is_connected(struct wil6210_priv *wil, u8 mid)
 {
 	int i;
 
-	for (i = 0; i < WIL6210_MAX_CID; i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		if (wil->sta[i].mid == mid &&
 		    wil->sta[i].status == wil_sta_connected)
 			return true;
@@ -322,7 +322,7 @@ static void _wil6210_disconnect_complete(struct wil6210_vif *vif,
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect complete all\n");
-		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
+		for (cid = 0; cid < max_assoc_sta; cid++)
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	}
 
@@ -434,7 +434,7 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 			wil_disconnect_cid(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect all\n");
-		for (cid = 0; cid < WIL6210_MAX_CID; cid++)
+		for (cid = 0; cid < max_assoc_sta; cid++)
 			wil_disconnect_cid(vif, cid, reason_code);
 	}
 
@@ -1895,7 +1895,7 @@ int wil_find_cid(struct wil6210_priv *wil, u8 mid, const u8 *mac)
 	int i;
 	int rc = -ENOENT;
 
-	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+	for (i = 0; i < max_assoc_sta; i++) {
 		if (wil->sta[i].mid == mid &&
 		    wil->sta[i].status != wil_sta_unused &&
 		    ether_addr_equal(wil->sta[i].addr, mac)) {
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 983bd00..32b14fc 100644
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
+	if (cid >= max_assoc_sta) {
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
index de259dc..5aa1427 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -372,6 +372,78 @@ static bool wil_is_rx_idle(struct wil6210_priv *wil)
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
+	unsigned int snaplen = wil_rx_snaplen();
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
+	if (max_assoc_sta <= WIL6210_RX_DESC_MAX_CID)
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
+	for (i = cid; i < max_assoc_sta; i += WIL6210_RX_DESC_MAX_CID) {
+		if (wil->sta[i].status != wil_sta_unused &&
+		    ether_addr_equal(wil->sta[i].addr, ta)) {
+			cid = i;
+			break;
+		}
+	}
+	if (i >= max_assoc_sta) {
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
@@ -397,7 +469,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	int i;
 	struct wil_net_stats *stats;
 
-	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
+	BUILD_BUG_ON(sizeof(struct skb_rx_info) > sizeof(skb->cb));
 
 again:
 	if (unlikely(wil_ring_is_empty(vring)))
@@ -429,7 +501,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("RxD ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
-	cid = wil_rxdesc_cid(d);
 	mid = wil_rxdesc_mid(d);
 	vif = wil->vifs[mid];
 
@@ -440,11 +511,9 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
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
@@ -455,6 +524,14 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
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
@@ -501,13 +578,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
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
@@ -604,7 +674,7 @@ int reverse_memcmp(const void *cs, const void *ct, size_t count)
 static int wil_rx_crypto_check(struct wil6210_priv *wil, struct sk_buff *skb)
 {
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
-	int cid = wil_rxdesc_cid(d);
+	int cid = wil_skb_get_cid(skb);
 	int tid = wil_rxdesc_tid(d);
 	int key_id = wil_rxdesc_key_id(d);
 	int mc = wil_rxdesc_mcast(d);
@@ -652,7 +722,7 @@ static void wil_get_netif_rx_params(struct sk_buff *skb, int *cid,
 {
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
 
-	*cid = wil_rxdesc_cid(d); /* always 0..7, no need to check */
+	*cid = wil_skb_get_cid(skb);
 	*security = wil_rxdesc_security(d);
 }
 
@@ -916,7 +986,6 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 				.ring_size = cpu_to_le16(size),
 			},
 			.ringid = id,
-			.cidxtid = mk_cidxtid(cid, tid),
 			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
 			.mac_ctrl = 0,
 			.to_resolution = 0,
@@ -936,6 +1005,14 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
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
@@ -988,7 +1065,7 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
 	wil_vring_free(wil, vring);
-	wil->ring2cid_tid[id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[id][0] = max_assoc_sta;
 	wil->ring2cid_tid[id][1] = 0;
 
  out:
@@ -1073,7 +1150,7 @@ static int wil_tx_vring_modify(struct wil6210_vif *vif, int ring_id, int cid,
 	txdata->dot1x_open = false;
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
-	wil->ring2cid_tid[ring_id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[ring_id][0] = max_assoc_sta;
 	wil->ring2cid_tid[ring_id][1] = 0;
 	return rc;
 }
@@ -1120,7 +1197,7 @@ int wil_vring_init_bcast(struct wil6210_vif *vif, int id, int size)
 	if (rc)
 		goto out;
 
-	wil->ring2cid_tid[id][0] = WIL6210_MAX_CID; /* CID */
+	wil->ring2cid_tid[id][0] = max_assoc_sta; /* CID */
 	wil->ring2cid_tid[id][1] = 0; /* TID */
 
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
@@ -1167,7 +1244,7 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 	int cid = wil_find_cid(wil, vif->mid, eth->h_dest);
 	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
-	if (cid < 0)
+	if (cid < 0 || cid >= max_assoc_sta)
 		return NULL;
 
 	/* TODO: fix for multiple TID */
@@ -1219,7 +1296,7 @@ static struct wil_ring *wil_find_tx_ring_sta(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (cid >= max_assoc_sta) /* skip BCAST */
 			continue;
 
 		if (!wil->ring_tx_data[i].dot1x_open &&
@@ -1298,7 +1375,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (cid >= max_assoc_sta) /* skip BCAST */
 			continue;
 		if (!wil->ring_tx_data[i].dot1x_open &&
 		    skb->protocol != cpu_to_be16(ETH_P_PAE))
@@ -1326,7 +1403,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 		if (!v2->va || txdata2->mid != vif->mid)
 			continue;
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (cid >= max_assoc_sta) /* skip BCAST */
 			continue;
 		if (!wil->ring_tx_data[i].dot1x_open &&
 		    skb->protocol != cpu_to_be16(ETH_P_PAE))
@@ -2179,7 +2256,7 @@ int wil_tx_complete(struct wil6210_vif *vif, int ringid)
 
 	used_before_complete = wil_ring_used_tx(vring);
 
-	if (cid < WIL6210_MAX_CID)
+	if (cid < max_assoc_sta)
 		stats = &wil->sta[cid].stats;
 
 	while (!wil_ring_is_empty(vring)) {
@@ -2288,7 +2365,7 @@ static void wil_get_reorder_params(struct wil6210_priv *wil,
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
index 3380aae..c09cd69 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2018 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2012-2019 The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -727,7 +727,7 @@ static int wil_ring_init_tx_edma(struct wil6210_vif *vif, int ring_id,
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
 	wil_ring_free_edma(wil, ring);
-	wil->ring2cid_tid[ring_id][0] = WIL6210_MAX_CID;
+	wil->ring2cid_tid[ring_id][0] = max_assoc_sta;
 	wil->ring2cid_tid[ring_id][1] = 0;
 
  out:
@@ -932,7 +932,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	eop = wil_rx_status_get_eop(msg);
 
 	cid = wil_rx_status_get_cid(msg);
-	if (unlikely(!wil_val_in_range(cid, 0, WIL6210_MAX_CID))) {
+	if (unlikely(!wil_val_in_range(cid, 0, max_assoc_sta))) {
 		wil_err(wil, "Corrupt cid=%d, sring->swhead=%d\n",
 			cid, sring->swhead);
 		rxdata->skipping = true;
@@ -1187,7 +1187,7 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 		ndev = vif_to_ndev(vif);
 
 		cid = wil->ring2cid_tid[ring_id][0];
-		if (cid < WIL6210_MAX_CID)
+		if (cid < max_assoc_sta)
 			stats = &wil->sta[cid].stats;
 
 		wil_dbg_txrx(wil,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ba833ac..85dca1b 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -39,6 +39,7 @@
 extern bool disable_ap_sme;
 extern bool ftm_mode;
 extern bool drop_if_ring_full;
+extern uint max_assoc_sta;
 
 struct wil6210_priv;
 struct wil6210_vif;
@@ -90,7 +91,8 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL_RING_SIZE_ORDER_MIN	(5)
 #define WIL_RING_SIZE_ORDER_MAX	(15)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
-#define WIL6210_MAX_CID		(8) /* HW limit */
+#define WIL6210_MAX_CID		(20) /* max number of stations */
+#define WIL6210_RX_DESC_MAX_CID	(8)  /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
 #define WIL_MAX_AMPDU_SIZE	(64 * 1024) /* FW/HW limit */
 #define WIL_MAX_AGG_WSIZE	(32) /* FW/HW limit */
@@ -458,7 +460,7 @@ static inline void parse_cidxtid(u8 cidxtid, u8 *cid, u8 *tid)
  */
 static inline bool wil_cid_valid(u8 cid)
 {
-	return cid < WIL6210_MAX_CID;
+	return (cid >= 0 && cid < max_assoc_sta);
 }
 
 struct wil6210_mbox_ring {
@@ -1236,7 +1238,7 @@ int wmi_disconnect_sta(struct wil6210_vif *vif, const u8 *mac, u16 reason,
 int wmi_addba(struct wil6210_priv *wil, u8 mid,
 	      u8 ringid, u8 size, u16 timeout);
 int wmi_delba_tx(struct wil6210_priv *wil, u8 mid, u8 ringid, u16 reason);
-int wmi_delba_rx(struct wil6210_priv *wil, u8 mid, u8 cidxtid, u16 reason);
+int wmi_delba_rx(struct wil6210_priv *wil, u8 mid, u8 cid, u8 tid, u16 reason);
 int wmi_addba_rx_resp(struct wil6210_priv *wil,
 		      u8 mid, u8 cid, u8 tid, u8 token,
 		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout);
@@ -1249,8 +1251,8 @@ int wmi_port_allocate(struct wil6210_priv *wil, u8 mid,
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
index b1ba519..bda4a97 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -24,8 +24,9 @@
 #include "wmi.h"
 #include "trace.h"
 
-static uint max_assoc_sta = WIL6210_MAX_CID;
-module_param(max_assoc_sta, uint, 0644);
+/* set the default max assoc sta to max supported by driver */
+uint max_assoc_sta = WIL6210_MAX_CID;
+module_param(max_assoc_sta, uint, 0444);
 MODULE_PARM_DESC(max_assoc_sta, " Max number of stations associated to the AP");
 
 int agg_wsize; /* = 0; */
@@ -770,6 +771,7 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
 	struct wil6210_priv *wil = vif_to_wil(vif);
 	struct wiphy *wiphy = wil_to_wiphy(wil);
 	struct wmi_ready_event *evt = d;
+	u8 fw_max_assoc_sta;
 
 	wil_info(wil, "FW ver. %s(SW %d); MAC %pM; %d MID's\n",
 		 wil->fw_version, le32_to_cpu(evt->sw_version),
@@ -787,6 +789,25 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
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
+	max_assoc_sta = min_t(uint, max_assoc_sta, fw_max_assoc_sta);
+	wil_dbg_wmi(wil, "setting max assoc sta to %d\n", max_assoc_sta);
+
 	wil_set_recovery_state(wil, fw_recovery_idle);
 	set_bit(wil_status_fwready, wil->status);
 	/* let the reset sequence continue */
@@ -952,7 +973,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 			evt->assoc_req_len, evt->assoc_resp_len);
 		return;
 	}
-	if (evt->cid >= WIL6210_MAX_CID) {
+	if (evt->cid >= max_assoc_sta) {
 		wil_err(wil, "Connect CID invalid : %d\n", evt->cid);
 		return;
 	}
@@ -1271,9 +1292,16 @@ static void wmi_evt_addba_rx_req(struct wil6210_vif *vif, int id,
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
@@ -1289,7 +1317,13 @@ static void wmi_evt_delba(struct wil6210_vif *vif, int id, void *d, int len)
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
@@ -1404,7 +1438,7 @@ static void wil_link_stats_store_basic(struct wil6210_vif *vif,
 	u8 cid = basic->cid;
 	struct wil_sta_info *sta;
 
-	if (cid < 0 || cid >= WIL6210_MAX_CID) {
+	if (cid < 0 || cid >= max_assoc_sta) {
 		wil_err(wil, "invalid cid %d\n", cid);
 		return;
 	}
@@ -1554,7 +1588,7 @@ static int wil_find_cid_ringid_sta(struct wil6210_priv *wil,
 			continue;
 
 		lcid = wil->ring2cid_tid[i][0];
-		if (lcid >= WIL6210_MAX_CID) /* skip BCAST */
+		if (lcid >= max_assoc_sta) /* skip BCAST */
 			continue;
 
 		wil_dbg_wmi(wil, "find sta -> ringid %d cid %d\n", i, lcid);
@@ -2120,10 +2154,9 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 
 	if ((cmd.pcp_max_assoc_sta > WIL6210_MAX_CID) ||
 	    (cmd.pcp_max_assoc_sta <= 0)) {
-		wil_info(wil,
-			 "Requested connection limit %u, valid values are 1 - %d. Setting to %d\n",
-			 max_assoc_sta, WIL6210_MAX_CID, WIL6210_MAX_CID);
-		cmd.pcp_max_assoc_sta = WIL6210_MAX_CID;
+		wil_err(wil, "unexpected max_assoc_sta %d\n",
+			cmd.pcp_max_assoc_sta);
+		return -EOPNOTSUPP;
 	}
 
 	if (disable_ap_sme &&
@@ -2651,15 +2684,22 @@ int wmi_delba_tx(struct wil6210_priv *wil, u8 mid, u8 ringid, u16 reason)
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
@@ -2670,7 +2710,6 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil,
 {
 	int rc;
 	struct wmi_rcp_addba_resp_cmd cmd = {
-		.cidxtid = mk_cidxtid(cid, tid),
 		.dialog_token = token,
 		.status_code = cpu_to_le16(status),
 		/* bit 0: A-MSDU supported
@@ -2689,6 +2728,14 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil,
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

