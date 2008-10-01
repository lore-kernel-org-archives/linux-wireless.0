Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50407 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYJACXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 22:23:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/5] wireless: consolidate on a single escape_essid implementation
Date: Tue, 30 Sep 2008 22:15:48 -0400
Message-Id: <1222827352-1978-2-git-send-email-linville@tuxdriver.com> (sfid-20081001_042410_686386_3BF35737)
In-Reply-To: <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/ipw2100.c              |   10 +-
 drivers/net/wireless/ipw2200.c              |  126 +++++++++++++-------------
 drivers/net/wireless/ipw2200.h              |    1 +
 drivers/net/wireless/iwlwifi/Kconfig        |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   53 ++----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 +---------
 drivers/net/wireless/libertas/assoc.c       |   14 ++--
 drivers/net/wireless/libertas/cmd.c         |    3 +-
 drivers/net/wireless/libertas/debugfs.c     |    3 +-
 drivers/net/wireless/libertas/decl.h        |    4 -
 drivers/net/wireless/libertas/main.c        |   27 ------
 drivers/net/wireless/libertas/scan.c        |   11 ++-
 drivers/net/wireless/libertas/wext.c        |    3 +-
 include/net/ieee80211.h                     |   20 ----
 include/net/lib80211.h                      |   31 +++++++
 net/ieee80211/Kconfig                       |    1 +
 net/ieee80211/ieee80211_module.c            |   26 ------
 net/ieee80211/ieee80211_rx.c                |   31 ++++---
 net/ieee80211/ieee80211_wx.c                |    6 +-
 net/wireless/Kconfig                        |   10 ++
 net/wireless/Makefile                       |    1 +
 net/wireless/lib80211.c                     |   58 ++++++++++++
 23 files changed, 223 insertions(+), 267 deletions(-)
 create mode 100644 include/net/lib80211.h
 create mode 100644 net/wireless/lib80211.c

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 45bdf0b..42afaed 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -271,6 +271,7 @@ config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
 	select WIRELESS_EXT
+	select LIB80211
 	select FW_LOADER
 	---help---
 	  A library for Marvell Libertas 8xxx devices.
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index bca7481..df8d1b3 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -1977,7 +1977,7 @@ static void isr_indicate_associated(struct ipw2100_priv *priv, u32 status)
 
 	IPW_DEBUG_INFO("%s: Associated with '%s' at %s, channel %d (BSSID="
 		       "%s)\n",
-		       priv->net_dev->name, escape_essid(essid, essid_len),
+		       priv->net_dev->name, escape_ssid(essid, essid_len),
 		       txratename, chan, print_mac(mac, bssid));
 
 	/* now we copy read ssid into dev */
@@ -2005,7 +2005,7 @@ static int ipw2100_set_essid(struct ipw2100_priv *priv, char *essid,
 	};
 	int err;
 
-	IPW_DEBUG_HC("SSID: '%s'\n", escape_essid(essid, ssid_len));
+	IPW_DEBUG_HC("SSID: '%s'\n", escape_ssid(essid, ssid_len));
 
 	if (ssid_len)
 		memcpy(cmd.host_command_parameters, essid, ssid_len);
@@ -2050,7 +2050,7 @@ static void isr_indicate_association_lost(struct ipw2100_priv *priv, u32 status)
 
 	IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE | IPW_DL_ASSOC,
 		  "disassociated: '%s' %s \n",
-		  escape_essid(priv->essid, priv->essid_len),
+		  escape_ssid(priv->essid, priv->essid_len),
 		  print_mac(mac, priv->bssid));
 
 	priv->status &= ~(STATUS_ASSOCIATED | STATUS_ASSOCIATING);
@@ -7000,7 +7000,7 @@ static int ipw2100_wx_set_essid(struct net_device *dev,
 		goto done;
 	}
 
-	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n", escape_essid(essid, length),
+	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n", escape_ssid(essid, length),
 		     length);
 
 	priv->essid_len = length;
