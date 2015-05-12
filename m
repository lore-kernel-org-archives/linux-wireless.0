Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0142.outbound.protection.outlook.com ([157.55.234.142]:24857
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbbELKBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 06:01:21 -0400
From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
To: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"joe@perches.com" <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Babu, Viswanathan (V.)" <vbabu3@visteon.com>
Subject: [PATCH] staging: rtl8723au: remove redundant initialization
Date: Tue, 12 May 2015 10:01:18 +0000
Message-ID: <20150512095535.GA5332@IND12F0122> (sfid-20150512_120127_403758_5888EA8F)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable pHalData is initialized twice in this same function with
same value.So removing one of them.

Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 11e1108..9733aa6 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -55,7 +55,7 @@ int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen,
 	u8 h2c_box_num;
 	u32 msgbox_addr;
 	u32 msgbox_ex_addr;
-	struct hal_data_8723a *pHalData = GET_HAL_DATA(padapter);
+	struct hal_data_8723a *pHalData;
 	u32 h2c_cmd = 0;
 	u16 h2c_cmd_ex = 0;
 	int ret = _FAIL;
-- 
1.9.1
