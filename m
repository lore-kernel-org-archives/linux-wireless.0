Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35424 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbcL1Vkg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 16:40:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: Fix alignment issues
Date: Wed, 28 Dec 2016 15:40:04 -0600
Message-Id: <20161228214004.6309-1-Larry.Finger@lwfinger.net> (sfid-20161228_224040_711540_6B0AD1C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The addresses of Wlan NIC registers are natural alignment, but some
drivers have bugs. These are evident on platforms that need natural
alignment to access registers.  This change contains the following:
 1. Function _rtl8821ae_dbi_read() is used to read one byte from DBI,
    thus it should use rtl_read_byte().
 2. Register 0x4C7 of 8192ee is single byte.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
Kalle,

Please send this upstream when convenient. These fixes will improve operations
on architectures that are fussy about alignment.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c |    2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 99827d2..54ea173 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -1006,7 +1006,7 @@ static void _rtl92ee_hw_configure(struct ieee80211_hw *hw)
 	rtl_write_word(rtlpriv, REG_SIFS_TRX, 0x100a);
 
 	/* Note Data sheet don't define */
-	rtl_write_word(rtlpriv, 0x4C7, 0x80);
+	rtl_write_byte(rtlpriv, 0x4C7, 0x80);
 
 	rtl_write_byte(rtlpriv, REG_RX_PKT_LIMIT, 0x20);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 0b26bd0..e374320 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1124,7 +1124,7 @@ static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
 	}
 	if (0 == tmp) {
 		read_addr = REG_DBI_RDATA + addr % 4;
-		ret = rtl_read_word(rtlpriv, read_addr);
+		ret = rtl_read_byte(rtlpriv, read_addr);
 	}
 	return ret;
 }
-- 
1.7.9.5