@@ -7027,7 +7027,7 @@ static int ipw2100_wx_get_essid(struct net_device *dev,
 	 * configured ESSID then return that; otherwise return ANY */
 	if (priv->config & CFG_STATIC_ESSID || priv->status & STATUS_ASSOCIATED) {
 		IPW_DEBUG_WX("Getting essid: '%s'\n",
-			     escape_essid(priv->essid, priv->essid_len));
+			     escape_ssid(priv->essid, priv->essid_len));
 		memcpy(extra, priv->essid, priv->essid_len);
 		wrqu->essid.length = priv->essid_len;
 		wrqu->essid.flags = 1;	/* active */
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..41f9e46 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -4413,8 +4413,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 						  IPW_DL_ASSOC,
 						  "associated: '%s' %s"
 						  " \n",
-						  escape_essid(priv->essid,
-							       priv->essid_len),
+						  escape_ssid(priv->essid,
+							      priv->essid_len),
 						  print_mac(mac, priv->bssid));
 
 					switch (priv->ieee->iw_mode) {
@@ -4494,10 +4494,10 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 							  "deauthenticated: '%s' "
 							  "%s"
 							  ": (0x%04X) - %s \n",
-							  escape_essid(priv->
-								       essid,
-								       priv->
-								       essid_len),
+							  escape_ssid(priv->
+								      essid,
+								      priv->
+								      essid_len),
 							  print_mac(mac, priv->bssid),
 							  le16_to_cpu(auth->status),
 							  ipw_get_status_code
@@ -4517,8 +4517,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 						  IPW_DL_ASSOC,
 						  "authenticated: '%s' %s"
 						  "\n",
-						  escape_essid(priv->essid,
-							       priv->essid_len),
+						  escape_ssid(priv->essid,
+							      priv->essid_len),
 						  print_mac(mac, priv->bssid));
 					break;
 				}
@@ -4546,8 +4546,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 						  IPW_DL_ASSOC,
 						  "disassociated: '%s' %s"
 						  " \n",
-						  escape_essid(priv->essid,
-							       priv->essid_len),
+						  escape_ssid(priv->essid,
+							      priv->essid_len),
 						  print_mac(mac, priv->bssid));
 
 					priv->status &=
@@ -4584,8 +4584,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 			case CMAS_AUTHENTICATED:
 				IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE,
 					  "authenticated: '%s' %s \n",
-					  escape_essid(priv->essid,
-						       priv->essid_len),
+					  escape_ssid(priv->essid,
+						      priv->essid_len),
 					  print_mac(mac, priv->bssid));
 				priv->status |= STATUS_AUTH;
 				break;
@@ -4603,8 +4603,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 				IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE |
 					  IPW_DL_ASSOC,
 					  "deauthenticated: '%s' %s\n",
-					  escape_essid(priv->essid,
-						       priv->essid_len),
+					  escape_ssid(priv->essid,
+						      priv->essid_len),
 					  print_mac(mac, priv->bssid));
 
 				priv->status &= ~(STATUS_ASSOCIATING |
@@ -5438,7 +5438,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	     !(network->capability & WLAN_CAPABILITY_IBSS))) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded due to "
 				"capability mismatch.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5448,7 +5448,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (network->flags & NETWORK_EMPTY_ESSID) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of hidden ESSID.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5461,8 +5461,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 			   network->ssid_len)) {
 			IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 					"because of non-network ESSID.\n",
-					escape_essid(network->ssid,
-						     network->ssid_len),
+					escape_ssid(network->ssid,
+						    network->ssid_len),
 					print_mac(mac, network->bssid));
 			return 0;
 		}
@@ -5476,13 +5476,13 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 
 			strncpy(escaped,
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				sizeof(escaped));
 			IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 					"because of ESSID mismatch: '%s'.\n",
 					escaped, print_mac(mac, network->bssid),
-					escape_essid(priv->essid,
-						     priv->essid_len));
+					escape_ssid(priv->essid,
+						    priv->essid_len));
 			return 0;
 		}
 	}
@@ -5493,14 +5493,14 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (network->time_stamp[0] < match->network->time_stamp[0]) {
 		IPW_DEBUG_MERGE("Network '%s excluded because newer than "
 				"current network.\n",
-				escape_essid(match->network->ssid,
-					     match->network->ssid_len));
+				escape_ssid(match->network->ssid,
+					    match->network->ssid_len));
 		return 0;
 	} else if (network->time_stamp[1] < match->network->time_stamp[1]) {
 		IPW_DEBUG_MERGE("Network '%s excluded because newer than "
 				"current network.\n",
-				escape_essid(match->network->ssid,
-					     match->network->ssid_len));
+				escape_ssid(match->network->ssid,
+					    match->network->ssid_len));
 		return 0;
 	}
 
@@ -5509,7 +5509,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	    time_after(jiffies, network->last_scanned + priv->ieee->scan_age)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of age: %ums.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				jiffies_to_msecs(jiffies -
 						 network->last_scanned));
@@ -5520,7 +5520,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	    (network->channel != priv->channel)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of channel mismatch: %d != %d.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				network->channel, priv->channel);
 		return 0;
