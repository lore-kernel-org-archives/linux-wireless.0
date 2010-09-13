Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0IMMqT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:46:19 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/14] iwlwifi: remove unused conf variables
Date: Mon, 13 Sep 2010 14:46:32 +0200
Message-Id: <1284382005-3246-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of conf variables that are
unused, remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 ---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a8f2adf..51a8d7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1162,7 +1162,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u32 rate_flags = 0;
 	u16 cmd_len;
@@ -1179,8 +1178,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (vif)
 		ctx = iwl_rxon_ctx_from_vif(vif);
 
-	conf = ieee80211_get_hw_conf(priv->hw);
-
 	cancel_delayed_work(&priv->scan_check);
 
 	if (!iwl_is_ready(priv)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 68e624a..5b742eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2569,12 +2569,9 @@ static void __iwl3945_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
-	struct ieee80211_conf *conf = NULL;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-	conf = ieee80211_get_hw_conf(priv->hw);
-
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
@@ -2828,13 +2825,10 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl3945_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
 	u8 n_probes = 0;
 	enum ieee80211_band band;
 	bool is_active = false;
 
-	conf = ieee80211_get_hw_conf(priv->hw);
-
 	cancel_delayed_work(&priv->scan_check);
 
 	if (!iwl_is_ready(priv)) {
-- 
1.7.1

