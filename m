Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50409 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYJACXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 22:23:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] wireless: use individual buffers for printing ssid values
Date: Tue, 30 Sep 2008 22:15:51 -0400
Message-Id: <1222827352-1978-5-git-send-email-linville@tuxdriver.com> (sfid-20081001_042411_035649_9281CA29)
In-Reply-To: <1222827352-1978-4-git-send-email-linville@tuxdriver.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-2-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-3-git-send-email-linville@tuxdriver.com>
 <1222827352-1978-4-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also change escape_ssid to print_ssid to match print_mac semantics.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2100.c              |   19 +++-
 drivers/net/wireless/ipw2200.c              |  153 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +-
 drivers/net/wireless/libertas/assoc.c       |   17 ++-
 drivers/net/wireless/libertas/cmd.c         |    3 +-
 drivers/net/wireless/libertas/debugfs.c     |    4 +-
 drivers/net/wireless/libertas/scan.c        |   12 ++-
 drivers/net/wireless/libertas/wext.c        |    3 +-
 include/linux/ieee80211.h                   |    6 +-
 include/net/lib80211.h                      |    5 +-
 net/ieee80211/ieee80211_rx.c                |   18 ++--
 net/ieee80211/ieee80211_wx.c                |    6 +-
 net/wireless/lib80211.c                     |    9 +-
 14 files changed, 165 insertions(+), 106 deletions(-)

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index df8d1b3..1846bf1 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -163,6 +163,8 @@ that only one external action is invoked at a time.
 #include <linux/ctype.h>
 #include <linux/pm_qos_params.h>
 
+#include <net/lib80211.h>
+
 #include "ipw2100.h"
 
 #define IPW2100_VERSION "git-1.2.2"
@@ -1915,6 +1917,7 @@ static void isr_indicate_associated(struct ipw2100_priv *priv, u32 status)
 	char *txratename;
 	u8 bssid[ETH_ALEN];
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	/*
 	 * TBD: BSSID is usually 00:00:00:00:00:00 here and not
@@ -1977,7 +1980,7 @@ static void isr_indicate_associated(struct ipw2100_priv *priv, u32 status)
 
 	IPW_DEBUG_INFO("%s: Associated with '%s' at %s, channel %d (BSSID="
 		       "%s)\n",
-		       priv->net_dev->name, escape_ssid(essid, essid_len),
+		       priv->net_dev->name, print_ssid(ssid, essid, essid_len),
 		       txratename, chan, print_mac(mac, bssid));
 
 	/* now we copy read ssid into dev */
@@ -2004,8 +2007,9 @@ static int ipw2100_set_essid(struct ipw2100_priv *priv, char *essid,
 		.host_command_length = ssid_len
 	};
 	int err;
+	DECLARE_SSID_BUF(ssid);
 
-	IPW_DEBUG_HC("SSID: '%s'\n", escape_ssid(essid, ssid_len));
+	IPW_DEBUG_HC("SSID: '%s'\n", print_ssid(ssid, essid, ssid_len));
 
 	if (ssid_len)
 		memcpy(cmd.host_command_parameters, essid, ssid_len);