@@ -5531,7 +5531,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	    ((network->capability & WLAN_CAPABILITY_PRIVACY) ? 1 : 0)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of privacy mismatch: %s != %s.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				priv->
 				capability & CAP_PRIVACY_ON ? "on" : "off",
@@ -5544,8 +5544,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (!memcmp(network->bssid, priv->bssid, ETH_ALEN)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of the same BSSID match: %s"
-				".\n", escape_essid(network->ssid,
-						    network->ssid_len),
+				".\n", escape_ssid(network->ssid,
+						   network->ssid_len),
 				print_mac(mac, network->bssid),
 				print_mac(mac2, priv->bssid));
 		return 0;
@@ -5556,7 +5556,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of invalid frequency/mode "
 				"combination.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5567,7 +5567,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because configured rate mask excludes "
 				"AP mandatory rate.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5575,7 +5575,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (rates.num_rates == 0) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of no compatible rates.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5588,7 +5588,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	ipw_copy_rates(&match->rates, &rates);
 	match->network = network;
 	IPW_DEBUG_MERGE("Network '%s (%s)' is a viable match.\n",
-			escape_essid(network->ssid, network->ssid_len),
+			escape_ssid(network->ssid, network->ssid_len),
 			print_mac(mac, network->bssid));
 
 	return 1;
@@ -5626,8 +5626,8 @@ static void ipw_merge_adhoc_network(struct work_struct *work)
 		mutex_lock(&priv->mutex);
 		if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
 			IPW_DEBUG_MERGE("remove network %s\n",
-					escape_essid(priv->essid,
-						     priv->essid_len));
+					escape_ssid(priv->essid,
+						    priv->essid_len));
 			ipw_remove_current_network(priv);
 		}
 
@@ -5653,7 +5653,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	     !(network->capability & WLAN_CAPABILITY_IBSS))) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded due to "
 				"capability mismatch.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5663,7 +5663,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (network->flags & NETWORK_EMPTY_ESSID) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of hidden ESSID.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5676,8 +5676,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 			   network->ssid_len)) {
 			IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 					"because of non-network ESSID.\n",
-					escape_essid(network->ssid,
-						     network->ssid_len),
+					escape_ssid(network->ssid,
+						    network->ssid_len),
 					print_mac(mac, network->bssid));
 			return 0;
 		}
@@ -5690,13 +5690,13 @@ static int ipw_best_network(struct ipw_priv *priv,
 			    min(network->ssid_len, priv->essid_len)))) {
 			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 			strncpy(escaped,
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				sizeof(escaped));
 			IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 					"because of ESSID mismatch: '%s'.\n",
 					escaped, print_mac(mac, network->bssid),
-					escape_essid(priv->essid,
-						     priv->essid_len));
+					escape_ssid(priv->essid,
+						    priv->essid_len));
 			return 0;
 		}
 	}
@@ -5706,13 +5706,13 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (match->network && match->network->stats.rssi > network->stats.rssi) {
 		char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 		strncpy(escaped,
-			escape_essid(network->ssid, network->ssid_len),
+			escape_ssid(network->ssid, network->ssid_len),
 			sizeof(escaped));
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded because "
 				"'%s (%s)' has a stronger signal.\n",
 				escaped, print_mac(mac, network->bssid),
-				escape_essid(match->network->ssid,
-					     match->network->ssid_len),
+				escape_ssid(match->network->ssid,
+					    match->network->ssid_len),
 				print_mac(mac, match->network->bssid));
 		return 0;
 	}
@@ -5724,7 +5724,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of storming (%ums since last "
 				"assoc attempt).\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				jiffies_to_msecs(jiffies -
 						 network->last_associate));
@@ -5736,7 +5736,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    time_after(jiffies, network->last_scanned + priv->ieee->scan_age)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of age: %ums.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				jiffies_to_msecs(jiffies -
 						 network->last_scanned));
@@ -5747,7 +5747,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    (network->channel != priv->channel)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of channel mismatch: %d != %d.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				network->channel, priv->channel);
 		return 0;
@@ -5758,7 +5758,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    ((network->capability & WLAN_CAPABILITY_PRIVACY) ? 1 : 0)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of privacy mismatch: %s != %s.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid),
 				priv->capability & CAP_PRIVACY_ON ? "on" :
 				"off",
@@ -5771,7 +5771,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    memcmp(network->bssid, priv->bssid, ETH_ALEN)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of BSSID mismatch: %s.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid), print_mac(mac, priv->bssid));
 		return 0;
 	}
