Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875AbYCECKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 11/11] iwlwifi: Cancel scanning upon association
Date: Tue,  4 Mar 2008 18:09:32 -0800
Message-Id: <1204682972-26004-12-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021058_866558_8D61C7AD)
In-Reply-To: <1204682972-26004-11-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-7-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-8-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-9-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-10-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cancels an ongoing HW scan upon association. Not doing this
resulted in instability in association.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 ++++++-----------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   17 ++++++-----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a130f5d..4aaced0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7004,6 +7004,12 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	if (conf == NULL)
 		return -EIO;
 
+	if (priv->vif != vif) {
+		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
+		mutex_unlock(&priv->mutex);
+		return 0;
+	}
+
 	/* XXX: this MUST use conf->mac_addr */
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
@@ -7028,17 +7034,6 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
 	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
  */
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211("leave - scanning\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
-	}
-
-	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
-	}
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
 		if (!conf->bssid) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d362c4c..5005c95 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7424,6 +7424,12 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 	if (conf == NULL)
 		return -EIO;
 
+	if (priv->vif != vif) {
+		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
+		mutex_unlock(&priv->mutex);
+		return 0;
+	}
+
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
 	    (!conf->beacon || !conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
@@ -7446,17 +7452,6 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->status)) &&
 	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
  */
-	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211("leave - scanning\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
-	}
-
-	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
-	}
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
 		if (!conf->bssid) {
-- 
1.5.3.4

