Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45770 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbZHRDzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:55:22 -0400
Date: Tue, 18 Aug 2009 05:55:23 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 26/29] mwl8k: make mwl8k_configure_filter() use queue_work() directly
Message-ID: <20090818035523.GE18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwl8k_configure_filter() was the last remaining user of
mwl8k_queue_work(), which can now be removed in favor of just using
queue_work() on priv->config_wq directly.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b863b74..dea1440 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2747,27 +2747,26 @@ out:
 }
 
 struct mwl8k_configure_filter_worker {
-	struct mwl8k_work_struct header;
+	struct work_struct wt;
+	struct ieee80211_hw *hw;
 	unsigned int changed_flags;
 	unsigned int total_flags;
 	struct mwl8k_cmd_pkt *set_multicast_adr;
 };
 
-#define MWL8K_SUPPORTED_IF_FLAGS	FIF_BCN_PRBRESP_PROMISC
-
-static int mwl8k_configure_filter_wt(struct work_struct *wt)
+static void mwl8k_configure_filter_wt(struct work_struct *wt)
 {
 	struct mwl8k_configure_filter_worker *worker =
 		(struct mwl8k_configure_filter_worker *)wt;
-	struct ieee80211_hw *hw = worker->header.hw;
-	unsigned int changed_flags = worker->changed_flags;
-	unsigned int total_flags = worker->total_flags;
+	struct ieee80211_hw *hw = worker->hw;
 	struct mwl8k_priv *priv = hw->priv;
-	int rc = 0;
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (total_flags & FIF_BCN_PRBRESP_PROMISC)
-			rc = mwl8k_cmd_set_pre_scan(hw);
+	if (mwl8k_fw_lock(hw))
+		return;
+
+	if (worker->changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (worker->total_flags & FIF_BCN_PRBRESP_PROMISC)
+			mwl8k_cmd_set_pre_scan(hw);
 		else {
 			u8 *bssid;
 
@@ -2775,17 +2774,18 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
 			if (priv->vif != NULL)
 				bssid = MWL8K_VIF(priv->vif)->bssid;
 
-			rc = mwl8k_cmd_set_post_scan(hw, bssid);
+			mwl8k_cmd_set_post_scan(hw, bssid);
 		}
 	}
 
 	if (worker->set_multicast_adr != NULL) {
-		if (!rc)
-			rc = mwl8k_post_cmd(hw, worker->set_multicast_adr);
+		mwl8k_post_cmd(hw, worker->set_multicast_adr);
 		kfree(worker->set_multicast_adr);
 	}
 
-	return rc;
+	mwl8k_fw_unlock(hw);
+
+	kfree(worker);
 }
 
 static void mwl8k_configure_filter(struct ieee80211_hw *hw,
@@ -2794,26 +2794,28 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   int mc_count,
 				   struct dev_addr_list *mclist)
 {
+	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_configure_filter_worker *worker;
 
 	/* Clear unsupported feature flags */
-	*total_flags &= MWL8K_SUPPORTED_IF_FLAGS;
+	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
 
-	if (!(changed_flags & MWL8K_SUPPORTED_IF_FLAGS) && !mc_count)
+	if (!(changed_flags & FIF_BCN_PRBRESP_PROMISC) && !mc_count)
 		return;
 
 	worker = kzalloc(sizeof(*worker), GFP_ATOMIC);
 	if (worker == NULL)
 		return;
 
-	worker->header.sleep = 0;
+	worker->hw = hw;
 	worker->changed_flags = changed_flags;
 	worker->total_flags = *total_flags;
 	if (mc_count)
 		worker->set_multicast_adr =
 			__mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
 
-	mwl8k_queue_work(hw, &worker->header, mwl8k_configure_filter_wt);
+	INIT_WORK(&worker->wt, mwl8k_configure_filter_wt);
+	queue_work(priv->config_wq, &worker->wt);
 }
 
 static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-- 
1.5.6.4
