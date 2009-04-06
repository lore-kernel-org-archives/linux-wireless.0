Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZDFR2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 13:28:35 -0400
Date: Mon, 06 Apr 2009 12:28:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Remove WARN_ON for rfkill not registered
Message-ID: <49da3bb8.wvkMslMpX/kpPqUV%Larry.Finger@lwfinger.net> (sfid-20090406_192838_147979_3239D3EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the latest set of rfkill patches are applied, b43 hits a WARN_ON that
rfkill has not been registered. The test is needed, but not the warning.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.31 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -74,7 +74,7 @@ static int b43_rfkill_soft_set(void *dat
 	struct b43_wl *wl = dev->wl;
 	int err = -EINVAL;
 
-	if (WARN_ON(!wl->rfkill.registered))
+	if (!wl->rfkill.registered)
 		return -EINVAL;
 
 	mutex_lock(&wl->mutex);
