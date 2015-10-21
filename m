Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42202 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbbJURco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 13:32:44 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	roberta.dobrescu@gmail.com, joe@perches.com, fabf@skynet.be,
	amitoj1606@gmail.com, linux-wireless@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] staging: rtl8723au: core: rtw_wlan_util: fix misleading indentation
Date: Wed, 21 Oct 2015 18:32:38 +0100
Message-Id: <1445448758-28794-1-git-send-email-luisbg@osg.samsung.com> (sfid-20151021_193314_397039_4B5AE1E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For loop is outside of the else branch of the above conditional statement.
Fixing misleading indentation.

Fix a smatch warning:
drivers/staging/rtl8723au/core/rtw_wlan_util.c:528
WMMOnAssocRsp23a() warn: curly braces intended?

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 drivers/staging/rtl8723au/core/rtw_wlan_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 5e87360..cc2b84b 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -525,7 +525,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 	else
 		aSifsTime = 16;
 
-		for (i = 0; i < 4; i++) {
+	for (i = 0; i < 4; i++) {
 		ACI = (pmlmeinfo->WMM_param.ac_param[i].ACI_AIFSN >> 5) & 0x03;
 		ACM = (pmlmeinfo->WMM_param.ac_param[i].ACI_AIFSN >> 4) & 0x01;
 
-- 
2.5.1