@@ -2047,10 +2051,11 @@ static int ipw2100_set_essid(struct ipw2100_priv *priv, char *essid,
 static void isr_indicate_association_lost(struct ipw2100_priv *priv, u32 status)
 {
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE | IPW_DL_ASSOC,
 		  "disassociated: '%s' %s \n",
-		  escape_ssid(priv->essid, priv->essid_len),
+		  print_ssid(ssid, priv->essid, priv->essid_len),
 		  print_mac(mac, priv->bssid));
 
 	priv->status &= ~(STATUS_ASSOCIATED | STATUS_ASSOCIATING);
@@ -6971,6 +6976,7 @@ static int ipw2100_wx_set_essid(struct net_device *dev,
 	char *essid = "";	/* ANY */
 	int length = 0;
 	int err = 0;
+	DECLARE_SSID_BUF(ssid);
 
 	mutex_lock(&priv->action_mutex);
 	if (!(priv->status & STATUS_INITIALIZED)) {
@@ -7000,8 +7006,8 @@ static int ipw2100_wx_set_essid(struct net_device *dev,
 		goto done;
 	}
 
-	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n", escape_ssid(essid, length),
-		     length);
+	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n",
+		     print_ssid(ssid, essid, length), length);
 
 	priv->essid_len = length;
 	memcpy(priv->essid, essid, priv->essid_len);
@@ -7022,12 +7028,13 @@ static int ipw2100_wx_get_essid(struct net_device *dev,
 	 */
 
 	struct ipw2100_priv *priv = ieee80211_priv(dev);
+	DECLARE_SSID_BUF(ssid);
 
 	/* If we are associated, trying to associate, or have a statically
 	 * configured ESSID then return that; otherwise return ANY */
 	if (priv->config & CFG_STATIC_ESSID || priv->status & STATUS_ASSOCIATED) {
 		IPW_DEBUG_WX("Getting essid: '%s'\n",
-			     escape_ssid(priv->essid, priv->essid_len));
+			     print_ssid(ssid, priv->essid, priv->essid_len));
 		memcpy(extra, priv->essid, priv->essid_len);
 		wrqu->essid.length = priv->essid_len;
 		wrqu->essid.flags = 1;	/* active */
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index e6f77dd..4e4d3e3 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -4398,6 +4398,7 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 				       struct ipw_rx_notification *notif)
 {
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 	u16 size = le16_to_cpu(notif->size);
 	notif->size = le16_to_cpu(notif->size);
 
@@ -4413,8 +4414,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 						  IPW_DL_ASSOC,
 						  "associated: '%s' %s"
 						  " \n",
-						  escape_ssid(priv->essid,
-							      priv->essid_len),
+						  print_ssid(ssid, priv->essid,
+							     priv->essid_len),
 						  print_mac(mac, priv->bssid));
 
 					switch (priv->ieee->iw_mode) {
@@ -4494,10 +4495,11 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 							  "deauthenticated: '%s' "
 							  "%s"
 							  ": (0x%04X) - %s \n",
-							  escape_ssid(priv->
-								      essid,
-								      priv->
-								      essid_len),
+							  print_ssid(ssid,
+								     priv->
+								     essid,
+								     priv->
+								     essid_len),
 							  print_mac(mac, priv->bssid),
 							  le16_to_cpu(auth->status),
 							  ipw_get_status_code
@@ -4517,8 +4519,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 						  IPW_DL_ASSOC,
 						  "authenticated: '%s' %s"
 						  "\n",
-						  escape_ssid(priv->essid,
-							      priv->essid_len),
+						  print_ssid(ssid, priv->essid,
+							     priv->essid_len),
 						  print_mac(mac, priv->bssid));
 					break;
 				}
@@ -4546,8 +4548,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 						  IPW_DL_ASSOC,
 						  "disassociated: '%s' %s"
 						  " \n",
-						  escape_ssid(priv->essid,
-							      priv->essid_len),
+						  print_ssid(ssid, priv->essid,
+							     priv->essid_len),
 						  print_mac(mac, priv->bssid));
 
 					priv->status &=
@@ -4584,8 +4586,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 			case CMAS_AUTHENTICATED:
 				IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE,
 					  "authenticated: '%s' %s \n",
-					  escape_ssid(priv->essid,
-						      priv->essid_len),
+					  print_ssid(ssid, priv->essid,
+						     priv->essid_len),
 					  print_mac(mac, priv->bssid));
 				priv->status |= STATUS_AUTH;
 				break;
@@ -4603,8 +4605,8 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 				IPW_DEBUG(IPW_DL_NOTIF | IPW_DL_STATE |
 					  IPW_DL_ASSOC,
 					  "deauthenticated: '%s' %s\n",
-					  escape_ssid(priv->essid,
-						      priv->essid_len),
+					  print_ssid(ssid, priv->essid,
+						     priv->essid_len),
 					  print_mac(mac, priv->bssid));
 
 				priv->status &= ~(STATUS_ASSOCIATING |
@@ -5431,6 +5433,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	struct ipw_supported_rates rates;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
+	DECLARE_SSID_BUF(ssid);
 
 	/* Verify that this network's capability is compatible with the
 	 * current mode (AdHoc or Infrastructure) */
@@ -5438,7 +5441,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	     !(network->capability & WLAN_CAPABILITY_IBSS))) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded due to "
 				"capability mismatch.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5451,8 +5455,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 			   network->ssid_len)) {
 			IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 					"because of non-network ESSID.\n",
-					escape_ssid(network->ssid,
-						    network->ssid_len),
+					print_ssid(ssid, network->ssid,
+						   network->ssid_len),
 					print_mac(mac, network->bssid));
 			return 0;
 		}
@@ -5466,13 +5470,14 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 
 			strncpy(escaped,
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				sizeof(escaped));
 			IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 					"because of ESSID mismatch: '%s'.\n",
 					escaped, print_mac(mac, network->bssid),
-					escape_ssid(priv->essid,
-						    priv->essid_len));
+					print_ssid(ssid, priv->essid,
+						   priv->essid_len));
 			return 0;
 		}
 	}
