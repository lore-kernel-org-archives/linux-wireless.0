Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3781 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2FRLBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 07:01:12 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <jouni@qca.qualcomm.com>, <johannes@sipsolutions.net>,
	<kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wpa_supplicant: Add support for auto channel selection in AP mode
Date: Mon, 18 Jun 2012 16:30:41 +0530
Message-ID: <1340017242-6436-2-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120618_130129_484689_19A79534)
In-Reply-To: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If conf parameter 'auto_chan_select' is enabled for AP mode, send 
NL80211_ATTR_ACS attribute to cfg80211.
The new channel information is received from cfg80211 through
CH_SWITCH event.

Signed-hostap: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
v2: Add a new flag attribute for _START_AP command to indicate ACS request.
    Update the channel/frequency information within hostapd/wpa_supplicant
    once the driver (firmware) has selected the channel.(This is addressed by
    Thomas' patch, 'nl80211: handle CH_SWITCH event')

 src/ap/ap_config.h           |    1 +
 src/ap/beacon.c              |    1 +
 src/ap/hw_features.c         |    2 +-
 src/drivers/driver.h         |    5 +++++
 src/drivers/driver_nl80211.c |    5 ++++-
 wpa_supplicant/ap.c          |   20 ++++++++++++++++----
 wpa_supplicant/config.c      |    1 +
 wpa_supplicant/config_ssid.h |    8 ++++++++
 8 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index 78c9068..54759bb 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -407,6 +407,7 @@ struct hostapd_config {
 	int fragm_threshold;
 	u8 send_probe_response;
 	u8 channel;
+	int acs;
 	enum hostapd_hw_mode hw_mode; /* HOSTAPD_MODE_IEEE80211A, .. */
 	enum {
 		LONG_PREAMBLE = 0,
diff --git a/src/ap/beacon.c b/src/ap/beacon.c
index b711063..037f172 100644
--- a/src/ap/beacon.c
+++ b/src/ap/beacon.c
@@ -634,6 +634,7 @@ void ieee802_11_set_beacon(struct hostapd_data *hapd)
 	params.dtim_period = hapd->conf->dtim_period;
 	params.beacon_int = hapd->iconf->beacon_int;
 	params.basic_rates = hapd->iconf->basic_rates;
+	params.auto_chan_select = hapd->iconf->acs;
 	params.ssid = (u8 *) hapd->conf->ssid.ssid;
 	params.ssid_len = hapd->conf->ssid.ssid_len;
 	params.pairwise_ciphers = hapd->conf->rsn_pairwise ?
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index 76c4211..f33b7fd 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -715,7 +715,7 @@ int hostapd_select_hw_mode(struct hostapd_iface *iface)
 			ok = 0;
 		}
 	}
-	if (iface->conf->channel == 0) {
+	if (iface->conf->channel == 0 && iface->conf->acs == 0) {
 		/* TODO: could request a scan of neighboring BSSes and select
 		 * the channel automatically */
 		wpa_printf(MSG_ERROR, "Channel not configured "
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index f7fb2ef..053ccd0 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -577,6 +577,11 @@ struct wpa_driver_ap_params {
 	int beacon_int;
 
 	/**
+	 * auto_chan_select - Automatic channel selection
+	 */
+	int auto_chan_select;
+
+	/**
 	 * basic_rates: -1 terminated array of basic rates in 100 kbps
 	 *
 	 * This parameter can be used to set a specific basic rate set for the
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 693a885..d4293fd 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -5330,6 +5330,8 @@ static int wpa_driver_nl80211_set_ap(void *priv,
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, ifindex);
 	NLA_PUT_U32(msg, NL80211_ATTR_BEACON_INTERVAL, params->beacon_int);
 	NLA_PUT_U32(msg, NL80211_ATTR_DTIM_PERIOD, params->dtim_period);
+	if (params->auto_chan_select)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_ACS);
 	NLA_PUT(msg, NL80211_ATTR_SSID, params->ssid_len,
 		params->ssid);
 	if (params->proberesp && params->proberesp_len)
@@ -6388,7 +6390,8 @@ static int wpa_driver_nl80211_ap(struct wpa_driver_nl80211_data *drv,
 		nlmode = NL80211_IFTYPE_AP;
 
 	if (wpa_driver_nl80211_set_mode(&drv->first_bss, nlmode) ||
-	    wpa_driver_nl80211_set_freq(&drv->first_bss, params->freq, 0, 0)) {
+	    ((params->freq) &&
+	    wpa_driver_nl80211_set_freq(&drv->first_bss, params->freq, 0, 0))) {
 		nl80211_remove_monitor_interface(drv);
 		return -1;
 	}
diff --git a/wpa_supplicant/ap.c b/wpa_supplicant/ap.c
index d531583..87bc9b8 100644
--- a/wpa_supplicant/ap.c
+++ b/wpa_supplicant/ap.c
@@ -52,10 +52,22 @@ static int wpa_supplicant_conf_ap(struct wpa_supplicant *wpa_s,
 
 	os_strlcpy(bss->iface, wpa_s->ifname, sizeof(bss->iface));
 
-	if (ssid->frequency == 0) {
-		/* default channel 11 */
-		conf->hw_mode = HOSTAPD_MODE_IEEE80211G;
-		conf->channel = 11;
+	if (ssid->auto_chan_select) {
+		if (ssid->frequency == 0)
+			wpa_printf(MSG_INFO, "Automatic channel "
+				   "selection is enabled");
+		else {
+			wpa_printf(MSG_INFO, "Automatic channel "
+				   "selection is enabled. Override "
+				   "frequency configuration");
+			ssid->frequency = 0;
+		}
+
+		conf->acs = ssid->auto_chan_select;
+	} else if (ssid->frequency == 0) {
+			/* default channel 11 */
+			conf->hw_mode = HOSTAPD_MODE_IEEE80211G;
+			conf->channel = 8;
 	} else if (ssid->frequency >= 2412 && ssid->frequency <= 2472) {
 		conf->hw_mode = HOSTAPD_MODE_IEEE80211G;
 		conf->channel = (ssid->frequency - 2407) / 5;
diff --git a/wpa_supplicant/config.c b/wpa_supplicant/config.c
index ce763b3..7b85712 100644
--- a/wpa_supplicant/config.c
+++ b/wpa_supplicant/config.c
@@ -1598,6 +1598,7 @@ static const struct parse_data ssid_fields[] = {
 	{ INT(wpa_ptk_rekey) },
 	{ STR(bgscan) },
 	{ INT_RANGE(ignore_broadcast_ssid, 0, 2) },
+	{ INT_RANGE(auto_chan_select, 0, 1) },
 #ifdef CONFIG_P2P
 	{ FUNC(p2p_client_list) },
 #endif /* CONFIG_P2P */
diff --git a/wpa_supplicant/config_ssid.h b/wpa_supplicant/config_ssid.h
index 80d4382..88806fb 100644
--- a/wpa_supplicant/config_ssid.h
+++ b/wpa_supplicant/config_ssid.h
@@ -398,6 +398,14 @@ struct wpa_ssid {
 	int ignore_broadcast_ssid;
 
 	/**
+	 * auto_chan_select - Automatic channel selection in AP mode
+	 *
+	 * Optional parameter to enable channel selection by the driver if it
+	 * is capable of.
+	 */
+
+	int auto_chan_select;
+	/**
 	 * freq_list - Array of allowed frequencies or %NULL for all
 	 *
 	 * This is an optional zero-terminated array of frequencies in
-- 
1.7.4.1

