Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34606 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbbEKSWX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 14:22:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix throughput LED trigger
Date: Mon, 11 May 2015 20:22:17 +0200
Message-Id: <1431368537-14267-1-git-send-email-johannes@sipsolutions.net> (sfid-20150511_202242_580854_8A519CF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As I was testing with hwsim, I missed that my previous commit to
make LED work depend on activation broke the code because I missed
removing the old trigger struct and some code was still using it,
now erroneously, causing crashes.

Fix this by always using the correct struct.

Reported-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/led.c         | 12 ++++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 241b74f3bd81..2c4fe45ea38a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1038,7 +1038,6 @@ enum queue_stop_reason {
 
 #ifdef CONFIG_MAC80211_LEDS
 struct tpt_led_trigger {
-	struct led_trigger trig;
 	char name[32];
 	const struct ieee80211_tpt_blink *blink_table;
 	unsigned int blink_table_len;
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index 38f05565eaac..0505845b7ab8 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -276,10 +276,10 @@ static void tpt_trig_timer(unsigned long data)
 		}
 	}
 
-	read_lock(&tpt_trig->trig.leddev_list_lock);
-	list_for_each_entry(led_cdev, &tpt_trig->trig.led_cdevs, trig_list)
+	read_lock(&local->tpt_led.leddev_list_lock);
+	list_for_each_entry(led_cdev, &local->tpt_led.led_cdevs, trig_list)
 		led_blink_set(led_cdev, &on, &off);
-	read_unlock(&tpt_trig->trig.leddev_list_lock);
+	read_unlock(&local->tpt_led.leddev_list_lock);
 }
 
 const char *
@@ -341,10 +341,10 @@ static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
 	tpt_trig->running = false;
 	del_timer_sync(&tpt_trig->timer);
 
-	read_lock(&tpt_trig->trig.leddev_list_lock);
-	list_for_each_entry(led_cdev, &tpt_trig->trig.led_cdevs, trig_list)
+	read_lock(&local->tpt_led.leddev_list_lock);
+	list_for_each_entry(led_cdev, &local->tpt_led.led_cdevs, trig_list)
 		led_set_brightness(led_cdev, LED_OFF);
-	read_unlock(&tpt_trig->trig.leddev_list_lock);
+	read_unlock(&local->tpt_led.leddev_list_lock);
 }
 
 void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
-- 
2.1.4

