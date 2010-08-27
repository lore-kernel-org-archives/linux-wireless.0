Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab0H0Q4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/27] iwlagn: remove iw_mode check for beacon
Date: Fri, 27 Aug 2010 09:59:47 -0700
Message-Id: <1282928395-32762-20-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we have the beacon context now, we no
longer need to rely on iw_mode but can check
the beacon context interface's type. However,
that check must be in the work item instead
due to locking constraints (mutex must be
held when dereferencing beacon_ctx pointer).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bad97f4..b07d397 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -613,6 +613,16 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 		goto out;
 	}
 
+	if (priv->beacon_ctx->vif->type != NL80211_IFTYPE_AP) {
+		/*
+		 * The ucode will send beacon notifications even in
+		 * IBSS mode, but we don't want to process them. But
+		 * we need to defer the type check to here due to
+		 * requiring locking around the beacon_ctx access.
+		 */
+		goto out;
+	}
+
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
 	beacon = ieee80211_beacon_get(priv->hw, priv->beacon_ctx->vif);
 	if (!beacon) {
@@ -846,8 +856,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 
 	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
 
-	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
-	    (!test_bit(STATUS_EXIT_PENDING, &priv->status)))
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
 		queue_work(priv->workqueue, &priv->beacon_update);
 }
 
-- 
1.7.0.4