@@ -5483,14 +5488,14 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (network->time_stamp[0] < match->network->time_stamp[0]) {
 		IPW_DEBUG_MERGE("Network '%s excluded because newer than "
 				"current network.\n",
-				escape_ssid(match->network->ssid,
-					    match->network->ssid_len));
+				print_ssid(ssid, match->network->ssid,
+					   match->network->ssid_len));
 		return 0;
 	} else if (network->time_stamp[1] < match->network->time_stamp[1]) {
 		IPW_DEBUG_MERGE("Network '%s excluded because newer than "
 				"current network.\n",
-				escape_ssid(match->network->ssid,
-					    match->network->ssid_len));
+				print_ssid(ssid, match->network->ssid,
+					   match->network->ssid_len));
 		return 0;
 	}
 
@@ -5499,7 +5504,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	    time_after(jiffies, network->last_scanned + priv->ieee->scan_age)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of age: %ums.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				jiffies_to_msecs(jiffies -
 						 network->last_scanned));
@@ -5510,7 +5516,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	    (network->channel != priv->channel)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of channel mismatch: %d != %d.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				network->channel, priv->channel);
 		return 0;
@@ -5521,7 +5528,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	    ((network->capability & WLAN_CAPABILITY_PRIVACY) ? 1 : 0)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of privacy mismatch: %s != %s.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				priv->
 				capability & CAP_PRIVACY_ON ? "on" : "off",
@@ -5534,8 +5542,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (!memcmp(network->bssid, priv->bssid, ETH_ALEN)) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of the same BSSID match: %s"
-				".\n", escape_ssid(network->ssid,
-						   network->ssid_len),
+				".\n", print_ssid(ssid, network->ssid,
+						  network->ssid_len),
 				print_mac(mac, network->bssid),
 				print_mac(mac2, priv->bssid));
 		return 0;
@@ -5546,7 +5554,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of invalid frequency/mode "
 				"combination.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5557,7 +5566,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because configured rate mask excludes "
 				"AP mandatory rate.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5565,7 +5575,8 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	if (rates.num_rates == 0) {
 		IPW_DEBUG_MERGE("Network '%s (%s)' excluded "
 				"because of no compatible rates.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5578,7 +5589,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 	ipw_copy_rates(&match->rates, &rates);
 	match->network = network;
 	IPW_DEBUG_MERGE("Network '%s (%s)' is a viable match.\n",
-			escape_ssid(network->ssid, network->ssid_len),
+			print_ssid(ssid, network->ssid, network->ssid_len),
 			print_mac(mac, network->bssid));
 
 	return 1;
@@ -5586,6 +5597,7 @@ static int ipw_find_adhoc_network(struct ipw_priv *priv,
 
 static void ipw_merge_adhoc_network(struct work_struct *work)
 {
+	DECLARE_SSID_BUF(ssid);
 	struct ipw_priv *priv =
 		container_of(work, struct ipw_priv, merge_networks);
 	struct ieee80211_network *network = NULL;
@@ -5616,8 +5628,8 @@ static void ipw_merge_adhoc_network(struct work_struct *work)
 		mutex_lock(&priv->mutex);
 		if ((priv->ieee->iw_mode == IW_MODE_ADHOC)) {
 			IPW_DEBUG_MERGE("remove network %s\n",
-					escape_ssid(priv->essid,
-						    priv->essid_len));
+					print_ssid(ssid, priv->essid,
+						   priv->essid_len));
 			ipw_remove_current_network(priv);
 		}
 
@@ -5634,6 +5646,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 {
 	struct ipw_supported_rates rates;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	/* Verify that this network's capability is compatible with the
 	 * current mode (AdHoc or Infrastructure) */
@@ -5643,7 +5656,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	     !(network->capability & WLAN_CAPABILITY_IBSS))) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded due to "
 				"capability mismatch.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5656,8 +5670,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 			   network->ssid_len)) {
 			IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 					"because of non-network ESSID.\n",
-					escape_ssid(network->ssid,
-						    network->ssid_len),
+					print_ssid(ssid, network->ssid,
+						   network->ssid_len),
 					print_mac(mac, network->bssid));
 			return 0;
 		}
@@ -5670,13 +5684,14 @@ static int ipw_best_network(struct ipw_priv *priv,
 			    min(network->ssid_len, priv->essid_len)))) {
 			char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 			strncpy(escaped,
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				sizeof(escaped));
 			IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 					"because of ESSID mismatch: '%s'.\n",
 					escaped, print_mac(mac, network->bssid),
-					escape_ssid(priv->essid,
-						    priv->essid_len));
+					print_ssid(ssid, priv->essid,
+						   priv->essid_len));
 			return 0;
 		}
 	}
