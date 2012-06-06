Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 01/29] iwlwifi: Check BSS ctx active before call mac80211
Date: Wed,  6 Jun 2012 15:21:42 +0200
Message-Id: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152231_979720_A2082B64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

It is possible that the BSS context is not active (for example
when the current mode is set to GO), or that the vif->type is
different than station. In such a case we cannot
call mac80211 to report the average rssi for the interface
(the function assumes that the vif is valid and that the type
is station).

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e55ec6c..c31072d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -617,6 +617,11 @@ static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int ave_rssi;
 
+	if (!ctx->vif || (ctx->vif->type != NL80211_IFTYPE_STATION)) {
+		IWL_DEBUG_INFO(priv, "BSS ctx not active or not in sta mode\n");
+		return false;
+	}
+
 	ave_rssi = ieee80211_ave_rssi(ctx->vif);
 	if (!ave_rssi) {
 		/* no rssi data, no changes to reduce tx power */
-- 
1.7.10

