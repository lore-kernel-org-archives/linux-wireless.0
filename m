Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31205 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2C3GYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 02:24:38 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH] wpa-supplicant: Send background scan period.
Date: Fri, 30 Mar 2012 11:54:29 +0530
Message-ID: <1333088669-2669-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120330_082500_984339_1CF4397A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send background scan period as part of connect and
associate command. Background scan will be
disabled if period value is zero.

This patch depends on below kernel patch
cfg80211: Add background scan period attribute.

Signed-hostap: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 src/drivers/driver.h            |    5 +++++
 src/drivers/driver_nl80211.c    |   13 +++++++++++++
 wpa_supplicant/config.c         |    2 ++
 wpa_supplicant/config_file.c    |    1 +
 wpa_supplicant/config_ssid.h    |    6 ++++++
 wpa_supplicant/sme.c            |    1 +
 wpa_supplicant/wpa_supplicant.c |    1 +
 7 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 04aedcf..ecd3d87 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -333,6 +333,11 @@ struct wpa_driver_associate_params {
 	int freq;
 
 	/**
+	 * bg_scan_period - Background scan period
+	 */
+	int bg_scan_period;
+
+	/**
 	 * wpa_ie - WPA information element for (Re)Association Request
 	 * WPA information element to be included in (Re)Association
 	 * Request (including information element id and length). Use
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 74865f3..ca96a73 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -6567,6 +6567,12 @@ static int wpa_driver_nl80211_connect(
 		wpa_printf(MSG_DEBUG, "  * freq=%d", params->freq);
 		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, params->freq);
 	}
+	if (params->bg_scan_period >= 0) {
+		wpa_printf(MSG_DEBUG, "  * bg scan period=%d",
+				params->bg_scan_period);
+		NLA_PUT_U16(msg, NL80211_ATTR_BG_SCAN_PERIOD,
+				params->bg_scan_period);
+	}
 	if (params->ssid) {
 		wpa_hexdump_ascii(MSG_DEBUG, "  * SSID",
 				  params->ssid, params->ssid_len);
@@ -6779,6 +6785,13 @@ static int wpa_driver_nl80211_associate(
 		NLA_PUT(msg, NL80211_ATTR_IE, params->wpa_ie_len,
 			params->wpa_ie);
 
+	if (params->bg_scan_period >= 0) {
+		wpa_printf(MSG_DEBUG, "  * bg scan period=%d",
+				params->bg_scan_period);
+		NLA_PUT_U16(msg, NL80211_ATTR_BG_SCAN_PERIOD,
+				params->bg_scan_period);
+	}
+
 	if (params->pairwise_suite != CIPHER_NONE) {
 		int cipher;
 
diff --git a/wpa_supplicant/config.c b/wpa_supplicant/config.c
index a90e9d3..c57c1b9 100644
--- a/wpa_supplicant/config.c
+++ b/wpa_supplicant/config.c
@@ -1524,6 +1524,7 @@ static const struct parse_data ssid_fields[] = {
 	{ FUNC_KEY(psk) },
 	{ FUNC(proto) },
 	{ FUNC(key_mgmt) },
+	{ INT(bg_scan_period) },
 	{ FUNC(pairwise) },
 	{ FUNC(group) },
 	{ FUNC(auth_alg) },
@@ -1975,6 +1976,7 @@ void wpa_config_set_network_defaults(struct wpa_ssid *ssid)
 	ssid->pairwise_cipher = DEFAULT_PAIRWISE;
 	ssid->group_cipher = DEFAULT_GROUP;
 	ssid->key_mgmt = DEFAULT_KEY_MGMT;
+	ssid->bg_scan_period = DEFAULT_BG_SCAN_PERIOD;
 #ifdef IEEE8021X_EAPOL
 	ssid->eapol_flags = DEFAULT_EAPOL_FLAGS;
 	ssid->eap_workaround = DEFAULT_EAP_WORKAROUND;
diff --git a/wpa_supplicant/config_file.c b/wpa_supplicant/config_file.c
index b3dd40e..40a70de 100644
--- a/wpa_supplicant/config_file.c
+++ b/wpa_supplicant/config_file.c
@@ -587,6 +587,7 @@ static void wpa_config_write_network(FILE *f, struct wpa_ssid *ssid)
 	write_psk(f, ssid);
 	write_proto(f, ssid);
 	write_key_mgmt(f, ssid);
+	INT(bg_scan_period);
 	write_pairwise(f, ssid);
 	write_group(f, ssid);
 	write_auth_alg(f, ssid);
diff --git a/wpa_supplicant/config_ssid.h b/wpa_supplicant/config_ssid.h
index f2bb597..3236091 100644
--- a/wpa_supplicant/config_ssid.h
+++ b/wpa_supplicant/config_ssid.h
@@ -25,6 +25,7 @@
 		       WPA_CIPHER_WEP104 | WPA_CIPHER_WEP40)
 #define DEFAULT_FRAGMENT_SIZE 1398
 
+#define DEFAULT_BG_SCAN_PERIOD -1
 #define DEFAULT_DISABLE_HT 0
 #define DEFAULT_DISABLE_HT40 0
 #define DEFAULT_DISABLE_MAX_AMSDU -1 /* no change */
@@ -157,6 +158,11 @@ struct wpa_ssid {
 	int key_mgmt;
 
 	/**
+	 * bg_scan_period - Background scan period
+	 */
+	int bg_scan_period;
+
+	/**
 	 * proto - Bitfield of allowed protocols, WPA_PROTO_*
 	 */
 	int proto;
diff --git a/wpa_supplicant/sme.c b/wpa_supplicant/sme.c
index 690f395..8e7ca04 100644
--- a/wpa_supplicant/sme.c
+++ b/wpa_supplicant/sme.c
@@ -371,6 +371,7 @@ void sme_associate(struct wpa_supplicant *wpa_s, enum wpas_mode mode,
 	params.ssid = wpa_s->sme.ssid;
 	params.ssid_len = wpa_s->sme.ssid_len;
 	params.freq = wpa_s->sme.freq;
+	params.bg_scan_period = wpa_s->current_ssid->bg_scan_period;
 	params.wpa_ie = wpa_s->sme.assoc_req_ie_len ?
 		wpa_s->sme.assoc_req_ie : NULL;
 	params.wpa_ie_len = wpa_s->sme.assoc_req_ie_len;
diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplicant.c
index 36074d5..71542f0 100644
--- a/wpa_supplicant/wpa_supplicant.c
+++ b/wpa_supplicant/wpa_supplicant.c
@@ -1355,6 +1355,7 @@ void wpa_supplicant_associate(struct wpa_supplicant *wpa_s,
 	params.wpa_proto = wpa_s->wpa_proto;
 	params.auth_alg = algs;
 	params.mode = ssid->mode;
+	params.bg_scan_period = ssid->bg_scan_period;
 	for (i = 0; i < NUM_WEP_KEYS; i++) {
 		if (ssid->wep_key_len[i])
 			params.wep_key[i] = ssid->wep_key[i];
-- 
1.7.4.1

