Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33057 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbJTGqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:17 -0400
Received: by lffv3 with SMTP id v3so711443lff.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:15 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 01/16] rtl8xxxu: Treat REG_9346CR as an 8-bit wide register
Date: Tue, 20 Oct 2015 08:45:31 +0200
Message-Id: <1445323546-12807-2-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084620_756486_2AAFD002)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8723au driver treats REG_9346CR register as either 8- or 16-bit wide,
while rtl8192cu driver treats it as 8-bit wide, and so does rtl8188eu
driver.  Use the lowest common denominator strategy.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 11fcfda..5f90261 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1928,10 +1928,10 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 	u16 val16, efuse_addr, offset;
 	u32 val32;
 
-	val16 = rtl8xxxu_read16(priv, REG_9346CR);
-	if (val16 & EEPROM_ENABLE)
+	val8 = rtl8xxxu_read8(priv, REG_9346CR);
+	if (val8 & EEPROM_ENABLE)
 		priv->has_eeprom = 1;
-	if (val16 & EEPROM_BOOT)
+	if (val8 & EEPROM_BOOT)
 		priv->boot_eeprom = 1;
 
 	val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
-- 
2.1.0

