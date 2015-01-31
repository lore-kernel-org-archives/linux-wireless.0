Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40155 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbbAaOz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 09:55:29 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so31545660wgh.8
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 06:55:27 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: rtw_mlme: Removed variables that is never used
Date: Sat, 31 Jan 2015 15:58:49 +0100
Message-Id: <1422716329-3718-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_155545_510684_A0CA1BA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/core/rtw_mlme.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
index 7299ef0..8b2db4b 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
@@ -2123,7 +2123,6 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
 {
 	u32 out_len;
 	int max_rx_ampdu_factor;
-	unsigned char *pframe;
 	const u8 *p;
 	struct ieee80211_ht_cap ht_capie;
 	u8 WMM_IE[7] = {0x00, 0x50, 0xf2, 0x02, 0x00, 0x01, 0x00};
@@ -2139,10 +2138,10 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
 
 		if (pmlmepriv->qos_option == 0) {
 			out_len = *pout_len;
-			pframe = rtw_set_ie23a(out_ie + out_len,
-					       WLAN_EID_VENDOR_SPECIFIC,
-					       sizeof(WMM_IE), WMM_IE,
-					       pout_len);
+			rtw_set_ie23a(out_ie + out_len,
+						WLAN_EID_VENDOR_SPECIFIC,
+						sizeof(WMM_IE), WMM_IE,
+						pout_len);
 
 			pmlmepriv->qos_option = 1;
 		}
@@ -2172,18 +2171,18 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
 			ht_capie.ampdu_params_info |=
 				(IEEE80211_HT_AMPDU_PARM_DENSITY & 0x00);
 
-		pframe = rtw_set_ie23a(out_ie + out_len, WLAN_EID_HT_CAPABILITY,
-				    sizeof(struct ieee80211_ht_cap),
-				    (unsigned char *)&ht_capie, pout_len);
+		rtw_set_ie23a(out_ie + out_len, WLAN_EID_HT_CAPABILITY,
+				sizeof(struct ieee80211_ht_cap),
+				(unsigned char *)&ht_capie, pout_len);
 
 		phtpriv->ht_option = true;
 
 		p = cfg80211_find_ie(WLAN_EID_HT_OPERATION, in_ie, in_len);
 		if (p && (p[1] == sizeof(struct ieee80211_ht_operation))) {
 			out_len = *pout_len;
-			pframe = rtw_set_ie23a(out_ie + out_len,
-					       WLAN_EID_HT_OPERATION,
-					       p[1], p + 2 , pout_len);
+			rtw_set_ie23a(out_ie + out_len,
+					WLAN_EID_HT_OPERATION,
+					p[1], p + 2, pout_len);
 		}
 	}
 
-- 
1.7.10.4

