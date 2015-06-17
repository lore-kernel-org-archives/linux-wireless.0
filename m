Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0108.outbound.protection.outlook.com ([157.55.234.108]:38448
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754644AbbFQNWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 09:22:30 -0400
From: "Mutharaju, Prasanna (P.)" <mkarthi3@visteon.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"carlos@cgarcia.org" <carlos@cgarcia.org>,
	"hamohammed.sa@gmail.com" <hamohammed.sa@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] staging:rtl8723au: Fix return statement reported by
 coccinelle
Date: Wed, 17 Jun 2015 12:50:14 +0000
Message-ID: <20150617124933.GA30109@ubuntu> (sfid-20150617_152234_041752_331A736A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prasanna Karthik <mkarthi3@visteon.com>

Modified return statement and removed local declaration no longer
needed. No Compiler warnings.

Signed-off-by: Prasanna Karthik <mkarthi3@visteon.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c b/drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c
index 4909835..11d635d 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c
@@ -500,7 +500,6 @@ phy_RF6052_Config_ParaFile_Fail:
 int PHY_RF6052_Config8723A(struct rtw_adapter *Adapter)
 {
 	struct hal_data_8723a *pHalData = GET_HAL_DATA(Adapter);
-	int rtStatus = _SUCCESS;
 
 	/*  Initialize general global value */
 	/*  TODO: Extend RF_PATH_C and RF_PATH_D in the future */
@@ -510,8 +509,7 @@ int PHY_RF6052_Config8723A(struct rtw_adapter *Adapter)
 		pHalData->NumTotalRFPath = 2;
 
 	/*  Config BB and RF */
-	rtStatus = phy_RF6052_Config_ParaFile(Adapter);
-	return rtStatus;
+	return phy_RF6052_Config_ParaFile(Adapter);
 }
 
 /* End of HalRf6052.c */
-- 
1.7.0.4