@@ -5686,13 +5701,13 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (match->network && match->network->stats.rssi > network->stats.rssi) {
 		char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
 		strncpy(escaped,
-			escape_ssid(network->ssid, network->ssid_len),
+			print_ssid(ssid, network->ssid, network->ssid_len),
 			sizeof(escaped));
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded because "
 				"'%s (%s)' has a stronger signal.\n",
 				escaped, print_mac(mac, network->bssid),
-				escape_ssid(match->network->ssid,
-					    match->network->ssid_len),
+				print_ssid(ssid, match->network->ssid,
+					   match->network->ssid_len),
 				print_mac(mac, match->network->bssid));
 		return 0;
 	}
@@ -5704,7 +5719,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of storming (%ums since last "
 				"assoc attempt).\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				jiffies_to_msecs(jiffies -
 						 network->last_associate));
@@ -5716,7 +5732,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    time_after(jiffies, network->last_scanned + priv->ieee->scan_age)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of age: %ums.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				jiffies_to_msecs(jiffies -
 						 network->last_scanned));
@@ -5727,7 +5744,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    (network->channel != priv->channel)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of channel mismatch: %d != %d.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				network->channel, priv->channel);
 		return 0;
@@ -5738,7 +5756,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    ((network->capability & WLAN_CAPABILITY_PRIVACY) ? 1 : 0)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of privacy mismatch: %s != %s.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid),
 				priv->capability & CAP_PRIVACY_ON ? "on" :
 				"off",
@@ -5751,7 +5770,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	    memcmp(network->bssid, priv->bssid, ETH_ALEN)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of BSSID mismatch: %s.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid), print_mac(mac, priv->bssid));
 		return 0;
 	}
@@ -5761,7 +5781,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of invalid frequency/mode "
 				"combination.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5770,7 +5791,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (!ieee80211_is_valid_channel(priv->ieee, network->channel)) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of invalid channel in current GEO\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5781,7 +5803,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because configured rate mask excludes "
 				"AP mandatory rate.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5789,7 +5812,8 @@ static int ipw_best_network(struct ipw_priv *priv,
 	if (rates.num_rates == 0) {
 		IPW_DEBUG_ASSOC("Network '%s (%s)' excluded "
 				"because of no compatible rates.\n",
-				escape_ssid(network->ssid, network->ssid_len),
+				print_ssid(ssid, network->ssid,
+					   network->ssid_len),
 				print_mac(mac, network->bssid));
 		return 0;
 	}