@@ -5781,7 +5781,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of invalid frequency/mode "
 				"combination.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5790,7 +5790,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (!ieee80211_is_valid_channel(priv->ieee, network->channel)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of invalid channel in current GEO\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5801,7 +5801,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because configured rate mask excludes "
 				"AP mandatory rate.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5809,7 +5809,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (rates.num_rates == 0) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of no compatible rates.\n",
-				escape_essid(network->ssid, network->ssid_len),
+				escape_ssid(network->ssid, network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5823,7 +5823,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	match->network = network;
 
 	IPW_DEBUG_ASSOC("Network '%s (%s)' is a viable match.\n",
-			escape_essid(network->ssid, network->ssid_len),
+			escape_ssid(network->ssid, network->ssid_len),
 			print_mac(mac, network->bssid));
 
 	return 1;
@@ -6075,7 +6075,7 @@ static void ipw_debug_config(struct ipw_priv *priv)
 		IPW_DEBUG_INFO("Channel unlocked.\n");
 	if (priv->config & CFG_STATIC_ESSID)
 		IPW_DEBUG_INFO("ESSID locked to '%s'\n",
-			       escape_essid(priv->essid, priv->essid_len));
+			       escape_ssid(priv->essid, priv->essid_len));
 	else
 		IPW_DEBUG_INFO("ESSID unlocked.\n");
 	if (priv->config & CFG_STATIC_BSSID)
@@ -7364,7 +7364,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 	IPW_DEBUG_ASSOC("%sssocation attempt: '%s', channel %d, "
 			"802.11%c [%d], %s[:%s], enc=%s%s%s%c%c\n",
 			roaming ? "Rea" : "A",
-			escape_essid(priv->essid, priv->essid_len),
+			escape_ssid(priv->essid, priv->essid_len),
 			network->channel,
 			ipw_modes[priv->assoc_request.ieee_mode],
 			rates->num_rates,
@@ -7464,7 +7464,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 	}
 
 	IPW_DEBUG(IPW_DL_STATE, "associating: '%s' %s \n",
-		  escape_essid(priv->essid, priv->essid_len),
+		  escape_ssid(priv->essid, priv->essid_len),
 		  print_mac(mac, priv->bssid));
 
 	return 0;
@@ -7617,8 +7617,8 @@ static int ipw_associate(void *data)
 			target = oldest;
 			IPW_DEBUG_ASSOC("Expired '%s' (%s) from "
 					"network list.\n",
-					escape_essid(target->ssid,
-						     target->ssid_len),
+					escape_ssid(target->ssid,
+						    target->ssid_len),
 					print_mac(mac, target->bssid));
 			list_add_tail(&target->list,
 				      &priv->ieee->network_free_list);
@@ -9081,7 +9081,7 @@ static int ipw_wx_set_essid(struct net_device *dev,
 		return 0;
 	}
 
-	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n", escape_essid(extra, length),
+	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n", escape_ssid(extra, length),
 		     length);
 
 	priv->essid_len = length;
@@ -9108,7 +9108,7 @@ static int ipw_wx_get_essid(struct net_device *dev,
 	if (priv->config & CFG_STATIC_ESSID ||
 	    priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)) {
 		IPW_DEBUG_WX("Getting essid: '%s'\n",
-			     escape_essid(priv->essid, priv->essid_len));
+			     escape_ssid(priv->essid, priv->essid_len));
 		memcpy(extra, priv->essid, priv->essid_len);
 		wrqu->essid.length = priv->essid_len;
 		wrqu->essid.flags = 1;	/* active */
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2200.h
index 0bad1ec..0a84d52 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -48,6 +48,7 @@
 #include <linux/jiffies.h>
 #include <asm/io.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <net/ieee80211_radiotap.h>
 
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b0ac0ce..47bee0e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -4,6 +4,7 @@ config IWLWIFI
 config IWLCORE
 	tristate "Intel Wireless Wifi Core"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select LIB80211
 	select IWLWIFI
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
@@ -105,6 +106,7 @@ config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
+	select LIB80211
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index bf855c3..9488e50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -25,8 +25,10 @@
  * Tomas Winkler <tomas.winkler@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
-#include <net/mac80211.h>
+#include <linux/types.h>
 #include <linux/etherdevice.h>
+#include <net/lib80211.h>
+#include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -69,49 +71,6 @@ static int scan_tx_ant[3] = {
 };
 
 
