Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36538 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbbEWFDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 01:03:12 -0400
From: Juston Li <juston.h.li@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Juston Li <juston.h.li@gmail.com>
Subject: [PATCH] staging: rtl8723au: fix sparse warning
Date: Fri, 22 May 2015 22:03:04 -0700
Message-Id: <1432357384-16665-1-git-send-email-juston.h.li@gmail.com> (sfid-20150523_070655_219033_61D493CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change cast to __le16 to fix the following warning:
drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1488:20: warning: cast to restricted __le16

Signed-off-by: Juston Li <juston.h.li@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index 04d0183..e23af8e 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -1485,7 +1485,7 @@ void Hal_EfuseParseIDCode(struct rtw_adapter *padapter, u8 *hwinfo)
 	u16 EEPROMId;
 
 	/*  Checl 0x8129 again for making sure autoload status!! */
-	EEPROMId = le16_to_cpu(*((u16 *) hwinfo));
+	EEPROMId = le16_to_cpu(*((__le16 *) hwinfo));
 	if (EEPROMId != RTL_EEPROM_ID) {
 		DBG_8723A("EEPROM ID(%#x) is invalid!!\n", EEPROMId);
 		pEEPROM->bautoload_fail_flag = true;
-- 
2.4.1

