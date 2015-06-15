Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45572 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbbFONKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 09:10:08 -0400
From: Andreas Ruprecht <andreas.ruprecht@fau.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Andreas Ruprecht <andreas.ruprecht@fau.de>
Subject: [PATCH] staging: rtl8723au: core: Remove unneeded #ifdefs
Date: Mon, 15 Jun 2015 15:03:00 +0200
Message-Id: <1434373380-8200-1-git-send-email-andreas.ruprecht@fau.de> (sfid-20150615_151024_291162_9224CAE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rtw_mlme_ext.c, nested #ifdef blocks form the following
structure inside the file:

 #ifdef CONFIG_8723AU_AP_MODE           (line 1323)
 [...]
 #ifdef CONFIG_8723AU_AP_MODE           (line 1720)
 [...]
 #endif
 (2 more ifdef blocks with CONFIG_8723AU_AP_MODE follow)
 [...]
 #endif /* CONFIG_8723AU_AP_MODE */     (line 1763)

The inner #ifdefs are unnecessary as they depend on the
same condition as the outer #ifdef and can thus be removed.

Signed-off-by: Andreas Ruprecht <andreas.ruprecht@fau.de>
---
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index 0d7e921..be9a3d5 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -1717,7 +1717,6 @@ OnAssocReq23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 	/*  now the station is qualified to join our BSS... */
 	if (pstat && pstat->state & WIFI_FW_ASSOC_SUCCESS &&
 	    status == WLAN_STATUS_SUCCESS) {
-#ifdef CONFIG_8723AU_AP_MODE
 		/* 1 bss_cap_update & sta_info_update23a */
 		bss_cap_update_on_sta_join23a(padapter, pstat);
 		sta_info_update23a(padapter, pstat);
@@ -1736,21 +1735,17 @@ OnAssocReq23a(struct rtw_adapter *padapter, struct recv_frame *precv_frame)
 
 		/* 3-(1) report sta add event */
 		report_add_sta_event23a(padapter, pstat->hwaddr, pstat->aid);
-#endif
 	}
 
 	return _SUCCESS;
 
 asoc_class2_error:
 
-#ifdef CONFIG_8723AU_AP_MODE
 	issue_deauth23a(padapter, mgmt->sa, status);
-#endif
 	return _FAIL;
 
 OnAssocReq23aFail:
 
-#ifdef CONFIG_8723AU_AP_MODE
 	pstat->aid = 0;
 	if (ieee80211_is_assoc_req(mgmt->frame_control))
 		issue_assocrsp(padapter, status, pstat,
@@ -1758,7 +1753,6 @@ OnAssocReq23aFail:
 	else
 		issue_assocrsp(padapter, status, pstat,
 			       IEEE80211_STYPE_REASSOC_RESP);
-#endif
 
 #endif /* CONFIG_8723AU_AP_MODE */
 
-- 
1.9.1