-
-static int iwl_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
-
-
-static const char *iwl_escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (iwl_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else
-			*d++ = *s++;
-	}
-	*d = '\0';
-	return escaped;
-}
-
 /**
  * iwl_scan_cancel - Cancel any currently executing HW scan
  *
@@ -796,8 +755,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	/* We should add the ability for user to lock to PASSIVE ONLY */
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s'\n",
-				iwl_escape_essid(priv->direct_ssid,
-				priv->direct_ssid_len));
+				escape_ssid(priv->direct_ssid,
+					    priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
@@ -805,7 +764,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		n_probes++;
 	} else if (!iwl_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
-				iwl_escape_essid(priv->essid, priv->essid_len));
+				escape_ssid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d15a2c9..c81b743 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -41,6 +41,7 @@
 #include <linux/if_arp.h>
 
 #include <net/ieee80211_radiotap.h>
+#include <net/lib80211.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
@@ -107,46 +108,6 @@ static const struct ieee80211_supported_band *iwl3945_get_band(
 	return priv->hw->wiphy->bands[band];
 }
 
-static int iwl3945_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
-static const char *iwl3945_escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (iwl3945_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else
-			*d++ = *s++;
-	}
-	*d = '\0';
-	return escaped;
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -6202,8 +6163,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN
 		    ("Kicking off one direct scan for '%s'\n",
-		     iwl3945_escape_essid(priv->direct_ssid,
-				      priv->direct_ssid_len));
+		     escape_ssid(priv->direct_ssid, priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
@@ -6212,7 +6172,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	} else if (!iwl3945_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN
 		  ("Kicking off one direct scan for '%s' when not associated\n",
-		   iwl3945_escape_essid(priv->essid, priv->essid_len));
+		   escape_ssid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
@@ -7031,7 +6991,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	}
 	if (len) {
 		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
-			       iwl3945_escape_essid(ssid, len), (int)len);
+			       escape_ssid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len = (u8)
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 92be604..693d786 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,8 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
+#include <linux/types.h>
 #include <linux/etherdevice.h>
+#include <net/lib80211.h>
 
 #include "assoc.h"
 #include "decl.h"
@@ -158,11 +160,11 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	lbs_deb_join("current SSID '%s', ssid length %u\n",
-		escape_essid(priv->curbssparams.ssid,
+		escape_ssid(priv->curbssparams.ssid,
 		priv->curbssparams.ssid_len),
 		priv->curbssparams.ssid_len);
 	lbs_deb_join("requested ssid '%s', ssid length %u\n",
-		escape_essid(bss->ssid, bss->ssid_len),
+		escape_ssid(bss->ssid, bss->ssid_len),
 		bss->ssid_len);
 
 	/* check if the requested SSID is already joined */
@@ -326,7 +328,7 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 	memcpy(cmd.ssid, assoc_req->ssid, assoc_req->ssid_len);
 
 	lbs_deb_join("ADHOC_START: SSID '%s', ssid length %u\n",
-		escape_essid(assoc_req->ssid, assoc_req->ssid_len),
+		escape_ssid(assoc_req->ssid, assoc_req->ssid_len),
 		assoc_req->ssid_len);
 
 	cmd.bsstype = CMD_BSS_TYPE_IBSS;
@@ -705,7 +707,7 @@ static int assoc_helper_essid(struct lbs_private *priv,
 		channel = assoc_req->channel;
 
 	lbs_deb_assoc("SSID '%s' requested\n",
-	              escape_essid(assoc_req->ssid, assoc_req->ssid_len));
+	              escape_ssid(assoc_req->ssid, assoc_req->ssid_len));
 	if (assoc_req->mode == IW_MODE_INFRA) {
 		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
 			assoc_req->ssid_len);
@@ -1232,7 +1234,7 @@ void lbs_association_worker(struct work_struct *work)
 		"    secinfo:  %s%s%s\n"
 		"    auth_mode: %d\n",
 		assoc_req->flags,
-		escape_essid(assoc_req->ssid, assoc_req->ssid_len),
+		escape_ssid(assoc_req->ssid, assoc_req->ssid_len),
 		assoc_req->channel, assoc_req->band, assoc_req->mode,
 		print_mac(mac, assoc_req->bssid),
 		assoc_req->secinfo.WPAenabled ? " WPA" : "",
@@ -1820,7 +1822,7 @@ static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp)
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
 	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %s, channel %d\n",
-		     escape_essid(bss->ssid, bss->ssid_len),
+		     escape_ssid(bss->ssid, bss->ssid_len),
 		     print_mac(mac, priv->curbssparams.bssid),
 		     priv->curbssparams.channel);
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index a912fb6..c1048fd 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -4,6 +4,7 @@
   */
 
 #include <net/iw_handler.h>
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <linux/kfifo.h>
 #include "host.h"
