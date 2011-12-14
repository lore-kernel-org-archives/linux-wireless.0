Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757692Ab1LNRWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 12:22:14 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlwifi: tx_sync only on PAN context
Date: Wed, 14 Dec 2011 08:22:35 -0800
Message-Id: <1323879756-3817-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111214_182231_066141_DC74424C)
In-Reply-To: <1323879756-3817-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323879756-3817-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Ted reported that he couldn't connect to some APs
and bisected it to the tx_sync implementation.
Disable it for the BSS context to fix this issue.

Reported-by: Ted Ts'o <tytso@mit.edu>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
John, this patch only apply to 3.2, the function move to iwl-mac80211.c in
wireless-next, same changes required there. It is already on my tree. Thanks 
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bacc06c..e0e9a3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2850,6 +2850,9 @@ static int iwlagn_mac_tx_sync(struct ieee80211_hw *hw,
 	int ret;
 	u8 sta_id;
 
+	if (ctx->ctxid != IWL_RXON_CTX_PAN)
+		return 0;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
@@ -2898,6 +2901,9 @@ static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 
+	if (ctx->ctxid != IWL_RXON_CTX_PAN)
+		return;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
-- 
1.7.0.4

