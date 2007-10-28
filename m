Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48066
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXJ1Q2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 12:28:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix rfkill callback deadlock
Date: Sun, 28 Oct 2007 17:27:10 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710281727.10446.mb@bu3sch.de> (sfid-20071028_162832_939171_EB5C4C6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl->mutex might already be locked on initialization.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c	2007-10-27 13:28:16.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c	2007-10-28 17:13:55.000000000 +0100
@@ -61,15 +61,22 @@ static void b43_rfkill_poll(struct input
 		mutex_unlock(&wl->mutex);
 }
 
-/* Called when the RFKILL toggled in software.
- * This is called without locking. */
+/* Called when the RFKILL toggled in software. */
 static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
 {
 	struct b43_wldev *dev = data;
 	struct b43_wl *wl = dev->wl;
 	int err = 0;
 
-	mutex_lock(&wl->mutex);
+	/* When RFKILL is registered, it will call back into this callback.
+	 * wl->mutex will already be locked when this happens.
+	 * So first trylock. On contention check if we are in initialization.
+	 * Silently return if that happens to avoid a deadlock. */
+	if (mutex_trylock(&wl->mutex) == 0) {
+		if (b43_status(dev) < B43_STAT_INITIALIZED)
+			return 0;
+		mutex_lock(&wl->mutex);
+	}
 	if (b43_status(dev) < B43_STAT_INITIALIZED)
 		goto out_unlock;
 
@@ -89,7 +96,6 @@ static int b43_rfkill_soft_toggle(void *
 			b43_radio_turn_off(dev, 0);
 		break;
 	}
-
 out_unlock:
 	mutex_unlock(&wl->mutex);
 