@@ -1091,7 +1092,7 @@ int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
 	}
 	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
 		    action, priv->mesh_tlv, chan,
-		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
+		    escape_ssid(priv->mesh_ssid, priv->mesh_ssid_len));
 
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 0aa0ce3..89f5d62 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <net/iw_handler.h>
+#include <net/lib80211.h>
 
 #include "dev.h"
 #include "decl.h"
@@ -87,7 +88,7 @@ static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 				spectrum_mgmt ? 'S' : ' ');
 		pos += snprintf(buf+pos, len-pos, " %04d |", SCAN_RSSI(iter_bss->rssi));
 		pos += snprintf(buf+pos, len-pos, " %s\n",
-		                escape_essid(iter_bss->ssid, iter_bss->ssid_len));
+		                escape_ssid(iter_bss->ssid, iter_bss->ssid_len));
 
 		numscansdone++;
 	}
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 1a8888c..0b84bdc 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -74,8 +74,4 @@ void lbs_host_to_card_done(struct lbs_private *priv);
 
 int lbs_update_channel(struct lbs_private *priv);
 
-#ifndef CONFIG_IEEE80211
-const char *escape_essid(const char *essid, u8 essid_len);
-#endif
-
 #endif
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 73dc8c7..b30e845 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1647,33 +1647,6 @@ out:
 	return ret;
 }
 
-#ifndef CONFIG_IEEE80211
-const char *escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (ieee80211_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
-	*d = '\0';
-	return escaped;
-}
-#endif
-
 module_init(lbs_init_module);
 module_exit(lbs_exit_module);
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 8f66903..fd0f640 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -4,9 +4,12 @@
   * IOCTL handlers as well as command preperation and response routines
   *  for sending scan commands to the firmware.
   */
+#include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
+#include <net/lib80211.h>
+
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
@@ -453,7 +456,7 @@ int lbs_scan_networks(struct lbs_private *priv, int full_scan)
 	list_for_each_entry(iter, &priv->network_list, list)
 		lbs_deb_scan("%02d: BSSID %s, RSSI %d, SSID '%s'\n",
 			     i++, print_mac(mac, iter->bssid), iter->rssi,
-			     escape_essid(iter->ssid, iter->ssid_len));
+			     escape_ssid(iter->ssid, iter->ssid_len));
 	mutex_unlock(&priv->lock);
 #endif
 
@@ -601,7 +604,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 			bss->ssid_len = elem->len;
 			memcpy(bss->ssid, elem->data, elem->len);
 			lbs_deb_scan("got SSID IE: '%s', len %u\n",
-			             escape_essid(bss->ssid, bss->ssid_len),
+			             escape_ssid(bss->ssid, bss->ssid_len),
 			             bss->ssid_len);
 			break;
 
@@ -744,7 +747,7 @@ int lbs_send_specific_ssid_scan(struct lbs_private *priv, uint8_t *ssid,
 	int ret = 0;
 
 	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s'\n",
-			   escape_essid(ssid, ssid_len));
+			   escape_ssid(ssid, ssid_len));
 
 	if (!ssid_len)
 		goto out;
@@ -968,7 +971,7 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 		priv->scan_ssid_len = req->essid_len;
 		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
 		lbs_deb_wext("set_scan, essid '%s'\n",
-			escape_essid(priv->scan_ssid, priv->scan_ssid_len));
+			escape_ssid(priv->scan_ssid, priv->scan_ssid_len));
 	} else {
 		priv->scan_ssid_len = 0;
 	}
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 82c3e5a..12baf0d 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -8,6 +8,7 @@
 #include <linux/wireless.h>
 #include <linux/bitops.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <net/iw_handler.h>
 
@@ -2005,7 +2006,7 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 		lbs_deb_wext("requested any SSID\n");
 	} else {
 		lbs_deb_wext("requested SSID '%s'\n",
-		             escape_essid(ssid, ssid_len));
+		             escape_ssid(ssid, ssid_len));
 	}
 
 out:
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index 6048579..c638239 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -127,10 +127,6 @@ static inline bool ieee80211_ratelimit_debug(u32 level)
 }
 #endif				/* CONFIG_IEEE80211_DEBUG */
 
