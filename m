Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0136.outbound.protection.outlook.com ([157.55.234.136]:53486
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbbFNEjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 00:39:43 -0400
From: "Joglekar, Tejas (T.)" <tjogleka@visteon.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"gdonald@gmail.com" <gdonald@gmail.com>,
	"aybuke.147@gmail.com" <aybuke.147@gmail.com>,
	"roberta.dobrescu@gmail.com" <roberta.dobrescu@gmail.com>,
	"dilekuzulmez@gmail.com" <dilekuzulmez@gmail.com>,
	"ruchandani.tina@gmail.com" <ruchandani.tina@gmail.com>,
	"joe@perches.com" <joe@perches.com>,
	"mp.gaman@gmail.com" <mp.gaman@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging:rtl8723au:rtw_ap:space prohibited between function
 name & '('
Date: Sun, 14 Jun 2015 04:25:28 +0000
Message-ID: <20150614042523.GA7431@Tejas-asus> (sfid-20150614_063951_764614_AE996B2A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joglekar Tejas <tjogleka@visteon.com>

This patch removes the warning "space prohibited between
function name and open parenthesis"given by checkpatch.pl

Signed-off-by: Joglekar Tejas <tjogleka@visteon.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 6456689..65b209a 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1642,7 +1642,7 @@ u8 ap_free_sta23a(struct rtw_adapter *padapter, struct sta_info *psta, bool acti
 	return beacon_updated;
 }
 
-int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
+int rtw_ap_inform_ch_switch23a(struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
 {
 	struct list_head *phead, *plist;
 	struct sta_info *psta = NULL;
@@ -1663,12 +1663,12 @@ int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_o
 	list_for_each(plist, phead) {
 		psta = container_of(plist, struct sta_info, asoc_list);
 
-		issue_action_spct_ch_switch23a (padapter, psta->hwaddr, new_ch, ch_offset);
+		issue_action_spct_ch_switch23a(padapter, psta->hwaddr, new_ch, ch_offset);
 		psta->expire_to = ((pstapriv->expire_to * 2) > 5) ? 5 : (pstapriv->expire_to * 2);
 	}
 	spin_unlock_bh(&pstapriv->asoc_list_lock);
 
-	issue_action_spct_ch_switch23a (padapter, bc_addr, new_ch, ch_offset);
+	issue_action_spct_ch_switch23a(padapter, bc_addr, new_ch, ch_offset);
 
 	return 0;
 }
@@ -1871,7 +1871,7 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	pmlmeext->bstart_bss = false;
 
 	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
-	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
+	memset((unsigned char *)&padapter->securitypriv, 0, sizeof(struct security_priv));
 	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
 	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
 
-- 
1.9.1
