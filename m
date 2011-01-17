Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:51774 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab1AQQUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:04 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 13:55:23 +0100
Subject: [PATCH 1/8] hostap: make hostapd_parse_rates generic
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161327.7437B208D@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 hostapd/config_file.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index 4938611..f6b9926 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -646,14 +646,14 @@ static int hostapd_config_read_wep(struct hostapd_wep_keys *wep, int keyidx,
 }
 
 
-static int hostapd_parse_rates(int **rate_list, char *val)
+static int hostapd_parse_int_list(int **int_list, char *val)
 {
 	int *list;
 	int count;
 	char *pos, *end;
 
-	os_free(*rate_list);
-	*rate_list = NULL;
+	os_free(*int_list);
+	*int_list = NULL;
 
 	pos = val;
 	count = 0;
@@ -680,7 +680,7 @@ static int hostapd_parse_rates(int **rate_list, char *val)
 	}
 	list[count] = -1;
 
-	*rate_list = list;
+	*int_list = list;
 	return 0;
 }
 
@@ -1785,13 +1785,14 @@ struct hostapd_config * hostapd_config_read(const char *fname)
 			} else
 				conf->send_probe_response = val;
 		} else if (os_strcmp(buf, "supported_rates") == 0) {
-			if (hostapd_parse_rates(&conf->supported_rates, pos)) {
+			if (hostapd_parse_int_list(&conf->supported_rates,
+						   pos)) {
 				wpa_printf(MSG_ERROR, "Line %d: invalid rate "
 					   "list", line);
 				errors++;
 			}
 		} else if (os_strcmp(buf, "basic_rates") == 0) {
-			if (hostapd_parse_rates(&conf->basic_rates, pos)) {
+			if (hostapd_parse_int_list(&conf->basic_rates, pos)) {
 				wpa_printf(MSG_ERROR, "Line %d: invalid rate "
 					   "list", line);
 				errors++;
-- 
1.5.6.5

