Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53495 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYDOEQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/12] iwlwifi: perform bss_info_changed post association work right away
Date: Mon, 14 Apr 2008 21:16:13 -0700
Message-Id: <1208232974-3828-12-git-send-email-reinette.chatre@intel.com> (sfid-20080415_052249_539655_4F115912)
In-Reply-To: <1208232974-3828-11-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not use workqueue for bss_info_changed post association work.
When driver is notified of association the upper layer will be notified
right after that the association is complete. Doing the post association
work in a workqueue introduces a race condition where the upper layer may
want to make use of the association, but it is not yet complete.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
This patch depends on "mac80211: no BSS changes to driver from beacons
processed during scanning"

 drivers/net/wireless/iwlwifi/iwl4965-base.c |   31 +++++++++++++++++++-------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9fb9857..1f34340 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1840,7 +1840,7 @@ static void iwl4965_set_flags_for_phymode(struct iwl_priv *priv,
 		      | RXON_FLG_CCK_MSK);
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
-		/* Copied from iwl4965_bg_post_associate() */
+		/* Copied from iwl4965_post_associate() */
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
@@ -6004,10 +6004,8 @@ static void iwl4965_bg_rx_replenish(struct work_struct *data)
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-static void iwl4965_bg_post_associate(struct work_struct *data)
+static void iwl4965_post_associate(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv = container_of(data, struct iwl_priv,
-					     post_associate.work);
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
 	DECLARE_MAC_BUF(mac);
@@ -6025,12 +6023,10 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	mutex_lock(&priv->mutex);
 
-	if (!priv->vif || !priv->is_open) {
-		mutex_unlock(&priv->mutex);
+	if (!priv->vif || !priv->is_open)
 		return;
-	}
+
 	iwl4965_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -6114,7 +6110,18 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
+}
+
+
+static void iwl4965_bg_post_associate(struct work_struct *data)
+{
+	struct iwl_priv *priv = container_of(data, struct iwl_priv,
+					     post_associate.work);
+
+	mutex_lock(&priv->mutex);
+	iwl4965_post_associate(priv);
 	mutex_unlock(&priv->mutex);
+
 }
 
 static void iwl4965_bg_abort_scan(struct work_struct *work)
@@ -6736,6 +6743,10 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		IWL_DEBUG_MAC80211("ASSOC %d\n", bss_conf->assoc);
+		/* This should never happen as this function should
+		 * never be called from interrupt context. */
+		if (WARN_ON_ONCE(in_interrupt()))
+			return;
 		if (bss_conf->assoc) {
 			priv->assoc_id = bss_conf->aid;
 			priv->beacon_int = bss_conf->beacon_int;
@@ -6743,7 +6754,9 @@ static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 			priv->assoc_capability = bss_conf->assoc_capability;
 			priv->next_scan_jiffies = jiffies +
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
-			queue_work(priv->workqueue, &priv->post_associate.work);
+			mutex_lock(&priv->mutex);
+			iwl4965_post_associate(priv);
+			mutex_unlock(&priv->mutex);
 		} else {
 			priv->assoc_id = 0;
 			IWL_DEBUG_MAC80211("DISASSOC %d\n", bss_conf->assoc);
-- 
1.5.3.4

