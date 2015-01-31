Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:40382 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbAaPH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 10:07:59 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so31885689wev.12
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 07:07:58 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: hal: rtl8723a_hal_init: Removed variables that is never used
Date: Sat, 31 Jan 2015 16:11:19 +0100
Message-Id: <1422717079-5629-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_160820_568899_65170CE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index a5eadd4..f2bcf4f 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -604,7 +604,7 @@ rtl8723a_readefuse(struct rtw_adapter *padapter,
 u16 rtl8723a_EfuseGetCurrentSize_WiFi(struct rtw_adapter *padapter)
 {
 	u16 efuse_addr = 0;
-	u8 hoffset = 0, hworden = 0;
+	u8 hworden = 0;
 	u8 efuse_data, word_cnts = 0;
 	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
 
@@ -627,17 +627,14 @@ u16 rtl8723a_EfuseGetCurrentSize_WiFi(struct rtw_adapter *padapter)
 			break;
 
 		if (EXT_HEADER(efuse_data)) {
-			hoffset = GET_HDR_OFFSET_2_0(efuse_data);
 			efuse_addr++;
 			efuse_OneByteRead23a(padapter, efuse_addr, &efuse_data);
 			if (ALL_WORDS_DISABLED(efuse_data)) {
 				continue;
 			}
 
-			hoffset |= ((efuse_data & 0xF0) >> 1);
 			hworden = efuse_data & 0x0F;
 		} else {
-			hoffset = (efuse_data >> 4) & 0x0F;
 			hworden = efuse_data & 0x0F;
 		}
 
@@ -657,7 +654,7 @@ u16 rtl8723a_EfuseGetCurrentSize_BT(struct rtw_adapter *padapter)
 	u16 btusedbytes;
 	u16 efuse_addr;
 	u8 bank, startBank;
-	u8 hoffset = 0, hworden = 0;
+	u8 hworden = 0;
 	u8 efuse_data, word_cnts = 0;
 	u16 retU2 = 0;
 	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
@@ -700,7 +697,6 @@ u16 rtl8723a_EfuseGetCurrentSize_BT(struct rtw_adapter *padapter)
 				break;
 
 			if (EXT_HEADER(efuse_data)) {
-				hoffset = GET_HDR_OFFSET_2_0(efuse_data);
 				efuse_addr++;
 				efuse_OneByteRead23a(padapter, efuse_addr,
 						  &efuse_data);
@@ -709,10 +705,8 @@ u16 rtl8723a_EfuseGetCurrentSize_BT(struct rtw_adapter *padapter)
 					continue;
 				}
 
-				hoffset |= ((efuse_data & 0xF0) >> 1);
 				hworden = efuse_data & 0x0F;
 			} else {
-				hoffset = (efuse_data >> 4) & 0x0F;
 				hworden = efuse_data & 0x0F;
 			}
 			word_cnts = Efuse_CalculateWordCnts23a(hworden);
-- 
1.7.10.4

