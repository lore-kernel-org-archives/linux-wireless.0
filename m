Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58003 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaLNWgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 17:36:33 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so13199960wgh.36
        for <linux-wireless@vger.kernel.org>; Sun, 14 Dec 2014 14:36:31 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: os_dep: usb_intf.c:  Fix for possible null pointer dereference
Date: Sun, 14 Dec 2014 23:39:14 +0100
Message-Id: <1418596754-24735-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20141214_233644_296463_1F2DC225)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/os_dep/usb_intf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
index 865743e..71a6330 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
@@ -351,10 +351,11 @@ error_exit:
 int rtw_hw_resume23a(struct rtw_adapter *padapter)
 {
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
-	struct net_device *pnetdev = padapter->pnetdev;
+	struct net_device *pnetdev;
 
 	if (padapter) { /* system resume */
 		DBG_8723A("==> rtw_hw_resume23a\n");
+		pnetdev = padapter->pnetdev;
 		down(&pwrpriv->lock);
 		pwrpriv->bips_processing = true;
 		rtw_reset_drv_sw23a(padapter);
-- 
1.7.10.4

