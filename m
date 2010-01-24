Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37998 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab0AXMPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 07:15:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Workaround circular locking in hw-tkip key update callback
Date: Sun, 24 Jan 2010 13:13:32 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	kecsa@kutfo.hit.bme.hu, Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201001241313.34784.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TKIP key update callback is called from the RX path, where the driver
mutex is already locked. This results in a circular locking bug.
Avoid this by removing the lock.

Johannes noted that there is a separate bug: The callback still breaks on SDIO
hardware, because SDIO hardware access needs to sleep, but we are not allowed
to sleep in the callback due to mac80211's RCU locking.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: kecsa@kutfo.hit.bme.hu
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: stable <stable@kernel.org>

---
 drivers/net/wireless/b43/main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -856,22 +856,19 @@ static void b43_op_update_tkip_key(struc
 	if (B43_WARN_ON(!modparam_hwtkip))
 		return;
 
-	mutex_lock(&wl->mutex);
-
+	/* This is only called from the RX path through mac80211, where
+	 * our mutex is already locked. */
+	B43_WARN_ON(!mutex_is_locked(&wl->mutex));
 	dev = wl->current_dev;
-	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
-		goto out_unlock;
+	B43_WARN_ON(!dev || b43_status(dev) < B43_STAT_INITIALIZED);
 
 	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
 
 	rx_tkip_phase1_write(dev, index, iv32, phase1key);
 	/* only pairwise TKIP keys are supported right now */
 	if (WARN_ON(!sta))
-		goto out_unlock;
+		return;
 	keymac_write(dev, index, sta->addr);
-
-out_unlock:
-	mutex_unlock(&wl->mutex);
 }
 
 static void do_key_write(struct b43_wldev *dev,

-- 
Greetings, Michael.
