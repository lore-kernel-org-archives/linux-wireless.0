Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab2EKIx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:53:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] iwlwifi: support explicit monitor interface
Date: Fri, 11 May 2012 10:53:18 +0200
Message-Id: <1336726398-13200-5-git-send-email-johannes@sipsolutions.net> (sfid-20120511_105351_134035_80A69277)
In-Reply-To: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
References: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support explicit monitor interface to keep
injection working after the HW queue changes.
This also finally enables sniffer mode.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 0f7c444..89ccddc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -61,6 +61,10 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
+	case NL80211_IFTYPE_MONITOR:
+		ctx->staging.dev_type = RXON_DEV_TYPE_SNIFFER;
+		break;
+
 	default:
 		IWL_ERR(priv, "Unsupported interface type %d\n",
 			ctx->vif->type);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c1ab87e..bd50c3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -603,7 +603,7 @@ void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].exclusive_interface_modes =
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_MONITOR);
 	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
 		BIT(NL80211_IFTYPE_STATION);
 	priv->contexts[IWL_RXON_CTX_BSS].ap_devtype = RXON_DEV_TYPE_AP;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 9abe07a..ab2f4d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -150,6 +150,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_QUEUE_CONTROL |
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		    IEEE80211_HW_WANT_MONITOR_VIF |
 		    IEEE80211_HW_SCAN_WHILE_IDLE;
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
-- 
1.7.10