-/* escape_essid() is intended to be used in debug (and possibly error)
- * messages. It should never be used for passing essid to user space. */
-const char *escape_essid(const char *essid, u8 essid_len);
-
 /*
  * To use the debug system:
  *
@@ -1135,22 +1131,6 @@ static inline void *ieee80211_priv(struct net_device *dev)
 	return ((struct ieee80211_device *)netdev_priv(dev))->priv;
 }
 
-static inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
 static inline int ieee80211_is_valid_mode(struct ieee80211_device *ieee,
 					  int mode)
 {
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
new file mode 100644
index 0000000..91a64f3
--- /dev/null
+++ b/include/net/lib80211.h
@@ -0,0 +1,31 @@
+/*
+ * lib80211.h -- common bits for IEEE802.11 wireless drivers
+ *
+ * Copyright (c) 2008, John W. Linville <linville@tuxdriver.com>
+ *
+ */
+
+#ifndef LIB80211_H
+#define LIB80211_H
+
+/* escape_ssid() is intended to be used in debug (and possibly error)
+ * messages. It should never be used for passing ssid to user space. */
+const char *escape_ssid(const char *ssid, u8 ssid_len);
+
+static inline int is_empty_ssid(const char *ssid, int ssid_len)
+{
+	/* Single white space is for Linksys APs */
+	if (ssid_len == 1 && ssid[0] == ' ')
+		return 1;
+
+	/* Otherwise, if the entire ssid is 0, we assume it is hidden */
+	while (ssid_len) {
+		ssid_len--;
+		if (ssid[ssid_len] != '\0')
+			return 0;
+	}
+
+	return 1;
+}
+
+#endif /* LIB80211_H */
diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
index 94ed7d3..dc3eeed 100644
--- a/net/ieee80211/Kconfig
+++ b/net/ieee80211/Kconfig
@@ -1,5 +1,6 @@
 config IEEE80211
 	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
+	select LIB80211
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.  This component is deprecated in favor of the
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index 949772a..d34d4e7 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -308,31 +308,5 @@ MODULE_PARM_DESC(debug, "debug output mask");
 module_exit(ieee80211_exit);
 module_init(ieee80211_init);
 
-const char *escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (ieee80211_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
-	*d = '\0';
-	return escaped;
-}
-
 EXPORT_SYMBOL(alloc_ieee80211);
 EXPORT_SYMBOL(free_ieee80211);
