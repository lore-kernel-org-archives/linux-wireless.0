Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0JVPBl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:01:41 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/7] iwlwifi: avoid commit rxon during scan in iwlagn_bt_traffic_change_work
Date: Fri, 22 Oct 2010 17:04:28 +0200
Message-Id: <1287759870-5758-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid sending commands to firmware (including commit_rxon) when scan
is pending and we are calling iwlagn_bt_traffic_change_work simultaneously.

Also comment some innocent race conditions.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 925347a..8257f36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1887,6 +1887,11 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	struct iwl_rxon_context *ctx;
 	int smps_request = -1;
 
+	/*
+	 * Note: bt_traffic_load can be overridden by scan complete and
+	 * coex profile notifications. Ignore that since only bad consequence
+	 * can be not matching debug print with actual state.
+	 */
 	IWL_DEBUG_INFO(priv, "BT traffic load changes: %d\n",
 		       priv->bt_traffic_load);
 
@@ -1909,6 +1914,16 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
+	/*
+	 * We can not send command to firmware while scanning. When the scan
+	 * complete we will schedule this work again. We do check with mutex
+	 * locked to prevent new scan request to arrive. We do not check
+	 * STATUS_SCANNING to avoid race when queue_work two times from
+	 * different notifications, but quit and not perform any work at all.
+	 */
+	if (test_bit(STATUS_SCAN_HW, &priv->status))
+		goto out;
+
 	if (priv->cfg->ops->lib->update_chain_flags)
 		priv->cfg->ops->lib->update_chain_flags(priv);
 
@@ -1918,7 +1933,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 				ieee80211_request_smps(ctx->vif, smps_request);
 		}
 	}
-
+out:
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.7.1

