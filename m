Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbZKMT4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/16] iwlwifi: report PS filtered status
Date: Fri, 13 Nov 2009 11:56:35 -0800
Message-Id: <1258142198-3223-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When a frame is sent to a sleeping station, the
microcode reports TX_STATUS_FAIL_DEST_PS as its
status -- we need to translate that to the flag
that mac80211 expects.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-commands.h |   15 +++++++++++++++
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cc39424..39e7244 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1865,8 +1865,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl_is_tx_success(status) ?
-			IEEE80211_TX_STAT_ACK : 0;
+		info->flags |= iwl_tx_status_to_mac80211(status);
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 		/* FIXME: code repetition end */
 
@@ -2021,8 +2020,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		}
 	} else {
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags |= iwl_is_tx_success(status) ?
-					IEEE80211_TX_STAT_ACK : 0;
+		info->flags |= iwl_tx_status_to_mac80211(status);
 		iwl_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 60b1a7e..30b1d66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -994,8 +994,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl_is_tx_success(status) ?
-					IEEE80211_TX_STAT_ACK : 0;
+		info->flags |= iwl_tx_status_to_mac80211(status);
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 
 		/* FIXME: code repetition end */
@@ -1140,8 +1139,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 		BUG_ON(txq_id != txq->swq_id);
 
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags |= iwl_is_tx_success(status) ?
-					IEEE80211_TX_STAT_ACK : 0;
+		info->flags |= iwl_tx_status_to_mac80211(status);
 		iwl_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6e23a2b..87a7f28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1690,6 +1690,21 @@ enum {
 	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
 };
 
+static inline u32 iwl_tx_status_to_mac80211(u32 status)
+{
+	status &= TX_STATUS_MSK;
+
+	switch (status) {
+	case TX_STATUS_SUCCESS:
+	case TX_STATUS_DIRECT_DONE:
+		return IEEE80211_TX_STAT_ACK;
+	case TX_STATUS_FAIL_DEST_PS:
+		return IEEE80211_TX_STAT_TX_FILTERED;
+	default:
+		return 0;
+	}
+}
+
 static inline bool iwl_is_tx_success(u32 status)
 {
 	status &= TX_STATUS_MSK;
-- 
1.5.6.3

