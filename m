Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:26183 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaD1OD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 10:03:56 -0400
Message-ID: <535EAD21.5090808@redpinesignals.com> (sfid-20140428_160359_676329_D5DED46B)
Date: Tue, 29 Apr 2014 01:03:53 +0530
From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] rsi: Changing opcode for sta mode according to changes
 in firmware
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

rsi_91x_mgmt.c |    4 ++--
rsi_mgmt.h     |    1 +
2 files changed, 3 insertions(+), 2 deletions(-)

diff -uprN a/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_91x_mgmt.c
--- a/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-04-28 08:14:27.000000000 +0545
+++ b/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-04-29 13:22:35.540968735 +0545
@@ -1083,7 +1083,7 @@ void rsi_inform_bss_status(struct rsi_co
 {
 	if (status) {
 		rsi_hal_send_sta_notify_frame(common,
-					      NL80211_IFTYPE_STATION,
+					      RSI_IFTYPE_STATION,
 					      STA_CONNECTED,
 					      bssid,
 					      qos_enable,
@@ -1092,7 +1092,7 @@ void rsi_inform_bss_status(struct rsi_co
 			rsi_send_auto_rate_request(common);
 	} else {
 		rsi_hal_send_sta_notify_frame(common,
-					      NL80211_IFTYPE_STATION,
+					      RSI_IFTYPE_STATION,
 					      STA_DISCONNECTED,
 					      bssid,
 					      qos_enable,
diff -uprN a/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_mgmt.h b/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_mgmt.h
--- a/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_mgmt.h	2014-04-28 08:14:27.000000000 +0545
+++ b/linux-3.15-rc3/drivers/net/wireless/rsi/rsi_mgmt.h	2014-04-29 13:21:27.252822454 +0545
@@ -73,6 +73,7 @@
 #define RX_BA_INDICATION                1
 #define RSI_TBL_SZ                      40
 #define MAX_RETRIES                     8
+#define RSI_IFTYPE_STATION		 0
 
 #define STD_RATE_MCS7                   0x07
 #define STD_RATE_MCS6                   0x06






