Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbXJNVEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 17:04:33 -0400
Date: Sun, 14 Oct 2007 16:04:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] b43legacy: Fix potential return of uninitialized variable
Message-ID: <4712845e.dLDtF9nZG6ErzRvs%Larry.Finger@lwfinger.net> (sfid-20071014_220438_263448_A14FC011)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the Coverity checker, Adrian Bunk found that routine b43legacy_start
could return an unitialized variable. This patch fixes the problem.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is intended for the everything branch of wireless-2.6.

Larry
---

 drivers/net/wireless/b43legacy/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -3237,7 +3237,7 @@ static int b43legacy_start(struct ieee80
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 
