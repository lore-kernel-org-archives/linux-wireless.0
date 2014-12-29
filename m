Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:39535 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaL2CWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2014 21:22:31 -0500
From: Matthew Emerson <emersonmde@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Matthew Emerson <emersonmde@gmail.com>
Subject: [PATCH] staging: rtl8723au: changes stop ap mode to use reset function
Date: Sun, 28 Dec 2014 21:22:16 -0500
Message-Id: <1419819736-4861-1-git-send-email-emersonmde@gmail.com> (sfid-20141229_032247_969942_244802BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes stop_ap_mode23a() to use rtw_reset_securitypriv23a. This makes
the code cleaner and fixes two checkpatch.pl errors, one line over 80
characters, and one spacing issue.

Signed-off-by: Matthew Emerson <emersonmde@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index e394d12c36b0..510ee212496f 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1870,10 +1870,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	pmlmepriv->update_bcn = false;
 	pmlmeext->bstart_bss = false;
 
-	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
-	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
-	padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeOpen;
-	padapter->securitypriv.ndisencryptstatus = Ndis802_11WEPDisabled;
+	/* reset and init security priv */
+	rtw_reset_securitypriv23a(padapter);
 
 	/* for ACL */
 	spin_lock_bh(&pacl_node_q->lock);
-- 
2.0.5

