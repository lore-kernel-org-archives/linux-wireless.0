Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbYCYXdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: iwl_priv - clean up in types of members
Date: Tue, 25 Mar 2008 16:33:41 -0700
Message-Id: <1206488021-4193-7-git-send-email-reinette.chatre@intel.com> (sfid-20080325_233413_656000_3DE08C66)
In-Reply-To: <1206488021-4193-6-git-send-email-reinette.chatre@intel.com>
References: <1206488021-4193-1-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-2-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-3-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-4-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-5-git-send-email-reinette.chatre@intel.com>
 <1206488021-4193-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fix types of is_open and iw_mode members
of iwl_priv sturct

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++++
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e0655b9..d7ccf13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -830,7 +830,7 @@ struct iwl3945_priv {
 	struct iwl3945_station_entry stations[IWL_STATION_COUNT];
 
 	/* Indication if ieee80211_ops->open has been called */
-	int is_open;
+	u8 is_open;
 
 	u8 mac80211_registered;
 
@@ -851,7 +851,7 @@ struct iwl3945_priv {
 	/* eeprom */
 	struct iwl3945_eeprom eeprom;
 
-	int iw_mode;
+	enum ieee80211_if_types iw_mode;
 
 	struct sk_buff *ibss_beacon;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 98644d9..069e591 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1129,7 +1129,7 @@ struct iwl_priv {
 	struct iwl4965_station_entry stations[IWL_STATION_COUNT];
 
 	/* Indication if ieee80211_ops->open has been called */
-	int is_open;
+	u8 is_open;
 
 	u8 mac80211_registered;
 
@@ -1150,7 +1150,7 @@ struct iwl_priv {
 	/* eeprom */
 	struct iwl4965_eeprom eeprom;
 
-	int iw_mode;
+	enum ieee80211_if_types iw_mode;
 
 	struct sk_buff *ibss_beacon;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e979a5c..3cc9b3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2058,6 +2058,8 @@ int iwl3945_is_network_packet(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 			return !compare_ether_addr(header->addr2, priv->bssid);
 		/* packets to our adapter go through */
 		return !compare_ether_addr(header->addr1, priv->mac_addr);
+	default:
+		return 1;
 	}
 
 	return 1;
@@ -2302,6 +2304,9 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
 		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
+	default:
+		IWL_ERROR("Unsupported interface type %d\n", priv->iw_mode);
+		break;
 	}
 
 #if 0
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index b424137..a920109 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1793,6 +1793,8 @@ int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *heade
 			return !compare_ether_addr(header->addr2, priv->bssid);
 		/* packets to our adapter go through */
 		return !compare_ether_addr(header->addr1, priv->mac_addr);
+	default:
+		break;
 	}
 
 	return 1;
@@ -2054,6 +2056,9 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
+	default:
+		IWL_ERROR("Unsupported interface type %d\n", priv->iw_mode);
+		break;
 	}
 
 #if 0
-- 
1.5.3.4

