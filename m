Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45246 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320AbZJANyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 09:54:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Don't use struct wldev after detach.
Date: Thu, 1 Oct 2009 15:54:32 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200910011554.34488.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't use struct wldev after detach. This fixes an oops on access.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


---
 drivers/net/wireless/b43/leds.c |    4 ++--
 drivers/net/wireless/b43/leds.h |    4 ++--
 drivers/net/wireless/b43/main.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/leds.c
+++ wireless-testing/drivers/net/wireless/b43/leds.c
@@ -348,9 +348,9 @@ void b43_leds_register(struct b43_wldev 
 	}
 }
 
-void b43_leds_unregister(struct b43_wldev *dev)
+void b43_leds_unregister(struct b43_wl *wl)
 {
-	struct b43_leds *leds = &dev->wl->leds;
+	struct b43_leds *leds = &wl->leds;
 
 	b43_unregister_led(&leds->led_tx);
 	b43_unregister_led(&leds->led_rx);
--- wireless-testing.orig/drivers/net/wireless/b43/leds.h
+++ wireless-testing/drivers/net/wireless/b43/leds.h
@@ -60,7 +60,7 @@ enum b43_led_behaviour {
 };
 
 void b43_leds_register(struct b43_wldev *dev);
-void b43_leds_unregister(struct b43_wldev *dev);
+void b43_leds_unregister(struct b43_wl *wl);
 void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
 void b43_leds_stop(struct b43_wldev *dev);
@@ -76,7 +76,7 @@ struct b43_leds {
 static inline void b43_leds_register(struct b43_wldev *dev)
 {
 }
-static inline void b43_leds_unregister(struct b43_wldev *dev)
+static inline void b43_leds_unregister(struct b43_wl *wl)
 {
 }
 static inline void b43_leds_init(struct b43_wldev *dev)
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4997,7 +4997,7 @@ static void b43_remove(struct ssb_device
 
 	if (list_empty(&wl->devlist)) {
 		b43_rng_exit(wl);
-		b43_leds_unregister(wldev);
+		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */

-- 
Greetings, Michael.
