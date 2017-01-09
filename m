Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36662 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754352AbdAIXBK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 18:01:10 -0500
Received: by mail-oi0-f68.google.com with SMTP id u143so18619469oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 15:01:10 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 2/3] rtlwifi: rtl8192cu: Calculate descriptor checksum correctly for BE
Date: Mon,  9 Jan 2017 17:00:57 -0600
Message-Id: <20170109230058.22758-3-Larry.Finger@lwfinger.net> (sfid-20170110_000115_916045_CF954608)
In-Reply-To: <20170109230058.22758-1-Larry.Finger@lwfinger.net>
References: <20170109230058.22758-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver requires a checksum for the descriptors so that the wifi
chip is assured that the USB transmission was correct. These entries
are little-endian, but the driver was always using cpu order in the
calculation. As a result, the driver failed on BE hardware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
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