-EXPORT_SYMBOL(escape_essid);
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 69dbc34..34239db 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -32,6 +32,7 @@
 #include <asm/uaccess.h>
 #include <linux/ctype.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 
 static void ieee80211_monitor_rx(struct ieee80211_device *ieee,
@@ -1166,8 +1167,8 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 
 		switch (info_element->id) {
 		case MFIE_TYPE_SSID:
-			if (ieee80211_is_empty_essid(info_element->data,
-						     info_element->len)) {
+			if (is_empty_ssid(info_element->data,
+					  info_element->len)) {
 				network->flags |= NETWORK_EMPTY_ESSID;
 				break;
 			}
@@ -1411,7 +1412,7 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
 			network->mode |= IEEE_B;
 	}
 
-	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
+	if (is_empty_ssid(network->ssid, network->ssid_len))
 		network->flags |= NETWORK_EMPTY_ESSID;
 
 	memcpy(&network->stats, stats, sizeof(network->stats));
@@ -1479,13 +1480,13 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 	if (network->mode == 0) {
 		IEEE80211_DEBUG_SCAN("Filtered out '%s (%s)' "
 				     "network.\n",
-				     escape_essid(network->ssid,
-						  network->ssid_len),
+				     escape_ssid(network->ssid,
+						 network->ssid_len),
 				     print_mac(mac, network->bssid));
 		return 1;
 	}
 
-	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
+	if (is_empty_ssid(network->ssid, network->ssid_len))
 		network->flags |= NETWORK_EMPTY_ESSID;
 
 	memcpy(&network->stats, stats, sizeof(network->stats));
@@ -1601,7 +1602,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 
 	IEEE80211_DEBUG_SCAN("'%s' (%s"
 		     "): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
-		     escape_essid(info_element->data, info_element->len),
+		     escape_ssid(info_element->data, info_element->len),
 		     print_mac(mac, beacon->header.addr3),
 		     (beacon->capability & cpu_to_le16(1 << 0xf)) ? '1' : '0',
 		     (beacon->capability & cpu_to_le16(1 << 0xe)) ? '1' : '0',
@@ -1622,8 +1623,8 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 
 	if (ieee80211_network_init(ieee, beacon, &network, stats)) {
 		IEEE80211_DEBUG_SCAN("Dropped '%s' (%s) via %s.\n",
-				     escape_essid(info_element->data,
-						  info_element->len),
+				     escape_ssid(info_element->data,
+						 info_element->len),
 				     print_mac(mac, beacon->header.addr3),
 				     is_beacon(beacon->header.frame_ctl) ?
 				     "BEACON" : "PROBE RESPONSE");
@@ -1660,8 +1661,8 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 			target = oldest;
 			IEEE80211_DEBUG_SCAN("Expired '%s' (%s) from "
 					     "network list.\n",
-					     escape_essid(target->ssid,
-							  target->ssid_len),
+					     escape_ssid(target->ssid,
+							 target->ssid_len),
 					     print_mac(mac, target->bssid));
 			ieee80211_network_reset(target);
 		} else {
@@ -1673,8 +1674,8 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 
 #ifdef CONFIG_IEEE80211_DEBUG
 		IEEE80211_DEBUG_SCAN("Adding '%s' (%s) via %s.\n",
-				     escape_essid(network.ssid,
-						  network.ssid_len),
+				     escape_ssid(network.ssid,
+						 network.ssid_len),
 				     print_mac(mac, network.bssid),
 				     is_beacon(beacon->header.frame_ctl) ?
 				     "BEACON" : "PROBE RESPONSE");
@@ -1684,8 +1685,8 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 		list_add_tail(&target->list, &ieee->network_list);
 	} else {
 		IEEE80211_DEBUG_SCAN("Updating '%s' (%s) via %s.\n",
-				     escape_essid(target->ssid,
-						  target->ssid_len),
+				     escape_ssid(target->ssid,
+						 target->ssid_len),
 				     print_mac(mac, target->bssid),
 				     is_beacon(beacon->header.frame_ctl) ?
 				     "BEACON" : "PROBE RESPONSE");
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index 973832d..c338279 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -284,8 +284,8 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 		else
 			IEEE80211_DEBUG_SCAN("Not showing network '%s ("
 					     "%s)' due to age (%dms).\n",
-					     escape_essid(network->ssid,
-							  network->ssid_len),
+					     escape_ssid(network->ssid,
+							 network->ssid_len),
 					     print_mac(mac, network->bssid),
 					     jiffies_to_msecs(jiffies -
 							      network->
@@ -409,7 +409,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 			memset(sec.keys[key] + erq->length, 0,
 			       len - erq->length);
 		IEEE80211_DEBUG_WX("Setting key %d to '%s' (%d:%d bytes)\n",
-				   key, escape_essid(sec.keys[key], len),
+				   key, escape_ssid(sec.keys[key], len),
 				   erq->length, len);
 		sec.key_sizes[key] = len;
 		if (*crypt)
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index b97bd9f..2efaa02 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -73,3 +73,13 @@ config WIRELESS_EXT_SYSFS
 
 	  Say Y if you have programs using it, like old versions of
 	  hal.
+
+config LIB80211
+	tristate "Common routines for IEEE802.11 drivers"
+	default n
+	help
+	  This options enables a library of common routines used
+	  by IEEE802.11 wireless LAN drivers.
+
+	  Drivers should select this themselves if needed.  Say Y if
+	  you want this built into your kernel.
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index b9f943c..d2d848d 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
+obj-$(CONFIG_LIB80211) += lib80211.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
new file mode 100644
index 0000000..b22d271
--- /dev/null
+++ b/net/wireless/lib80211.c
@@ -0,0 +1,58 @@
+/*
+ * lib80211 -- common bits for IEEE802.11 drivers
+ *
+ * Copyright(c) 2008 John W. Linville <linville@tuxdriver.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/ieee80211.h>
+
+#include <net/lib80211.h>
+
+#define DRV_NAME        "lib80211"
+
+#define DRV_DESCRIPTION	"common routines for IEEE802.11 drivers"
+
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_AUTHOR("John W. Linville <linville@tuxdriver.com>");
+MODULE_LICENSE("GPL");
+
+const char *escape_ssid(const char *ssid, u8 ssid_len)
+{
+	static char escaped[IEEE80211_MAX_SSID_LEN * 2 + 1];
+	const char *s = ssid;
+	char *d = escaped;
+
+	if (is_empty_ssid(ssid, ssid_len)) {
+		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
+		return escaped;
+	}
+
+	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
+	while (ssid_len--) {
+		if (*s == '\0') {
+			*d++ = '\\';
+			*d++ = '0';
+			s++;
+		} else {
+			*d++ = *s++;
+		}
+	}
+	*d = '\0';
+	return escaped;
+}
+EXPORT_SYMBOL(escape_ssid);
+
+static int __init ieee80211_init(void)
+{
+	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION "\n");
+	return 0;
+}
+
+static void __exit ieee80211_exit(void)
+{
+}
+
+module_init(ieee80211_init);
+module_exit(ieee80211_exit);
-- 
1.5.4.3

