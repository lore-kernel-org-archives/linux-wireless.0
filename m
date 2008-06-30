Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277AbYF3J1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 24/33] iwlwifi: blocking mac_start until uCode is complete
Date: Mon, 30 Jun 2008 17:23:24 +0800
Message-Id: <1214817813-17639-25-git-send-email-yi.zhu@intel.com> (sfid-20080630_113812_715377_7CECA0E0)
In-Reply-To: <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes iwl4965_mac_start block until the uCode has been
completely loaded.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f1cf4b1..e9b6f30 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2566,7 +2566,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
  *
  *****************************************************************************/
 
-#define UCODE_READY_TIMEOUT	(2 * HZ)
+#define UCODE_READY_TIMEOUT	(4 * HZ)
 
 static int iwl4965_mac_start(struct ieee80211_hw *hw)
 {
@@ -2619,17 +2619,15 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 
 	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
-	if (priv->ucode_type == UCODE_RT) {
-		ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-				test_bit(STATUS_READY, &priv->status),
-				UCODE_READY_TIMEOUT);
-		if (!ret) {
-			if (!test_bit(STATUS_READY, &priv->status)) {
-				IWL_ERROR("START_ALIVE timeout after %dms.\n",
-					jiffies_to_msecs(UCODE_READY_TIMEOUT));
-				ret = -ETIMEDOUT;
-				goto out_release_irq;
-			}
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+			test_bit(STATUS_READY, &priv->status),
+			UCODE_READY_TIMEOUT);
+	if (!ret) {
+		if (!test_bit(STATUS_READY, &priv->status)) {
+			IWL_ERROR("START_ALIVE timeout after %dms.\n",
+				jiffies_to_msecs(UCODE_READY_TIMEOUT));
+			ret = -ETIMEDOUT;
+			goto out_release_irq;
 		}
 
 		priv->is_open = 1;
-- 
1.5.3.6

