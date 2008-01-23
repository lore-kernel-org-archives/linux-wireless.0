Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59547 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYAWLQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 06:16:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Fix rfkill allocation leakage in error paths
Date: Wed, 23 Jan 2008 12:15:38 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801231215.38768.mb@bu3sch.de> (sfid-20080123_111645_145613_B4C4CD56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must kill rfkill in any error paths that trigger after rfkill init.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please try to push this for 2.6.24. Seems quite important,
as it leaks resources and might crash the kernel.


Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c	2008-01-16 23:28:50.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c	2008-01-23 12:04:41.000000000 +0100
@@ -3218,38 +3218,45 @@ static void b43legacy_op_remove_interfac
 static int b43legacy_op_start(struct ieee80211_hw *hw)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	int did_init = 0;
 	int err = 0;
+	bool do_rfkill_exit = 0;
 
 	/* First register RFkill.
 	 * LEDs that are registered later depend on it. */
 	b43legacy_rfkill_init(dev);
 
 	mutex_lock(&wl->mutex);
 
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
 		err = b43legacy_wireless_core_init(dev);
-		if (err)
+		if (err) {
+			do_rfkill_exit = 1;
 			goto out_mutex_unlock;
+		}
 		did_init = 1;
 	}
 
 	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
 		err = b43legacy_wireless_core_start(dev);
 		if (err) {
 			if (did_init)
 				b43legacy_wireless_core_exit(dev);
+			do_rfkill_exit = 1;
 			goto out_mutex_unlock;
 		}
 	}
 
 out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
+	if (do_rfkill_exit)
+		b43legacy_rfkill_exit(dev);
+
 	return err;
 }
 
 static void b43legacy_op_stop(struct ieee80211_hw *hw)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
