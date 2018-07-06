Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36987 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932498AbeGFFo5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 01:44:57 -0400
From: <pkshih@realtek.com>
To: <gregkh@linuxfoundation.org>
CC: <Larry.Finger@lwfinger.net>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <jian-hong@endlessm.com>
Subject: [PATCH] staging: r8822be: Fix RTL8822be can't find any wireless AP
Date: Fri, 6 Jul 2018 13:44:35 +0800
Message-ID: <20180706054435.3732-1-pkshih@realtek.com> (sfid-20180706_074511_535648_3102FDC7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

RTL8822be can't bring up properly on ASUS X530UN, and dmesg says:
[ 8.591333] r8822be: module is from the staging directory, the quality
is unknown, you have been warned.
[ 8.593122] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
[ 8.669163] r8822be: Using firmware rtlwifi/rtl8822befw.bin
[ 9.289939] r8822be: rtlwifi: wireless switch is on
[ 10.056426] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0
...
[ 11.952534] r8822be: halmac_init_hal failed
[ 11.955933] r8822be: halmac_init_hal failed
[ 11.956227] r8822be: halmac_init_hal failed
[ 22.007942] r8822be: halmac_init_hal failed

Jian-Hong reported it works if turn off ASPM with module parameter aspm=0.
In order to fix this problem kindly, this commit don't turn off aspm but
enlarge ASPM L1 latency to 7.

Reported-by: Jian-Hong Pan <jian-hong@endlessm.com>
Tested-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/staging/rtlwifi/rtl8822be/hw.c | 2 +-
 drivers/staging/rtlwifi/wifi.h         | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtlwifi/rtl8822be/hw.c b/drivers/staging/rtlwifi/rtl8822be/hw.c
index 7947edb239a1..88ba5b2fea6a 100644
--- a/drivers/staging/rtlwifi/rtl8822be/hw.c
+++ b/drivers/staging/rtlwifi/rtl8822be/hw.c
@@ -803,7 +803,7 @@ static void _rtl8822be_enable_aspm_back_door(struct ieee80211_hw *hw)
 		return;
 
 	pci_read_config_byte(rtlpci->pdev, 0x70f, &tmp);
-	pci_write_config_byte(rtlpci->pdev, 0x70f, tmp | BIT(7));
+	pci_write_config_byte(rtlpci->pdev, 0x70f, tmp | ASPM_L1_LATENCY << 3);
 
 	pci_read_config_byte(rtlpci->pdev, 0x719, &tmp);
 	pci_write_config_byte(rtlpci->pdev, 0x719, tmp | BIT(3) | BIT(4));
diff --git a/drivers/staging/rtlwifi/wifi.h b/drivers/staging/rtlwifi/wifi.h
index 012fb618840b..a45f0eb69d3f 100644
--- a/drivers/staging/rtlwifi/wifi.h
+++ b/drivers/staging/rtlwifi/wifi.h
@@ -88,6 +88,7 @@
 #define RTL_USB_MAX_RX_COUNT			100
 #define QBSS_LOAD_SIZE				5
 #define MAX_WMMELE_LENGTH			64
+#define ASPM_L1_LATENCY				7
 
 #define TOTAL_CAM_ENTRY				32
 
-- 
2.15.1
