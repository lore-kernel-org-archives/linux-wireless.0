Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39320 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbeEAWqf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 18:46:35 -0400
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
Subject: [RFC PATCH 2/3] Revert "rtlwifi: fill FW version and subversion"
Date: Tue,  1 May 2018 15:46:12 -0700
Message-Id: <20180501224613.32460-2-jprvita@endlessm.com> (sfid-20180502_004812_934384_5F660DBC)
In-Reply-To: <20180501224613.32460-1-jprvita@endlessm.com>
References: <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
 <20180501224613.32460-1-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 874e837d67d0db179c9771f38fd21df07c703e93.

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
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c         | 2 --
 drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index 63874512598b..a2eca669873b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -141,8 +141,6 @@ int rtl88e_download_fw(struct ieee80211_hw *hw,
 		return 1;
 
 	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
-	rtlhal->fw_version = le16_to_cpu(pfwheader->version);
-	rtlhal->fw_subversion = pfwheader->subversion;
 	pfwdata = rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index 521039c5d4ce..0d1ebc861720 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -200,8 +200,6 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 		return 1;
 
 	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
-	rtlhal->fw_version = le16_to_cpu(pfwheader->version);
-	rtlhal->fw_subversion = pfwheader->subversion;
 	pfwdata = rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
 
-- 
2.17.0
