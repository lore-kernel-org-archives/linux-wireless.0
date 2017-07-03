Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdGCM2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 08:28:31 -0400
From: Stefan Assmann <sassmann@kpanic.de>
To: devel@driverdev.osuosl.org
Cc: linux-wireless@vger.kernel.org, sassmann@kpanic.de
Subject: [PATCH] rtl8723bs: fix build when DEBUG_RTL871X is defined
Date: Mon,  3 Jul 2017 14:27:33 +0200
Message-Id: <20170703122733.28512-1-sassmann@kpanic.de> (sfid-20170703_142834_670630_32A17D26)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Defining DEBUG_RTL871X in rtw_debug.h causes the following compile error:
  CC [M]  drivers/staging/rtl8723bs/core/rtw_mlme.o
In file included from drivers/staging/rtl8723bs/core/rtw_mlme.c:18:0:
drivers/staging/rtl8723bs/core/rtw_mlme.c: In function ‘rtw_restruct_sec_ie’:
drivers/staging/rtl8723bs/core/rtw_mlme.c:2502:19: error: ‘ndissecuritytype’ undeclared (first use in thisfunction)

Remove the no longer existing parameter.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 9e35573..f97f35a 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2498,8 +2498,7 @@ sint rtw_restruct_sec_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in
 	uint	ndisauthmode = psecuritypriv->ndisauthtype;
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
-		 ("+rtw_restruct_sec_ie: ndisauthmode =%d ndissecuritytype =%d\n",
-		  ndisauthmode, ndissecuritytype));
+		 ("+rtw_restruct_sec_ie: ndisauthmode =%d\n", ndisauthmode));
 
 	/* copy fixed ie only */
 	memcpy(out_ie, in_ie, 12);
-- 
2.9.4
