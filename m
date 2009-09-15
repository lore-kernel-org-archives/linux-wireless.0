Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp138.mail.ukl.yahoo.com ([77.238.184.69]:46730 "HELO
	smtp138.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752413AbZIOUdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 16:33:00 -0400
From: Albert Herranz <albert_herranz@yahoo.es>
To: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Cc: Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH] b43: fix build error if !CONFIG_B43_LEDS
Date: Tue, 15 Sep 2009 22:32:54 +0200
Message-Id: <1253046774-14416-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following build error when CONFIG_B43_LEDS is not selected:

drivers/net/wireless/b43/main.c: In function 'b43_remove':
drivers/net/wireless/b43/main.c:4990: error: 'struct b43_leds' has no member named 'stop'
drivers/net/wireless/b43/main.c:4991: error: 'struct b43_leds' has no member named 'work'
make[4]: *** [drivers/net/wireless/b43/main.o] Error 1

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
 drivers/net/wireless/b43/leds.c |    8 ++++++++
 drivers/net/wireless/b43/leds.h |    4 ++++
 drivers/net/wireless/b43/main.c |    3 +--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index fbe31e0..fbe3d4f 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -325,6 +325,14 @@ void b43_leds_exit(struct b43_wldev *dev)
 	b43_led_turn_off(dev, leds->led_radio.index, leds->led_radio.activelow);
 }
 
+void b43_leds_stop(struct b43_wldev *dev)
+{
+	struct b43_leds *leds = &dev->wl->leds;
+
+	leds->stop = 1;
+	cancel_work_sync(&leds->work);
+}
+
 void b43_leds_register(struct b43_wldev *dev)
 {
 	unsigned int i;
diff --git a/drivers/net/wireless/b43/leds.h b/drivers/net/wireless/b43/leds.h
index 49d3da5..9592e4c 100644
--- a/drivers/net/wireless/b43/leds.h
+++ b/drivers/net/wireless/b43/leds.h
@@ -63,6 +63,7 @@ void b43_leds_register(struct b43_wldev *dev);
 void b43_leds_unregister(struct b43_wldev *dev);
 void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
+void b43_leds_stop(struct b43_wldev *dev);
 
 
 #else /* CONFIG_B43_LEDS */
@@ -84,6 +85,9 @@ static inline void b43_leds_init(struct b43_wldev *dev)
 static inline void b43_leds_exit(struct b43_wldev *dev)
 {
 }
+static inline void b43_leds_stop(struct b43_wldev *dev)
+{
+}
 #endif /* CONFIG_B43_LEDS */
 
 #endif /* B43_LEDS_H_ */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a8840ef..6c0ea21 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4987,8 +4987,7 @@ static void b43_remove(struct ssb_device *dev)
 		 * might have modified it. Restoring is important, so the networking
 		 * stack can properly free resources. */
 		wl->hw->queues = wl->mac80211_initially_registered_queues;
-		wl->leds.stop = 1;
-		cancel_work_sync(&wl->leds.work);
+		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-- 
1.6.0.4

