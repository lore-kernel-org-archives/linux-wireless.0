Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D79C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF772205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfDZPuC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:50:02 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21643 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbfDZPt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:59 -0400
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367521"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:44 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889770"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:43 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 6/9] wil6210: fix overwriting max_assoc_sta module param
Date:   Fri, 26 Apr 2019 18:43:34 +0300
Message-Id: <1556293417-27097-7-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Save the parameter of max_assoc_sta per device.
On fw_ready event calculate the max_assoc_sta and save it per device,
do not overwrite the max_assoc_sta module param.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  4 ++--
 drivers/net/wireless/ath/wil6210/debugfs.c    | 18 +++++++++---------
 drivers/net/wireless/ath/wil6210/main.c       |  9 +++++----
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c       | 22 +++++++++++-----------
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  7 ++++---
 drivers/net/wireless/ath/wil6210/wil6210.h    | 19 ++++++++++---------
 drivers/net/wireless/ath/wil6210/wmi.c        | 14 +++++++-------
 8 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 218296e..e9780fc 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -395,7 +395,7 @@ static int wil_find_cid_by_idx(struct wil6210_priv *wil, u8 mid, int idx)
 {
 	int i;
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		if (wil->sta[i].status == wil_sta_unused)
 			continue;
 		if (wil->sta[i].mid != mid)
@@ -3020,7 +3020,7 @@ static int wil_rf_sector_set_selected(struct wiphy *wiphy,
 			wil, vif->mid, WMI_INVALID_RF_SECTOR_INDEX,
 			sector_type, WIL_CID_ALL);
 		if (rc == -EINVAL) {
-			for (i = 0; i < max_assoc_sta; i++) {
+			for (i = 0; i < wil->max_assoc_sta; i++) {
 				if (wil->sta[i].mid != vif->mid)
 					continue;
 				rc = wil_rf_sector_wmi_set_selected(
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 42507f5..7a2c3fd 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -178,7 +178,7 @@ static int ring_show(struct seq_file *s, void *data)
 
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			if (cid < max_assoc_sta)
+			if (cid < wil->max_assoc_sta)
 				seq_printf(s,
 					   "\n%pM CID %d TID %d 1x%s BACK([%u] %u TU A%s) [%3d|%3d] idle %s\n",
 					   wil->sta[cid].addr, cid, tid,
@@ -839,7 +839,7 @@ static ssize_t wil_write_back(struct file *file, const char __user *buf,
 				"BACK: del_rx require at least 2 params\n");
 			return -EINVAL;
 		}
-		if (p1 < 0 || p1 >= max_assoc_sta) {
+		if (p1 < 0 || p1 >= wil->max_assoc_sta) {
 			wil_err(wil, "BACK: invalid CID %d\n", p1);
 			return -EINVAL;
 		}
@@ -1290,7 +1290,7 @@ static int bf_show(struct seq_file *s, void *data)
 
 	memset(&reply, 0, sizeof(reply));
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		u32 status;
 
 		cmd.cid = i;
@@ -1387,7 +1387,7 @@ static int link_show(struct seq_file *s, void *data)
 	if (!sinfo)
 		return -ENOMEM;
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		struct wil6210_vif *vif;
@@ -1589,7 +1589,7 @@ static int sta_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int i, tid, mcs;
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		u8 aid = 0;
@@ -1698,7 +1698,7 @@ static int wil_tx_latency_debugfs_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	int i, bin;
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
 		u8 aid = 0;
@@ -1787,7 +1787,7 @@ static ssize_t wil_tx_latency_write(struct file *file, const char __user *buf,
 		size_t sz = sizeof(u64) * WIL_NUM_LATENCY_BINS;
 
 		wil->tx_latency_res = val;
-		for (i = 0; i < max_assoc_sta; i++) {
+		for (i = 0; i < wil->max_assoc_sta; i++) {
 			struct wil_sta_info *sta = &wil->sta[i];
 
 			kfree(sta->tx_latency_bins);
@@ -1872,7 +1872,7 @@ static void wil_link_stats_debugfs_show_vif(struct wil6210_vif *vif,
 	}
 
 	seq_printf(s, "TSF %lld\n", vif->fw_stats_tsf);
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		if (wil->sta[i].status == wil_sta_unused)
 			continue;
 		if (wil->sta[i].mid != vif->mid)
@@ -2488,7 +2488,7 @@ void wil6210_debugfs_remove(struct wil6210_priv *wil)
 	wil->debug = NULL;
 
 	kfree(wil->dbg_data.data_arr);
-	for (i = 0; i < max_assoc_sta; i++)
+	for (i = 0; i < wil->max_assoc_sta; i++)
 		kfree(wil->sta[i].tx_latency_bins);
 
 	/* free pmc memory without sending command to fw, as it will
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 03ca8e5..efdb6e1 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -241,7 +241,7 @@ static bool wil_vif_is_connected(struct wil6210_priv *wil, u8 mid)
 {
 	int i;
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		if (wil->sta[i].mid == mid &&
 		    wil->sta[i].status == wil_sta_connected)
 			return true;
@@ -344,7 +344,7 @@ static void _wil6210_disconnect_complete(struct wil6210_vif *vif,
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect complete all\n");
-		for (cid = 0; cid < max_assoc_sta; cid++)
+		for (cid = 0; cid < wil->max_assoc_sta; cid++)
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	}
 
@@ -456,7 +456,7 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 			wil_disconnect_cid(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect all\n");
-		for (cid = 0; cid < max_assoc_sta; cid++)
+		for (cid = 0; cid < wil->max_assoc_sta; cid++)
 			wil_disconnect_cid(vif, cid, reason_code);
 	}
 
@@ -753,6 +753,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	wil->reply_mid = U8_MAX;
 	wil->max_vifs = 1;
+	wil->max_assoc_sta = max_assoc_sta;
 
 	/* edma configuration can be updated via debugfs before allocation */
 	wil->num_rx_status_rings = WIL_DEFAULT_NUM_RX_STATUS_RINGS;
@@ -1922,7 +1923,7 @@ int wil_find_cid(struct wil6210_priv *wil, u8 mid, const u8 *mac)
 	int i;
 	int rc = -ENOENT;
 
-	for (i = 0; i < max_assoc_sta; i++) {
+	for (i = 0; i < wil->max_assoc_sta; i++) {
 		if (wil->sta[i].mid == mid &&
 		    wil->sta[i].status != wil_sta_unused &&
 		    ether_addr_equal(wil->sta[i].addr, mac)) {
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 32b14fc..1c79664 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -336,7 +336,7 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid, u8 cid, u8 tid,
 	might_sleep();
 
 	/* sanity checks */
-	if (cid >= max_assoc_sta) {
+	if (cid >= wil->max_assoc_sta) {
 		wil_err(wil, "BACK: invalid CID %d\n", cid);
 		rc = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index a8f315b..9bc3bd3 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -411,7 +411,7 @@ static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
 		ta = hdr->addr2;
 	}
 
-	if (max_assoc_sta <= WIL6210_RX_DESC_MAX_CID)
+	if (wil->max_assoc_sta <= WIL6210_RX_DESC_MAX_CID)
 		return cid;
 
 	/* assuming no concurrency between AP interfaces and STA interfaces.
@@ -426,14 +426,14 @@ static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
 	 * to find the real cid, compare transmitter address with the stored
 	 * stations mac address in the driver sta array
 	 */
-	for (i = cid; i < max_assoc_sta; i += WIL6210_RX_DESC_MAX_CID) {
+	for (i = cid; i < wil->max_assoc_sta; i += WIL6210_RX_DESC_MAX_CID) {
 		if (wil->sta[i].status != wil_sta_unused &&
 		    ether_addr_equal(wil->sta[i].addr, ta)) {
 			cid = i;
 			break;
 		}
 	}
-	if (i >= max_assoc_sta) {
+	if (i >= wil->max_assoc_sta) {
 		wil_err_ratelimited(wil, "Could not find cid for frame with transmit addr = %pM, iftype = %d, frametype = %d, len = %d\n",
 				    ta, vif->wdev.iftype, ftype, skb->len);
 		cid = -ENOENT;
@@ -1063,7 +1063,7 @@ static int wil_vring_init_tx(struct wil6210_vif *vif, int id, int size,
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
 	wil_vring_free(wil, vring);
-	wil->ring2cid_tid[id][0] = max_assoc_sta;
+	wil->ring2cid_tid[id][0] = wil->max_assoc_sta;
 	wil->ring2cid_tid[id][1] = 0;
 
  out:
@@ -1148,7 +1148,7 @@ static int wil_tx_vring_modify(struct wil6210_vif *vif, int ring_id, int cid,
 	txdata->dot1x_open = false;
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
-	wil->ring2cid_tid[ring_id][0] = max_assoc_sta;
+	wil->ring2cid_tid[ring_id][0] = wil->max_assoc_sta;
 	wil->ring2cid_tid[ring_id][1] = 0;
 	return rc;
 }
@@ -1195,7 +1195,7 @@ int wil_vring_init_bcast(struct wil6210_vif *vif, int id, int size)
 	if (rc)
 		goto out;
 
-	wil->ring2cid_tid[id][0] = max_assoc_sta; /* CID */
+	wil->ring2cid_tid[id][0] = wil->max_assoc_sta; /* CID */
 	wil->ring2cid_tid[id][1] = 0; /* TID */
 
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
@@ -1243,7 +1243,7 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 
 	cid = wil_find_cid(wil, vif->mid, da);
 
-	if (cid < 0 || cid >= max_assoc_sta)
+	if (cid < 0 || cid >= wil->max_assoc_sta)
 		return NULL;
 
 	/* TODO: fix for multiple TID */
@@ -1295,7 +1295,7 @@ static struct wil_ring *wil_find_tx_ring_sta(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= max_assoc_sta) /* skip BCAST */
+		if (cid >= wil->max_assoc_sta) /* skip BCAST */
 			continue;
 
 		if (!wil->ring_tx_data[i].dot1x_open &&
@@ -1373,7 +1373,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= max_assoc_sta) /* skip BCAST */
+		if (cid >= wil->max_assoc_sta) /* skip BCAST */
 			continue;
 		if (!wil->ring_tx_data[i].dot1x_open &&
 		    skb->protocol != cpu_to_be16(ETH_P_PAE))
@@ -1401,7 +1401,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 		if (!v2->va || txdata2->mid != vif->mid)
 			continue;
 		cid = wil->ring2cid_tid[i][0];
-		if (cid >= max_assoc_sta) /* skip BCAST */
+		if (cid >= wil->max_assoc_sta) /* skip BCAST */
 			continue;
 		if (!wil->ring_tx_data[i].dot1x_open &&
 		    skb->protocol != cpu_to_be16(ETH_P_PAE))
@@ -2257,7 +2257,7 @@ int wil_tx_complete(struct wil6210_vif *vif, int ringid)
 
 	used_before_complete = wil_ring_used_tx(vring);
 
-	if (cid < max_assoc_sta)
+	if (cid < wil->max_assoc_sta)
 		stats = &wil->sta[cid].stats;
 
 	while (!wil_ring_is_empty(vring)) {
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index f6fce6f..f37a205 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -734,7 +734,7 @@ static int wil_ring_init_tx_edma(struct wil6210_vif *vif, int ring_id,
 	txdata->enabled = 0;
 	spin_unlock_bh(&txdata->lock);
 	wil_ring_free_edma(wil, ring);
-	wil->ring2cid_tid[ring_id][0] = max_assoc_sta;
+	wil->ring2cid_tid[ring_id][0] = wil->max_assoc_sta;
 	wil->ring2cid_tid[ring_id][1] = 0;
 
  out:
@@ -944,7 +944,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	eop = wil_rx_status_get_eop(msg);
 
 	cid = wil_rx_status_get_cid(msg);
-	if (unlikely(!wil_val_in_range(cid, 0, max_assoc_sta))) {
+	if (unlikely(!wil_val_in_range(cid, 0, wil->max_assoc_sta))) {
 		wil_err(wil, "Corrupt cid=%d, sring->swhead=%d\n",
 			cid, sring->swhead);
 		rxdata->skipping = true;
@@ -1199,7 +1199,8 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 		ndev = vif_to_ndev(vif);
 
 		cid = wil->ring2cid_tid[ring_id][0];
-		stats = (cid < max_assoc_sta ? &wil->sta[cid].stats : NULL);
+		stats = (cid < wil->max_assoc_sta) ? &wil->sta[cid].stats :
+						     NULL;
 
 		wil_dbg_txrx(wil,
 			     "tx_status: completed desc_ring (%d), num_descs (%d)\n",
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1f0175d..4498403 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -461,15 +461,6 @@ static inline void parse_cidxtid(u8 cidxtid, u8 *cid, u8 *tid)
 	*tid = (cidxtid >> 4) & 0xf;
 }
 
-/**
- * wil_cid_valid - check cid is valid
- * @cid: CID value
- */
-static inline bool wil_cid_valid(u8 cid)
-{
-	return (cid >= 0 && cid < max_assoc_sta);
-}
-
 struct wil6210_mbox_ring {
 	u32 base;
 	u16 entry_size; /* max. size of mbox entry, incl. all headers */
@@ -950,6 +941,8 @@ struct wil6210_priv {
 	struct wil6210_vif *vifs[WIL_MAX_VIFS];
 	struct mutex vif_mutex; /* protects access to VIF entries */
 	atomic_t connected_vifs;
+	u32 max_assoc_sta; /* max sta's supported by the driver and the FW */
+
 	/* profile */
 	struct cfg80211_chan_def monitor_chandef;
 	u32 monitor_flags;
@@ -1147,6 +1140,14 @@ static inline void wil_c(struct wil6210_priv *wil, u32 reg, u32 val)
 	wil_w(wil, reg, wil_r(wil, reg) & ~val);
 }
 
+/**
+ * wil_cid_valid - check cid is valid
+ */
+static inline bool wil_cid_valid(struct wil6210_priv *wil, u8 cid)
+{
+	return (cid >= 0 && cid < wil->max_assoc_sta);
+}
+
 void wil_get_board_file(struct wil6210_priv *wil, char *buf, size_t len);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d89cd41..0a0818f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -806,8 +806,8 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
 		}
 	}
 
-	max_assoc_sta = min_t(uint, max_assoc_sta, fw_max_assoc_sta);
-	wil_dbg_wmi(wil, "setting max assoc sta to %d\n", max_assoc_sta);
+	wil->max_assoc_sta = min_t(uint, max_assoc_sta, fw_max_assoc_sta);
+	wil_dbg_wmi(wil, "setting max assoc sta to %d\n", wil->max_assoc_sta);
 
 	wil_set_recovery_state(wil, fw_recovery_idle);
 	set_bit(wil_status_fwready, wil->status);
@@ -974,7 +974,7 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 			evt->assoc_req_len, evt->assoc_resp_len);
 		return;
 	}
-	if (evt->cid >= max_assoc_sta) {
+	if (evt->cid >= wil->max_assoc_sta) {
 		wil_err(wil, "Connect CID invalid : %d\n", evt->cid);
 		return;
 	}
@@ -1236,7 +1236,7 @@ static void wmi_evt_ring_en(struct wil6210_vif *vif, int id, void *d, int len)
 		return;
 
 	cid = wil->ring2cid_tid[vri][0];
-	if (!wil_cid_valid(cid)) {
+	if (!wil_cid_valid(wil, cid)) {
 		wil_err(wil, "invalid cid %d for vring %d\n", cid, vri);
 		return;
 	}
@@ -1439,7 +1439,7 @@ static void wil_link_stats_store_basic(struct wil6210_vif *vif,
 	u8 cid = basic->cid;
 	struct wil_sta_info *sta;
 
-	if (cid < 0 || cid >= max_assoc_sta) {
+	if (cid < 0 || cid >= wil->max_assoc_sta) {
 		wil_err(wil, "invalid cid %d\n", cid);
 		return;
 	}
@@ -1589,7 +1589,7 @@ static int wil_find_cid_ringid_sta(struct wil6210_priv *wil,
 			continue;
 
 		lcid = wil->ring2cid_tid[i][0];
-		if (lcid >= max_assoc_sta) /* skip BCAST */
+		if (lcid >= wil->max_assoc_sta) /* skip BCAST */
 			continue;
 
 		wil_dbg_wmi(wil, "find sta -> ringid %d cid %d\n", i, lcid);
@@ -2135,7 +2135,7 @@ int wmi_pcp_start(struct wil6210_vif *vif,
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
 		.channel = chan - 1,
-		.pcp_max_assoc_sta = max_assoc_sta,
+		.pcp_max_assoc_sta = wil->max_assoc_sta,
 		.hidden_ssid = hidden_ssid,
 		.is_go = is_go,
 		.ap_sme_offload_mode = disable_ap_sme ?
-- 
1.9.1

