Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbYEWCMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:12:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: activate status ready timeout only for run time ucode
Date: Fri, 23 May 2008 10:09:25 +0800
Message-Id: <1211508569-3163-48-git-send-email-yi.zhu@intel.com> (sfid-20080523_042834_987934_5ECB4742)
In-Reply-To: <1211508569-3163-47-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-41-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-42-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-43-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-47-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch makes driver state timeout checks on ucode alive response
only if run time ucode have been loaded.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   26 ++++++++++++++------------
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8c83384..d657b43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -156,6 +156,8 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO("Begin load bsm\n");
 
+	priv->ucode_type = UCODE_RT;
+
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
 	if (len > IWL_MAX_BSM_SIZE)
 		return -EINVAL;
@@ -221,8 +223,6 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 
 	iwl_release_nic_access(priv);
 
-	priv->ucode_type = UCODE_INIT;
-
 	return 0;
 }
 
@@ -269,8 +269,6 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO("Runtime uCode pointers are set.\n");
 
-	priv->ucode_type = UCODE_RT;
-
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index eb6141e..685a84e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -804,8 +804,11 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 
 	iwl5000_send_Xtal_calib(priv);
 
-	if (priv->ucode_type == UCODE_RT)
+	if (priv->ucode_type == UCODE_RT) {
 		iwl5000_send_calib_results(priv);
+		set_bit(STATUS_READY, &priv->status);
+		priv->is_open = 1;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1a94574..e46bdb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4082,21 +4082,23 @@ static int iwl4965_mac_start(struct ieee80211_hw *hw)
 	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
 		return 0;
 
-	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
+	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-			test_bit(STATUS_READY, &priv->status),
-			UCODE_READY_TIMEOUT);
-	if (!ret) {
-		if (!test_bit(STATUS_READY, &priv->status)) {
-			IWL_ERROR("Wait for START_ALIVE timeout after %dms.\n",
-				  jiffies_to_msecs(UCODE_READY_TIMEOUT));
-			ret = -ETIMEDOUT;
-			goto out_release_irq;
+	if (priv->ucode_type == UCODE_RT) {
+		ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+				test_bit(STATUS_READY, &priv->status),
+				UCODE_READY_TIMEOUT);
+		if (!ret) {
+			if (!test_bit(STATUS_READY, &priv->status)) {
+				IWL_ERROR("START_ALIVE timeout after %dms.\n",
+					jiffies_to_msecs(UCODE_READY_TIMEOUT));
+				ret = -ETIMEDOUT;
+				goto out_release_irq;
+			}
 		}
-	}
 
-	priv->is_open = 1;
+		priv->is_open = 1;
+	}
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
 
-- 
1.5.3.6

