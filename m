Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbZFSUpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 16:45:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwlwifi: drop sw_crypto from hw_params.
Date: Fri, 19 Jun 2009 13:52:42 -0700
Message-Id: <1245444765-29079-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1245444765-29079-2-git-send-email-reinette.chatre@intel.com>
References: <1245444765-29079-1-git-send-email-reinette.chatre@intel.com>
 <1245444765-29079-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Each HW supported by iwlwifi is capable of hardware crypto
so drop this flag from hw_params structure.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 777c095..8cfc830 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1987,7 +1987,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	staging_rxon->reserved4 = 0;
 	staging_rxon->reserved5 = 0;
 
-	iwl_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, !iwl3945_mod_params.sw_crypto);
 
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 63cba8c..d928561 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -171,7 +171,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       priv->staging_rxon.bssid_addr);
 
-	iwl_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, !priv->cfg->mod_params->sw_crypto);
 
 	/* Apply the new configuration
 	 * RXON unassoc clears the station table in uCode, send it before
@@ -2337,7 +2337,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (priv->hw_params.sw_crypto) {
+	if (priv->cfg->mod_params->sw_crypto) {
 		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6ab0716..11a1969 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1361,7 +1361,6 @@ EXPORT_SYMBOL(iwl_setup_mac);
 
 int iwl_set_hw_params(struct iwl_priv *priv)
 {
-	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (priv->cfg->mod_params->amsdu_size_8K)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e2d620f..5da60e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -608,7 +608,6 @@ struct iwl_hw_params {
 	u8  max_stations;
 	u8  bcast_sta_id;
 	u8 fat_channel;
-	u8 sw_crypto;
 	u32 max_inst_size;
 	u32 max_data_size;
 	u32 max_bsm_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 2160795..66fe365 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -927,7 +927,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
 	/*  in case of HW accelerated crypto and bad decryption, drop */
-	if (!priv->hw_params.sw_crypto &&
+	if (!priv->cfg->mod_params->sw_crypto &&
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-- 
1.5.6.3

