Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sif.is.scarlet.be ([193.74.71.28]:59876 "EHLO sif.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbbJZIuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 04:50:05 -0400
From: Ewoud Van Craeynest <ewoudvc@gmail.com>
To: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Cc: Ewoud Van Craeynest <ewoudvc@gmail.com>
Subject: [PATCH] Staging: rtl8723: Fixed a few whitespace related coding style errors
Date: Mon, 26 Oct 2015 08:40:26 +0000
Message-Id: <1445848826-23469-1-git-send-email-ewoudvc@gmail.com> (sfid-20151026_095009_942908_58C9BCAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ewoud Van Craeynest <ewoudvc@gmail.com>
---
This is my first patch. I followed the kernel newbie's guide
---
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 5e8736092720..940d38ba86de 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -542,7 +542,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 		switch (ACI) {
 		case 0x0:
 			rtl8723a_set_ac_param_be(padapter, acParm);
-			acm_mask |= (ACM? BIT(1):0);
+			acm_mask |= (ACM ? BIT(1) : 0);
 			edca[XMIT_BE_QUEUE] = acParm;
 			break;
 		case 0x1:
@@ -552,12 +552,12 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 			break;
 		case 0x2:
 			rtl8723a_set_ac_param_vi(padapter, acParm);
-			acm_mask |= (ACM? BIT(2):0);
+			acm_mask |= (ACM ? BIT(2) : 0);
 			edca[XMIT_VI_QUEUE] = acParm;
 			break;
 		case 0x3:
 			rtl8723a_set_ac_param_vo(padapter, acParm);
-			acm_mask |= (ACM? BIT(3):0);
+			acm_mask |= (ACM ? BIT(3) : 0);
 			edca[XMIT_VO_QUEUE] = acParm;
 			break;
 		}
@@ -597,7 +597,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 		}
 	}
 
-	for (i = 0; i<4; i++) {
+	for (i = 0; i < 4; i++) {
 		pxmitpriv->wmm_para_seq[i] = inx[i];
 		DBG_8723A("wmm_para_seq(%d): %d\n", i,
 			  pxmitpriv->wmm_para_seq[i]);
@@ -628,7 +628,7 @@ static void bwmode_update_check(struct rtw_adapter *padapter, const u8 *p)
 	    pregistrypriv->cbw40_enable) {
 		new_bwmode = HT_CHANNEL_WIDTH_40;
 
-		switch (pHT_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET){
+		switch (pHT_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 			new_ch_offset = HAL_PRIME_CHNL_OFFSET_LOWER;
 			break;
@@ -1189,7 +1189,7 @@ unsigned int update_basic_rate23a(unsigned char *ptn, unsigned int ptn_sz)
 	unsigned int i, num_of_rate;
 	unsigned int mask = 0;
 
-	num_of_rate = (ptn_sz > NumRates)? NumRates: ptn_sz;
+	num_of_rate = (ptn_sz > NumRates) ? NumRates : ptn_sz;
 
 	for (i = 0; i < num_of_rate; i++) {
 		if ((*(ptn + i)) & 0x80)
@@ -1231,7 +1231,7 @@ int support_short_GI23a(struct rtw_adapter *padapter,
 		return _FAIL;
 	if (pmlmeinfo->assoc_AP_vendor == HT_IOT_PEER_RALINK)
 		return _FAIL;
-	bit_offset = (pmlmeext->cur_bwmode & HT_CHANNEL_WIDTH_40)? 6: 5;
+	bit_offset = (pmlmeext->cur_bwmode & HT_CHANNEL_WIDTH_40) ? 6 : 5;
 
 	if (pHT_caps->cap_info & cpu_to_le16(0x1 << bit_offset))
 		return _SUCCESS;
-- 
1.7.9.5

