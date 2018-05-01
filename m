Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33883 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbeEAWqe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 18:46:34 -0400
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
Subject: [RFC PATCH 1/3] rtlwifi: btcoex: Don't init antenna position to main port
Date: Tue,  1 May 2018 15:46:11 -0700
Message-Id: <20180501224613.32460-1-jprvita@endlessm.com> (sfid-20180502_004814_226358_2877E319)
In-Reply-To: <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
References: <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This partially reverts commit 40d9dd4f1c5dcd0d4a2a1f0efcd225c9c4b36d6f,
which does not only remove global variables from btcoex, as described on
its commit message, but also does a few other things -- in particular,
setting the default antenna position to BTC_ANTENNA_AT_MAIN_PORT.

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
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index b026e80940a4..86182b917c92 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1388,9 +1388,6 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
 	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
 	exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
 
-	/* set default antenna position to main  port */
-	btcoexist->board_info.btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
-
 	single_ant_path = rtl_get_hwpg_single_ant_path(rtlpriv);
 	exhalbtc_set_single_ant_path(btcoexist, single_ant_path);
 
-- 
2.17.0