@@ -5803,7 +5827,7 @@ static int ipw_best_network(struct ipw_priv *priv,
 	match->network = network;
 
 	IPW_DEBUG_ASSOC("Network '%s (%s)' is a viable match.\n",
-			escape_ssid(network->ssid, network->ssid_len),
+			print_ssid(ssid, network->ssid, network->ssid_len),
 			print_mac(mac, network->bssid));
 
 	return 1;
@@ -6047,6 +6071,7 @@ static void ipw_bg_adhoc_check(struct work_struct *work)
 static void ipw_debug_config(struct ipw_priv *priv)
 {
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 	IPW_DEBUG_INFO("Scan completed, no valid APs matched "
 		       "[CFG 0x%08X]\n", priv->config);
 	if (priv->config & CFG_STATIC_CHANNEL)
@@ -6055,7 +6080,7 @@ static void ipw_debug_config(struct ipw_priv *priv)
 		IPW_DEBUG_INFO("Channel unlocked.\n");
 	if (priv->config & CFG_STATIC_ESSID)
 		IPW_DEBUG_INFO("ESSID locked to '%s'\n",
-			       escape_ssid(priv->essid, priv->essid_len));
+			       print_ssid(ssid, priv->essid, priv->essid_len));
 	else
 		IPW_DEBUG_INFO("ESSID unlocked.\n");
 	if (priv->config & CFG_STATIC_BSSID)
@@ -7275,6 +7300,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 {
 	int err;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	if (priv->config & CFG_FIXED_RATE)
 		ipw_set_fixed_rate(priv, network->mode);
@@ -7343,7 +7369,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 	IPW_DEBUG_ASSOC("%sssocation attempt: '%s', channel %d, "
 			"802.11%c [%d], %s[:%s], enc=%s%s%s%c%c\n",
 			roaming ? "Rea" : "A",
-			escape_ssid(priv->essid, priv->essid_len),
+			print_ssid(ssid, priv->essid, priv->essid_len),
 			network->channel,
 			ipw_modes[priv->assoc_request.ieee_mode],
 			rates->num_rates,
@@ -7443,7 +7469,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 	}
 
 	IPW_DEBUG(IPW_DL_STATE, "associating: '%s' %s \n",
-		  escape_ssid(priv->essid, priv->essid_len),
+		  print_ssid(ssid, priv->essid, priv->essid_len),
 		  print_mac(mac, priv->bssid));
 
 	return 0;
@@ -7534,6 +7560,7 @@ static int ipw_associate(void *data)
 	struct ipw_supported_rates *rates;
 	struct list_head *element;
 	unsigned long flags;
+	DECLARE_SSID_BUF(ssid);
 
 	if (priv->ieee->iw_mode == IW_MODE_MONITOR) {
 		IPW_DEBUG_ASSOC("Not attempting association (monitor mode)\n");
@@ -7596,8 +7623,8 @@ static int ipw_associate(void *data)
 			target = oldest;
 			IPW_DEBUG_ASSOC("Expired '%s' (%s) from "
 					"network list.\n",
-					escape_ssid(target->ssid,
-						    target->ssid_len),
+					print_ssid(ssid, target->ssid,
+						   target->ssid_len),
 					print_mac(mac, target->bssid));
 			list_add_tail(&target->list,
 				      &priv->ieee->network_free_list);
@@ -9036,6 +9063,7 @@ static int ipw_wx_set_essid(struct net_device *dev,
 {
 	struct ipw_priv *priv = ieee80211_priv(dev);
         int length;
+	DECLARE_SSID_BUF(ssid);
 
         mutex_lock(&priv->mutex);
 
@@ -9060,8 +9088,8 @@ static int ipw_wx_set_essid(struct net_device *dev,
 		return 0;
 	}
 
-	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n", escape_ssid(extra, length),
-		     length);
+	IPW_DEBUG_WX("Setting ESSID: '%s' (%d)\n",
+		     print_ssid(ssid, extra, length), length);
 
 	priv->essid_len = length;
 	memcpy(priv->essid, extra, priv->essid_len);
@@ -9080,6 +9108,7 @@ static int ipw_wx_get_essid(struct net_device *dev,
 			    union iwreq_data *wrqu, char *extra)
 {
 	struct ipw_priv *priv = ieee80211_priv(dev);
+	DECLARE_SSID_BUF(ssid);
 
 	/* If we are associated, trying to associate, or have a statically
 	 * configured ESSID then return that; otherwise return ANY */
@@ -9087,7 +9116,7 @@ static int ipw_wx_get_essid(struct net_device *dev,
 	if (priv->config & CFG_STATIC_ESSID ||
 	    priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)) {
 		IPW_DEBUG_WX("Getting essid: '%s'\n",
-			     escape_ssid(priv->essid, priv->essid_len));
+			     print_ssid(ssid, priv->essid, priv->essid_len));
 		memcpy(extra, priv->essid, priv->essid_len);
 		wrqu->essid.length = priv->essid_len;
 		wrqu->essid.flags = 1;	/* active */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 9488e50..a41b5f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -663,6 +663,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	enum ieee80211_band band;
 	u8 n_probes = 2;
 	u8 rx_chain = 0x7; /* bitmap: ABC chains */
+	DECLARE_SSID_BUF(ssid);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -755,8 +756,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	/* We should add the ability for user to lock to PASSIVE ONLY */
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s'\n",
-				escape_ssid(priv->direct_ssid,
-					    priv->direct_ssid_len));
+				print_ssid(ssid, priv->direct_ssid,
+					   priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
@@ -764,7 +765,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		n_probes++;
 	} else if (!iwl_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
-				escape_ssid(priv->essid, priv->essid_len));
+				print_ssid(ssid, priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c81b743..764296c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6063,6 +6063,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	struct ieee80211_conf *conf = NULL;
 	u8 n_probes = 2;
 	enum ieee80211_band band;
+	DECLARE_SSID_BUF(ssid);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -6163,7 +6164,8 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN
 		    ("Kicking off one direct scan for '%s'\n",
-		     escape_ssid(priv->direct_ssid, priv->direct_ssid_len));
+		     print_ssid(ssid, priv->direct_ssid,
+				priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
@@ -6172,7 +6174,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	} else if (!iwl3945_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN
 		  ("Kicking off one direct scan for '%s' when not associated\n",
-		   escape_ssid(priv->essid, priv->essid_len));
+		   print_ssid(ssid, priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
@@ -6958,6 +6960,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	int rc = 0;
 	unsigned long flags;
 	struct iwl3945_priv *priv = hw->priv;
+	DECLARE_SSID_BUF(ssid_buf);
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -6991,7 +6994,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	}
 	if (len) {
 		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
-			       escape_ssid(ssid, len), (int)len);
+			       print_ssid(ssid_buf, ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len = (u8)
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 693d786..6cb13ad 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -154,17 +154,18 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 	struct bss_descriptor *bss = &assoc_req->bss;
 	u8 preamble = RADIO_PREAMBLE_LONG;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 	u16 ratesize = 0;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	lbs_deb_join("current SSID '%s', ssid length %u\n",
-		escape_ssid(priv->curbssparams.ssid,
+		print_ssid(ssid, priv->curbssparams.ssid,
 		priv->curbssparams.ssid_len),
 		priv->curbssparams.ssid_len);
 	lbs_deb_join("requested ssid '%s', ssid length %u\n",
-		escape_ssid(bss->ssid, bss->ssid_len),
+		print_ssid(ssid, bss->ssid, bss->ssid_len),
 		bss->ssid_len);
 
 	/* check if the requested SSID is already joined */
@@ -309,6 +310,7 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 	size_t ratesize = 0;
 	u16 tmpcap = 0;
 	int ret = 0;
+	DECLARE_SSID_BUF(ssid);
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
@@ -328,7 +330,7 @@ static int lbs_adhoc_start(struct lbs_private *priv,
 	memcpy(cmd.ssid, assoc_req->ssid, assoc_req->ssid_len);
 
 	lbs_deb_join("ADHOC_START: SSID '%s', ssid length %u\n",
-		escape_ssid(assoc_req->ssid, assoc_req->ssid_len),
+		print_ssid(ssid, assoc_req->ssid, assoc_req->ssid_len),
 		assoc_req->ssid_len);
 
 	cmd.bsstype = CMD_BSS_TYPE_IBSS;
@@ -696,6 +698,7 @@ static int assoc_helper_essid(struct lbs_private *priv,
 	int ret = 0;
 	struct bss_descriptor * bss;
 	int channel = -1;
+	DECLARE_SSID_BUF(ssid);
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
@@ -707,7 +710,7 @@ static int assoc_helper_essid(struct lbs_private *priv,
 		channel = assoc_req->channel;
 
 	lbs_deb_assoc("SSID '%s' requested\n",
-	              escape_ssid(assoc_req->ssid, assoc_req->ssid_len));
+	              print_ssid(ssid, assoc_req->ssid, assoc_req->ssid_len));
 	if (assoc_req->mode == IW_MODE_INFRA) {
 		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
 			assoc_req->ssid_len);
@@ -1211,6 +1214,7 @@ void lbs_association_worker(struct work_struct *work)
 	int ret = 0;
 	int find_any_ssid = 0;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
@@ -1234,7 +1238,7 @@ void lbs_association_worker(struct work_struct *work)
 		"    secinfo:  %s%s%s\n"
 		"    auth_mode: %d\n",
 		assoc_req->flags,
-		escape_ssid(assoc_req->ssid, assoc_req->ssid_len),
+		print_ssid(ssid, assoc_req->ssid, assoc_req->ssid_len),
 		assoc_req->channel, assoc_req->band, assoc_req->mode,
 		print_mac(mac, assoc_req->bssid),
 		assoc_req->secinfo.WPAenabled ? " WPA" : "",
@@ -1773,6 +1777,7 @@ static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp)
 	union iwreq_data wrqu;
 	struct bss_descriptor *bss;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	lbs_deb_enter(LBS_DEB_JOIN);
 
@@ -1822,7 +1827,7 @@ static int lbs_adhoc_post(struct lbs_private *priv, struct cmd_header *resp)
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
 	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %s, channel %d\n",
-		     escape_ssid(bss->ssid, bss->ssid_len),
+		     print_ssid(ssid, bss->ssid, bss->ssid_len),
 		     print_mac(mac, priv->curbssparams.bssid),
 		     priv->curbssparams.channel);
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index c1048fd..fd75326 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1062,6 +1062,7 @@ int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_meshie *ie;
+	DECLARE_SSID_BUF(ssid);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.channel = cpu_to_le16(chan);
@@ -1092,7 +1093,7 @@ int lbs_mesh_config(struct lbs_private *priv, uint16_t action, uint16_t chan)
 	}
 	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
 		    action, priv->mesh_tlv, chan,
-		    escape_ssid(priv->mesh_ssid, priv->mesh_ssid_len));
+		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
 
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 89f5d62..de3c6ed 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -67,6 +67,7 @@ static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 	struct bss_descriptor * iter_bss;
 
 	pos += snprintf(buf+pos, len-pos,
@@ -88,7 +89,8 @@ static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 				spectrum_mgmt ? 'S' : ' ');
 		pos += snprintf(buf+pos, len-pos, " %04d |", SCAN_RSSI(iter_bss->rssi));
 		pos += snprintf(buf+pos, len-pos, " %s\n",
-		                escape_ssid(iter_bss->ssid, iter_bss->ssid_len));
+		                print_ssid(ssid, iter_bss->ssid,
+					   iter_bss->ssid_len));
 
 		numscansdone++;
 	}
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index fd0f640..5b3b252 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -363,6 +363,7 @@ int lbs_scan_networks(struct lbs_private *priv, int full_scan)
 	struct bss_descriptor *iter;
 	int i = 0;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 #endif
 
 	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d", full_scan);
@@ -456,7 +457,7 @@ int lbs_scan_networks(struct lbs_private *priv, int full_scan)
 	list_for_each_entry(iter, &priv->network_list, list)
 		lbs_deb_scan("%02d: BSSID %s, RSSI %d, SSID '%s'\n",
 			     i++, print_mac(mac, iter->bssid), iter->rssi,
-			     escape_ssid(iter->ssid, iter->ssid_len));
+			     print_ssid(ssid, iter->ssid, iter->ssid_len));
 	mutex_unlock(&priv->lock);
 #endif
 
@@ -516,6 +517,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 	struct ieeetypes_cfparamset *pCF;
 	struct ieeetypes_ibssparamset *pibss;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 	struct ieeetypes_countryinfoset *pcountryinfo;
 	uint8_t *pos, *end, *p;
 	uint8_t n_ex_rates = 0, got_basic_rates = 0, n_basic_rates = 0;
@@ -604,7 +606,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 			bss->ssid_len = elem->len;
 			memcpy(bss->ssid, elem->data, elem->len);
 			lbs_deb_scan("got SSID IE: '%s', len %u\n",
-			             escape_ssid(bss->ssid, bss->ssid_len),
+			             print_ssid(ssid, bss->ssid, bss->ssid_len),
 			             bss->ssid_len);
 			break;
 
@@ -744,10 +746,11 @@ done:
 int lbs_send_specific_ssid_scan(struct lbs_private *priv, uint8_t *ssid,
 				uint8_t ssid_len)
 {
+	DECLARE_SSID_BUF(ssid_buf);
 	int ret = 0;
 
 	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s'\n",
-			   escape_ssid(ssid, ssid_len));
+			   print_ssid(ssid_buf, ssid, ssid_len));
 
 	if (!ssid_len)
 		goto out;
@@ -942,6 +945,7 @@ out:
 int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 		 union iwreq_data *wrqu, char *extra)
 {
+	DECLARE_SSID_BUF(ssid);
 	struct lbs_private *priv = dev->priv;
 	int ret = 0;
 
@@ -971,7 +975,7 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 		priv->scan_ssid_len = req->essid_len;
 		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
 		lbs_deb_wext("set_scan, essid '%s'\n",
-			escape_ssid(priv->scan_ssid, priv->scan_ssid_len));
+			print_ssid(ssid, priv->scan_ssid, priv->scan_ssid_len));
 	} else {
 		priv->scan_ssid_len = 0;
 	}
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 12baf0d..5f18bf8 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1978,6 +1978,7 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 	u8 ssid_len = 0;
 	struct assoc_request * assoc_req;
 	int in_ssid_len = dwrq->length;
