Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34184 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753542AbdASUfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 15:35:10 -0500
Received: by mail-ot0-f193.google.com with SMTP id 73so5493289otj.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 12:34:23 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 2/3] rtlwifi: rtl8192cu: Calculate descriptor checksum correctly for BE
Date: Thu, 19 Jan 2017 14:28:07 -0600
Message-Id: <20170119202808.27752-3-Larry.Finger@lwfinger.net> (sfid-20170119_213543_561026_BD4836E0)
In-Reply-To: <20170119202808.27752-1-Larry.Finger@lwfinger.net>
References: <20170119202808.27752-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver requires a checksum for the descriptors so that the wifi
chip is assured that the USB transmission was correct. These entries
are little-endian, but the driver was always using cpu order in the
calculation. As a result, the driver failed on BE hardware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - No functional changes. Merge conflict resolved.
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 6da6e2a..1611e42 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -477,14 +477,14 @@ static void _rtl_fill_usb_tx_desc(u8 *txdesc)
  */
 static void _rtl_tx_desc_checksum(u8 *txdesc)
 {
-	u16 *ptr = (u16 *)txdesc;
+	__le16 *ptr = (__le16 *)txdesc;
 	u16	checksum = 0;
 	u32 index;
 
 	/* Clear first */
 	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
 	for (index = 0; index < 16; index++)
-		checksum = checksum ^ (*(ptr + index));
+		checksum = checksum ^ le16_to_cpu(*(ptr + index));
 	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, checksum);
 }
 
-- 
2.10.2
