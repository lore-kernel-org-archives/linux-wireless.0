Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650AbZHUUe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/14] iwlwifi: fix unloading driver while scanning
Date: Fri, 21 Aug 2009 13:34:25 -0700
Message-Id: <1250886867-4112-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If NetworkManager is busy scanning when user
tries to unload the module, the driver can not be unloaded
because HW still scanning.

Make sure driver sends abort scan host command to uCode if it
is in the middle of scanning during driver unload.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 533b393..00457bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2155,7 +2155,7 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl_is_ready_rf(priv)) {
+	if (iwl_is_ready_rf(priv) || test_bit(STATUS_SCAN_HW, &priv->status)) {
 		/* stop mac, cancel any scan request and clear
 		 * RXON_FILTER_ASSOC_MSK BIT
 		 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c4c916d..4f3a108 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -796,7 +796,8 @@ void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
-	if (!iwl_is_ready(priv))
+	if (!test_bit(STATUS_READY, &priv->status) ||
+	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
 		return;
 
 	mutex_lock(&priv->mutex);
-- 
1.5.6.3