+	DECLARE_SSID_BUF(ssid_buf);
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -2006,7 +2007,7 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 		lbs_deb_wext("requested any SSID\n");
 	} else {
 		lbs_deb_wext("requested SSID '%s'\n",
-		             escape_ssid(ssid, ssid_len));
+		             print_ssid(ssid_buf, ssid, ssid_len));
 	}
 
 out:
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 14126bc..58e9fa1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -12,8 +12,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef IEEE80211_H
-#define IEEE80211_H
+#ifndef LINUX_IEEE80211_H
+#define LINUX_IEEE80211_H
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
@@ -1057,4 +1057,4 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 		return hdr->addr1;
 }
 
-#endif /* IEEE80211_H */
+#endif /* LINUX_IEEE80211_H */
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index ce49a30..d5f4e60 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -8,8 +8,9 @@
 #ifndef LIB80211_H
 #define LIB80211_H
 
-/* escape_ssid() is intended to be used in debug (and possibly error)
+/* print_ssid() is intended to be used in debug (and possibly error)
  * messages. It should never be used for passing ssid to user space. */
-const char *escape_ssid(const char *ssid, u8 ssid_len);
+const char *print_ssid(char *buf, const char *ssid, u8 ssid_len);
+#define DECLARE_SSID_BUF(var) char var[32 * 4 + 1]
 
 #endif /* LIB80211_H */
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 15c65da..cf72ae4 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -1145,6 +1145,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				      *info_element, u16 length,
 				      struct ieee80211_network *network)
 {
+	DECLARE_SSID_BUF(ssid);
 	u8 i;
 #ifdef CONFIG_IEEE80211_DEBUG
 	char rates_str[64];
@@ -1176,7 +1177,8 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 				       IW_ESSID_MAX_SIZE - network->ssid_len);
 
 			IEEE80211_DEBUG_MGMT("MFIE_TYPE_SSID: '%s' len=%d.\n",
-					     escape_ssid(network->ssid),
+					     print_ssid(ssid, network->ssid,
+							network->ssid_len);
 					     network->ssid_len);
 			break;
 
