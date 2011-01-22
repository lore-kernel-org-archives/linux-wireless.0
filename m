Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1AVASY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:24 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/14] iwlwifi: replace minimum slot time constant
Date: Fri, 21 Jan 2011 16:06:48 -0800
Message-Id: <1295654809-5790-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of places where the minimum
slot time is hardcoded to 20 TU, add a new
constant for that and use it everywhere.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    5 +++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index fa6cf2a..41543ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -308,7 +308,7 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 	if (priv->_agn.hw_roc_channel) {
 		/* both contexts must be used for this to happen */
 		slot1 = priv->_agn.hw_roc_duration;
-		slot0 = 20;
+		slot0 = IWL_MIN_SLOT_TIME;
 	} else if (ctx_bss->vif && ctx_pan->vif) {
 		int bcnint = ctx_pan->vif->bss_conf.beacon_int;
 		int dtim = ctx_pan->vif->bss_conf.dtim_period ?: 1;
@@ -334,12 +334,12 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 		if (test_bit(STATUS_SCAN_HW, &priv->status) ||
 		    (!ctx_bss->vif->bss_conf.idle &&
 		     !ctx_bss->vif->bss_conf.assoc)) {
-			slot0 = dtim * bcnint * 3 - 20;
-			slot1 = 20;
+			slot0 = dtim * bcnint * 3 - IWL_MIN_SLOT_TIME;
+			slot1 = IWL_MIN_SLOT_TIME;
 		} else if (!ctx_pan->vif->bss_conf.idle &&
 			   !ctx_pan->vif->bss_conf.assoc) {
-			slot1 = bcnint * 3 - 20;
-			slot0 = 20;
+			slot1 = bcnint * 3 - IWL_MIN_SLOT_TIME;
+			slot0 = IWL_MIN_SLOT_TIME;
 		}
 	} else if (ctx_pan->vif) {
 		slot0 = 0;
@@ -348,8 +348,8 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 		slot1 = max_t(int, DEFAULT_BEACON_INTERVAL, slot1);
 
 		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-			slot0 = slot1 * 3 - 20;
-			slot1 = 20;
+			slot0 = slot1 * 3 - IWL_MIN_SLOT_TIME;
+			slot1 = IWL_MIN_SLOT_TIME;
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 51e5ea4..02771ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3792,7 +3792,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	queue_delayed_work(priv->workqueue, &priv->_agn.hw_roc_work,
 			   msecs_to_jiffies(duration + 20));
 
-	msleep(20);
+	msleep(IWL_MIN_SLOT_TIME); /* TU is almost ms */
 	ieee80211_ready_on_channel(priv->hw);
 
  out:
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index abe2479..935b19e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -4370,6 +4370,11 @@ int iwl_agn_check_rxon_cmd(struct iwl_priv *priv);
  * REPLY_WIPAN_PARAMS = 0xb2 (Commands and Notification)
  */
 
+/*
+ * Minimum slot time in TU
+ */
+#define IWL_MIN_SLOT_TIME	20
+
 /**
  * struct iwl_wipan_slot
  * @width: Time in TU
-- 
1.7.0.4

