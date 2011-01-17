Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:12298 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1AQQUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:04 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 13:56:59 +0100
Subject: [PATCH 2/8] hostap: add channel_list config parameter
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.79817208F@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 hostapd/config_file.c |    7 +++++++
 src/ap/ap_config.c    |    1 +
 src/ap/ap_config.h    |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index f6b9926..119a4bb 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -1736,6 +1736,13 @@ struct hostapd_config * hostapd_config_read(const char *fname)
 			}
 		} else if (os_strcmp(buf, "channel") == 0) {
 			conf->channel = atoi(pos);
+		} else if (os_strcmp(buf, "channel_list") == 0) {
+			if (hostapd_parse_int_list(&conf->channel_list,
+						   pos)) {
+				wpa_printf(MSG_ERROR, "Line %d: invalid channel"
+					   " list", line);
+				errors++;
+			}
 		} else if (os_strcmp(buf, "beacon_int") == 0) {
 			int val = atoi(pos);
 			/* MIB defines range as 1..65535, but very small values
diff --git a/src/ap/ap_config.c b/src/ap/ap_config.c
index 702cb76..38e70fb 100644
--- a/src/ap/ap_config.c
+++ b/src/ap/ap_config.c
@@ -466,6 +466,7 @@ void hostapd_config_free(struct hostapd_config *conf)
 	os_free(conf->bss);
 	os_free(conf->supported_rates);
 	os_free(conf->basic_rates);
+	os_free(conf->channel_list);
 
 	os_free(conf);
 }
diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index 0a929d6..57c977d 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -340,6 +340,7 @@ struct hostapd_config {
 	int fragm_threshold;
 	u8 send_probe_response;
 	u8 channel;
+	int *channel_list;
 	enum hostapd_hw_mode hw_mode; /* HOSTAPD_MODE_IEEE80211A, .. */
 	enum {
 		LONG_PREAMBLE = 0,
-- 
1.5.6.5