@@ -1423,6 +1425,7 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 					 struct ieee80211_rx_stats *stats)
 {
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	network->qos_data.active = 0;
 	network->qos_data.supported = 0;
@@ -1472,7 +1475,7 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 	if (network->mode == 0) {
 		IEEE80211_DEBUG_SCAN("Filtered out '%s (%s)' "
 				     "network.\n",
-				     escape_ssid(network->ssid,
+				     print_ssid(ssid, network->ssid,
 						 network->ssid_len),
 				     print_mac(mac, network->bssid));
 		return 1;
@@ -1588,10 +1591,11 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 #endif
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	IEEE80211_DEBUG_SCAN("'%s' (%s"
 		     "): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
-		     escape_ssid(info_element->data, info_element->len),
+		     print_ssid(ssid, info_element->data, info_element->len),
 		     print_mac(mac, beacon->header.addr3),
 		     (beacon->capability & cpu_to_le16(1 << 0xf)) ? '1' : '0',
 		     (beacon->capability & cpu_to_le16(1 << 0xe)) ? '1' : '0',
@@ -1612,7 +1616,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 
 	if (ieee80211_network_init(ieee, beacon, &network, stats)) {
 		IEEE80211_DEBUG_SCAN("Dropped '%s' (%s) via %s.\n",
-				     escape_ssid(info_element->data,
+				     print_ssid(ssid, info_element->data,
 						 info_element->len),
 				     print_mac(mac, beacon->header.addr3),
 				     is_beacon(beacon->header.frame_ctl) ?
@@ -1650,7 +1654,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 			target = oldest;
 			IEEE80211_DEBUG_SCAN("Expired '%s' (%s) from "
 					     "network list.\n",
-					     escape_ssid(target->ssid,
+					     print_ssid(ssid, target->ssid,
 							 target->ssid_len),
 					     print_mac(mac, target->bssid));
 			ieee80211_network_reset(target);
@@ -1663,7 +1667,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 
 #ifdef CONFIG_IEEE80211_DEBUG
 		IEEE80211_DEBUG_SCAN("Adding '%s' (%s) via %s.\n",
-				     escape_ssid(network.ssid,
+				     print_ssid(ssid, network.ssid,
 						 network.ssid_len),
 				     print_mac(mac, network.bssid),
 				     is_beacon(beacon->header.frame_ctl) ?
@@ -1674,7 +1678,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 		list_add_tail(&target->list, &ieee->network_list);
 	} else {
 		IEEE80211_DEBUG_SCAN("Updating '%s' (%s) via %s.\n",
-				     escape_ssid(target->ssid,
+				     print_ssid(ssid, target->ssid,
 						 target->ssid_len),
 				     print_mac(mac, target->bssid),
 				     is_beacon(beacon->header.frame_ctl) ?
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index db79e6c..698a856 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <linux/wireless.h>
 
@@ -259,6 +260,7 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 	char *stop = ev + wrqu->data.length;
 	int i = 0;
 	DECLARE_MAC_BUF(mac);
+	DECLARE_SSID_BUF(ssid);
 
 	IEEE80211_DEBUG_WX("Getting scan\n");
 
@@ -278,7 +280,7 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 		else
 			IEEE80211_DEBUG_SCAN("Not showing network '%s ("
 					     "%s)' due to age (%dms).\n",
-					     escape_ssid(network->ssid,
+					     print_ssid(ssid, network->ssid,
 							 network->ssid_len),
 					     print_mac(mac, network->bssid),
 					     jiffies_to_msecs(jiffies -
@@ -403,7 +405,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 			memset(sec.keys[key] + erq->length, 0,
 			       len - erq->length);
 		IEEE80211_DEBUG_WX("Setting key %d to '%s' (%d:%d bytes)\n",
-				   key, escape_ssid(sec.keys[key], len),
+				   key, print_ssid(ssid, sec.keys[key], len),
 				   erq->length, len);
 		sec.key_sizes[key] = len;
 		if (*crypt)
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index b8e34d3..e71f7d0 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -19,11 +19,10 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR("John W. Linville <linville@tuxdriver.com>");
 MODULE_LICENSE("GPL");
 
-const char *escape_ssid(const char *ssid, u8 ssid_len)
+const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
 {
-	static char escaped[IEEE80211_MAX_SSID_LEN * 4 + 1];
 	const char *s = ssid;
-	char *d = escaped;
+	char *d = buf;
 
 	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
 	while (ssid_len--) {
@@ -48,9 +47,9 @@ const char *escape_ssid(const char *ssid, u8 ssid_len)
 		s++;
 	}
 	*d = '\0';
-	return escaped;
+	return buf;
 }
-EXPORT_SYMBOL(escape_ssid);
+EXPORT_SYMBOL(print_ssid);
 
 static int __init ieee80211_init(void)
 {
-- 
1.5.4.3

