Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1JJPQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/34] iwlagn: send simple LQ command for WoWLAN
Date: Mon, 10 Oct 2011 07:26:54 -0700
Message-Id: <1318256839-31837-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171743_201377_8032EB7D)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For some reason, WoWLAN doesn't always seem to
be happy with more advanced LQ commands. Since
we don't need them as we're not going to send
a lot of data, simply program the station with
the very simple default LQ command.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   27 ++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    7 +++++--
 drivers/net/wireless/iwlwifi/iwl-sta.h     |    2 ++
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 8f0b86d..8e7177b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -35,22 +35,17 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
-static struct iwl_link_quality_cmd *
-iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
+void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd)
 {
 	int i, r;
-	struct iwl_link_quality_cmd *link_cmd;
 	u32 rate_flags = 0;
 	__le32 rate_n_flags;
 
-	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
-	if (!link_cmd) {
-		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
-		return NULL;
-	}
-
 	lockdep_assert_held(&priv->shrd->mutex);
 
+	memset(link_cmd, 0, sizeof(*link_cmd));
+
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (priv->band == IEEE80211_BAND_5GHZ)
@@ -87,6 +82,20 @@ iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
 		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 
 	link_cmd->sta_id = sta_id;
+}
+
+static struct iwl_link_quality_cmd *
+iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
+{
+	struct iwl_link_quality_cmd *link_cmd;
+
+	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
+	if (!link_cmd) {
+		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
+		return NULL;
+	}
+
+	iwl_sta_fill_lq(priv, ctx, sta_id, link_cmd);
 
 	return link_cmd;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 580a4d7..30bfdd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -595,8 +595,11 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			       sizeof(struct iwl_addsta_cmd));
 			send_lq = false;
 			if (priv->stations[i].lq) {
-				memcpy(&lq, priv->stations[i].lq,
-				       sizeof(struct iwl_link_quality_cmd));
+				if (priv->shrd->wowlan)
+					iwl_sta_fill_lq(priv, ctx, i, &lq);
+				else
+					memcpy(&lq, priv->stations[i].lq,
+					       sizeof(struct iwl_link_quality_cmd));
 				send_lq = true;
 			}
 			spin_unlock_irqrestore(&priv->shrd->sta_lock,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 1bca0da..b86c893 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -58,6 +58,8 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    const u8 *addr, bool is_ap, struct ieee80211_sta *sta);
 
+void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd);
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
 void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
-- 
1.7.0.4

