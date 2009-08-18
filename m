Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:45764 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZHRDyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:54:53 -0400
Date: Tue, 18 Aug 2009 05:54:54 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 23/29] mwl8k: get rid of mwl8k_set_rts_threshold() workqueue use
Message-ID: <20090818035454.GB18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   43 ++---------------------------------------
 1 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 927f987..c8e65c6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1970,7 +1970,7 @@ struct mwl8k_cmd_rts_threshold {
 } __attribute__((packed));
 
 static int mwl8k_rts_threshold(struct ieee80211_hw *hw,
-			       u16 action, u16 *threshold)
+			       u16 action, u16 threshold)
 {
 	struct mwl8k_cmd_rts_threshold *cmd;
 	int rc;
@@ -1982,7 +1982,7 @@ static int mwl8k_rts_threshold(struct ieee80211_hw *hw,
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_RTS_THRESHOLD);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(action);
-	cmd->threshold = cpu_to_le16(*threshold);
+	cmd->threshold = cpu_to_le16(threshold);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2816,46 +2816,9 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 	mwl8k_queue_work(hw, &worker->header, mwl8k_configure_filter_wt);
 }
 
-struct mwl8k_set_rts_threshold_worker {
-	struct mwl8k_work_struct header;
-	u32 value;
-};
-
-static int mwl8k_set_rts_threshold_wt(struct work_struct *wt)
-{
-	struct mwl8k_set_rts_threshold_worker *worker =
-		(struct mwl8k_set_rts_threshold_worker *)wt;
-
-	struct ieee80211_hw *hw = worker->header.hw;
-	u16 threshold = (u16)(worker->value);
-	int rc;
-
-	rc = mwl8k_rts_threshold(hw, MWL8K_CMD_SET, &threshold);
-
-	return rc;
-}
-
 static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	int rc;
-	struct mwl8k_set_rts_threshold_worker *worker;
-
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
-	if (worker == NULL)
-		return -ENOMEM;
-
-	worker->header.sleep = 1;
-	worker->value = value;
-
-	rc = mwl8k_queue_work(hw, &worker->header, mwl8k_set_rts_threshold_wt);
-	kfree(worker);
-
-	if (rc == -ETIMEDOUT) {
-		printk(KERN_ERR "%s() timed out\n", __func__);
-		rc = -EINVAL;
-	}
-
-	return rc;
+	return mwl8k_rts_threshold(hw, MWL8K_CMD_SET, value);
 }
 
 struct mwl8k_conf_tx_worker {
-- 
1.5.6.4
