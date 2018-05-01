Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:43610 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbeEAWqh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 18:46:37 -0400
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Steve deRosier <derosier@gmail.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Drake <drake@endlessm.com>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        linux@endlessm.com
Subject: [RFC PATCH 3/3] rtlwifi: btcoex: Always use 2ant-functions for RTL8723BE
Date: Tue,  1 May 2018 15:46:13 -0700
Message-Id: <20180501224613.32460-3-jprvita@endlessm.com> (sfid-20180502_004813_666395_9FBCC914)
In-Reply-To: <20180501224613.32460-1-jprvita@endlessm.com>
References: <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
 <20180501224613.32460-1-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This partially reverts commit 7937f02d1953952a6eaf626b175ea9db5541e699,
which not only hooked external functions for newer ICs, as described in
its commit message, but also changed the behavior for RTL8723BE
depending on the value of board_info.btdm_ant_num.

When board_info.btdm_ant_num == 1, 7937f02d19 changes the codepath to
use a whole different set of functions ex_btc8723b1ant_*, instead of the
ex_btc8723b2ant_* that were used before it.

This drastically affects the upload performance and signal strenght on
the HP 240 G4 laptop, as shown by the results bellow:

Without this change:

 $ sudo iw dev wlp2s0 scan | grep -B3 JJ | grep signal
        signal: -42.00 dBm
 $ iperf3 -c 192.168.1.254
 Connecting to host 192.168.1.254, port 5201
 [  4] local 192.168.1.253 port 39678 connected to 192.168.1.254 port 5201
 [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
 [  4]   0.00-1.00   sec   735 KBytes  6.02 Mbits/sec    1   1.41 KBytes
 [  4]   1.00-2.00   sec   274 KBytes  2.25 Mbits/sec    1   1.41 KBytes
 [  4]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
 [  4]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
 [  4]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    1   28.3 KBytes
 [  4]   5.00-6.00   sec   423 KBytes  3.47 Mbits/sec    3   41.0 KBytes
 [  4]   6.00-7.00   sec   840 KBytes  6.88 Mbits/sec    0   58.0 KBytes
 [  4]   7.00-8.00   sec   830 KBytes  6.79 Mbits/sec    1   1.41 KBytes
 [  4]   8.00-9.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
 [  4]   9.00-10.00  sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
 - - - - - - - - - - - - - - - - - - - - - - - - -
 [ ID] Interval           Transfer     Bandwidth       Retr
 [  4]   0.00-10.00  sec  3.03 MBytes  2.54 Mbits/sec    7             sender
 [  4]   0.00-10.00  sec  2.88 MBytes  2.41 Mbits/sec                  receiver

 iperf Done.

With this change:

 $ sudo iw dev wlp2s0 scan | grep -B3 JJ | grep signal
        signal: -14.00 dBm
 $ iperf3 -c 192.168.1.254
 Connecting to host 192.168.1.254, port 5201
 [  4] local 192.168.1.253 port 59380 connected to 192.168.1.254 port 5201
 [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
 [  4]   0.00-1.00   sec  4.63 MBytes  38.8 Mbits/sec    0    194 KBytes
 [  4]   1.00-2.00   sec  4.58 MBytes  38.4 Mbits/sec    0    273 KBytes
 [  4]   2.00-3.00   sec  5.05 MBytes  42.3 Mbits/sec    0    332 KBytes
 [  4]   3.00-4.00   sec  4.98 MBytes  41.8 Mbits/sec    0    393 KBytes
 [  4]   4.00-5.00   sec  4.76 MBytes  39.9 Mbits/sec    0    434 KBytes
 [  4]   5.00-6.00   sec  4.85 MBytes  40.7 Mbits/sec    0    434 KBytes
 [  4]   6.00-7.00   sec  3.96 MBytes  33.2 Mbits/sec    0    464 KBytes
 [  4]   7.00-8.00   sec  4.74 MBytes  39.8 Mbits/sec    0    481 KBytes
 [  4]   8.00-9.00   sec  4.22 MBytes  35.4 Mbits/sec    0    508 KBytes
 [  4]   9.00-10.00  sec  4.09 MBytes  34.3 Mbits/sec    0    564 KBytes
 - - - - - - - - - - - - - - - - - - - - - - - - -
 [ ID] Interval           Transfer     Bandwidth       Retr
 [  4]   0.00-10.00  sec  45.9 MBytes  38.5 Mbits/sec    0             sender
 [  4]   0.00-10.00  sec  45.0 MBytes  37.7 Mbits/sec                  receiver

 iperf Done.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 62 ++++---------------
 1 file changed, 12 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 86182b917c92..a862b5efdf55 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1452,10 +1452,7 @@ void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_init_hwconfig(btcoexist, wifi_only);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_init_hwconfig(btcoexist);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_init_hwconfig(btcoexist, wifi_only);
+		ex_btc8723b2ant_init_hwconfig(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8723A(btcoexist->adapter)) {
 		/* 8723A has no this function */
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
@@ -1481,10 +1478,7 @@ void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_init_coex_dm(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_init_coex_dm(btcoexist);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_init_coex_dm(btcoexist);
+		ex_btc8723b2ant_init_coex_dm(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_init_coex_dm(btcoexist);
@@ -1516,10 +1510,7 @@ void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_ips_notify(btcoexist, ips_type);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_ips_notify(btcoexist, ips_type);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_ips_notify(btcoexist, ips_type);
+		ex_btc8723b2ant_ips_notify(btcoexist, ips_type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_ips_notify(btcoexist, ips_type);
@@ -1549,10 +1540,7 @@ void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_lps_notify(btcoexist, lps_type);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_lps_notify(btcoexist, lps_type);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_lps_notify(btcoexist, lps_type);
+		ex_btc8723b2ant_lps_notify(btcoexist, lps_type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_lps_notify(btcoexist, lps_type);
@@ -1582,10 +1570,7 @@ void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_scan_notify(btcoexist, scan_type);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_scan_notify(btcoexist, scan_type);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_scan_notify(btcoexist, scan_type);
+		ex_btc8723b2ant_scan_notify(btcoexist, scan_type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_scan_notify(btcoexist, scan_type);
@@ -1630,10 +1615,7 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_connect_notify(btcoexist, asso_type);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_connect_notify(btcoexist, asso_type);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_connect_notify(btcoexist, asso_type);
+		ex_btc8723b2ant_connect_notify(btcoexist, asso_type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_connect_notify(btcoexist, asso_type);
@@ -1666,10 +1648,7 @@ void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_media_status_notify(btcoexist, status);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_media_status_notify(btcoexist, status);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_media_status_notify(btcoexist, status);
+		ex_btc8723b2ant_media_status_notify(btcoexist, status);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_media_status_notify(btcoexist, status);
@@ -1709,12 +1688,8 @@ void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 			ex_btc8821a1ant_special_packet_notify(btcoexist,
 							      packet_type);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_special_packet_notify(btcoexist,
-							      packet_type);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_special_packet_notify(btcoexist,
-							      packet_type);
+		ex_btc8723b2ant_special_packet_notify(btcoexist,
+						      packet_type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_special_packet_notify(btcoexist,
@@ -1741,12 +1716,7 @@ void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 			ex_btc8821a1ant_bt_info_notify(btcoexist, tmp_buf,
 						       length);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_bt_info_notify(btcoexist, tmp_buf,
-						       length);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_bt_info_notify(btcoexist, tmp_buf,
-						       length);
+		ex_btc8723b2ant_bt_info_notify(btcoexist, tmp_buf, length);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_bt_info_notify(btcoexist, tmp_buf,
@@ -1763,8 +1733,6 @@ void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 
 	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_rf_status_notify(btcoexist, type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 	}
 }
@@ -1804,10 +1772,7 @@ void exhalbtc_halt_notify(struct btc_coexist *btcoexist)
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8821a1ant_halt_notify(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_halt_notify(btcoexist);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_halt_notify(btcoexist);
+		ex_btc8723b2ant_halt_notify(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_halt_notify(btcoexist);
@@ -1880,10 +1845,7 @@ void exhalbtc_periodical(struct btc_coexist *btcoexist)
 			if (!halbtc_under_ips(btcoexist))
 				ex_btc8821a1ant_periodical(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_periodical(btcoexist);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_periodical(btcoexist);
+		ex_btc8723b2ant_periodical(btcoexist);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_periodical(btcoexist);
-- 
2.17.0
