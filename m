Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.trained-monkey.org ([178.250.213.29]:37214 "EHLO
	ultrasam.lan.trained-monkey.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752473AbaGAHgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:36:19 -0400
From: Jes.Sorensen@redhat.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
	Fabian Frederick <fabf@skynet.be>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 10/10] staging: rtl8723au: Remove unnecessary null test before kfree
Date: Tue,  1 Jul 2014 09:35:58 +0200
Message-Id: <1404200158-26611-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20140701_093637_569896_707610BB)
In-Reply-To: <1404200158-26611-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1404200158-26611-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/staging/rtl8723au/core/rtw_cmd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index f44f941..df1ffb3 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -515,9 +515,7 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
 
 	psecnetwork = &psecuritypriv->sec_bss;
 	if (!psecnetwork) {
-		if (pcmd)
-			kfree(pcmd);
-
+		kfree(pcmd);
 		res = _FAIL;
 
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,
-- 
1.9.3

