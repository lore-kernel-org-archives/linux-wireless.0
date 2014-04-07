Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16511 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDGGbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 02:31:48 -0400
Date: Mon, 7 Apr 2014 09:31:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Faris de Haan <farisdehaan@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] Staging: rtl8188eu: overflow in update_sta_support_rate()
Message-ID: <20140407063121.GB11581@mwanda> (sfid-20140407_083159_329553_D9350A78)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ->SupportedRates[] array has NDIS_802_11_LENGTH_RATES_EX (16)
elements.  Since "ie_len" comes from then network and can go up to 255
then it means we should add a range check to prevent memory corruption.

Fixes: d6846af679e0 ('staging: r8188eu: Add files for new driver - part 7')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 3dd9059..6c9e9a1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -1599,13 +1599,18 @@ int update_sta_support_rate(struct adapter *padapter, u8 *pvar_ie, uint var_ie_l
 	pIE = (struct ndis_802_11_var_ie *)rtw_get_ie(pvar_ie, _SUPPORTEDRATES_IE_, &ie_len, var_ie_len);
 	if (pIE == NULL)
 		return _FAIL;
+	if (ie_len > NDIS_802_11_LENGTH_RATES_EX)
+		return _FAIL;
 
 	memcpy(pmlmeinfo->FW_sta_info[cam_idx].SupportedRates, pIE->data, ie_len);
 	supportRateNum = ie_len;
 
 	pIE = (struct ndis_802_11_var_ie *)rtw_get_ie(pvar_ie, _EXT_SUPPORTEDRATES_IE_, &ie_len, var_ie_len);
-	if (pIE)
+	if (pIE) {
+		if (supportRateNum + ie_len > NDIS_802_11_LENGTH_RATES_EX)
+			return _FAIL;
 		memcpy((pmlmeinfo->FW_sta_info[cam_idx].SupportedRates + supportRateNum), pIE->data, ie_len);
+	}
 
 	return _SUCCESS;
 }
