Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1317 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052Ab0LNARH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/14] iwlagn: check ready in iwlagn_bss_info_changed()
Date: Mon, 13 Dec 2010 16:09:21 -0800
Message-Id: <1292285372-11373-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

In function iwlagn_bss_info_changed(), we need to check if the driver
is ready before doing real work. Also, the previously put WARN() is
removed because the vif is not guaranteed to be valid. uCode restart
routine will clear the vif.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 4865b82..769479e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -518,7 +518,14 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (WARN_ON(!ctx->vif)) {
+	if (unlikely(!iwl_is_ready(priv))) {
+                IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+                mutex_unlock(&priv->mutex);
+		return;
+        }
+
+	if (unlikely(!ctx->vif)) {
+		IWL_DEBUG_MAC80211(priv, "leave - vif is NULL\n");
 		mutex_unlock(&priv->mutex);
 		return;
 	}
-- 
1.7.0.4

