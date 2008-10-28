Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYJ1Shp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:37:45 -0400
Subject: [PATCH] mac80211: remove SSID driver code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:54:11 +0100
Message-Id: <1225216451.3598.34.camel@johannes.berg> (sfid-20081028_193748_601006_A8B32DB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the SSID from the driver API since now there is no
driver that requires knowing the SSID and I think it's
unlikely that any hardware design that does require the
SSID will play well with mac80211.

This also removes support for setting the SSID in master
mode which will require a patch to hostapd to not try.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 -------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 -------
 include/net/mac80211.h                      |    6 +-----
 net/mac80211/ieee80211_i.h                  |    3 ---
 net/mac80211/main.c                         |   15 +++------------
 net/mac80211/mlme.c                         |   14 --------------
 net/mac80211/wext.c                         |   16 ----------------
 7 files changed, 4 insertions(+), 64 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-10-28 18:46:28.000000000 +0100
+++ everything/include/net/mac80211.h	2008-10-28 18:46:45.000000000 +0100
@@ -616,14 +616,12 @@ struct ieee80211_if_init_conf {
  * enum ieee80211_if_conf_change - interface config change flags
  *
  * @IEEE80211_IFCC_BSSID: The BSSID changed.
- * @IEEE80211_IFCC_SSID: The SSID changed.
  * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
  *	(currently AP and MESH only), use ieee80211_beacon_get().
  */
 enum ieee80211_if_conf_change {
 	IEEE80211_IFCC_BSSID	= BIT(0),
-	IEEE80211_IFCC_SSID	= BIT(1),
-	IEEE80211_IFCC_BEACON	= BIT(2),
+	IEEE80211_IFCC_BEACON	= BIT(1),
 };
 
 /**
@@ -643,8 +641,6 @@ enum ieee80211_if_conf_change {
 struct ieee80211_if_conf {
 	u32 changed;
 	u8 *bssid;
-	u8 *ssid;
-	size_t ssid_len;
 };
 
 /**
--- everything.orig/net/mac80211/main.c	2008-10-28 18:46:28.000000000 +0100
+++ everything/net/mac80211/main.c	2008-10-28 18:46:45.000000000 +0100
@@ -171,19 +171,13 @@ int ieee80211_if_config(struct ieee80211
 	conf.changed = changed;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		conf.bssid = sdata->u.sta.bssid;
-		conf.ssid = sdata->u.sta.ssid;
-		conf.ssid_len = sdata->u.sta.ssid_len;
-	} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
+	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		conf.bssid = sdata->dev->dev_addr;
-		conf.ssid = sdata->u.ap.ssid;
-		conf.ssid_len = sdata->u.ap.ssid_len;
-	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		u8 zero[ETH_ALEN] = { 0 };
 		conf.bssid = zero;
-		conf.ssid = zero;
-		conf.ssid_len = 0;
 	} else {
 		WARN_ON(1);
 		return -EINVAL;
@@ -192,9 +186,6 @@ int ieee80211_if_config(struct ieee80211
 	if (WARN_ON(!conf.bssid && (changed & IEEE80211_IFCC_BSSID)))
 		return -EINVAL;
 
-	if (WARN_ON(!conf.ssid && (changed & IEEE80211_IFCC_SSID)))
-		return -EINVAL;
-
 	return local->ops->config_interface(local_to_hw(local),
 					    &sdata->vif, &conf);
 }
--- everything.orig/net/mac80211/wext.c	2008-10-28 18:46:28.000000000 +0100
+++ everything/net/mac80211/wext.c	2008-10-28 18:46:45.000000000 +0100
@@ -407,13 +407,6 @@ static int ieee80211_ioctl_siwessid(stru
 		return 0;
 	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		memcpy(sdata->u.ap.ssid, ssid, len);
-		memset(sdata->u.ap.ssid + len, 0,
-		       IEEE80211_MAX_SSID_LEN - len);
-		sdata->u.ap.ssid_len = len;
-		return ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
-	}
 	return -EOPNOTSUPP;
 }
 
@@ -437,15 +430,6 @@ static int ieee80211_ioctl_giwessid(stru
 		return res;
 	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		len = sdata->u.ap.ssid_len;
-		if (len > IW_ESSID_MAX_SIZE)
-			len = IW_ESSID_MAX_SIZE;
-		memcpy(ssid, sdata->u.ap.ssid, len);
-		data->length = len;
-		data->flags = 1;
-		return 0;
-	}
 	return -EOPNOTSUPP;
 }
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:46:28.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:46:45.000000000 +0100
@@ -6744,13 +6744,6 @@ static int iwl3945_mac_config_interface(
 
 	/* XXX: this MUST use conf->mac_addr */
 
-	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
-	    (!conf->ssid_len)) {
-		IWL_DEBUG_MAC80211
-		    ("Leaving in AP mode because HostAPD is not ready.\n");
-		return 0;
-	}
-
 	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 
--- everything.orig/net/mac80211/ieee80211_i.h	2008-10-28 18:46:28.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-10-28 18:46:45.000000000 +0100
@@ -212,9 +212,6 @@ struct ieee80211_if_ap {
 
 	struct list_head vlans;
 
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	size_t ssid_len;
-
 	/* yes, this looks ugly, but guarantees that we can later use
 	 * bitmap_empty :)
 	 * NB: don't touch this bitmap, use sta_info_{set,clear}_tim_bit */
--- everything.orig/net/mac80211/mlme.c	2008-10-28 18:46:28.000000000 +0100
+++ everything/net/mac80211/mlme.c	2008-10-28 18:46:45.000000000 +0100
@@ -2460,7 +2460,6 @@ void ieee80211_sta_req_auth(struct ieee8
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
 {
 	struct ieee80211_if_sta *ifsta;
-	int res;
 
 	if (len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
@@ -2472,19 +2471,6 @@ int ieee80211_sta_set_ssid(struct ieee80
 		memcpy(ifsta->ssid, ssid, len);
 		ifsta->ssid_len = len;
 		ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-
-		res = 0;
-		/*
-		 * Hack! MLME code needs to be cleaned up to have different
-		 * entry points for configuration and internal selection change
-		 */
-		if (netif_running(sdata->dev))
-			res = ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
-		if (res) {
-			printk(KERN_DEBUG "%s: Failed to config new SSID to "
-			       "the low-level driver\n", sdata->dev->name);
-			return res;
-		}
 	}
 
 	if (len)
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-28 18:46:28.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-28 18:46:45.000000000 +0100
@@ -2965,13 +2965,6 @@ static int iwl4965_mac_config_interface(
 			return rc;
 	}
 
-	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
-	    (!conf->ssid_len)) {
-		IWL_DEBUG_MAC80211
-		    ("Leaving in AP mode because HostAPD is not ready.\n");
-		return 0;
-	}
-
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 


