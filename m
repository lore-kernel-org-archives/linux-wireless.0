Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:41517 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbeEVV3h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:29:37 -0400
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux@endlessm.com,
        =?UTF-8?q?Micha=C5=82=20K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] rfkill: Create rfkill-none LED trigger
Date: Tue, 22 May 2018 14:29:32 -0700
Message-Id: <20180522212932.5357-2-jprvita@endlessm.com> (sfid-20180522_233041_511890_47C141F4)
In-Reply-To: <20180522212932.5357-1-jprvita@endlessm.com>
References: <20180522212932.5357-1-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Creates a new trigger rfkill-none, as a complement to rfkill-any, which
drives LEDs when any radio is enabled. The new trigger is meant to turn
a LED ON whenever all radios are OFF, and turn it OFF otherwise.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 6d64d14f4b0a..07235520b00f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -178,6 +178,7 @@ static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
 }
 
 static struct led_trigger rfkill_any_led_trigger;
+static struct led_trigger rfkill_none_led_trigger;
 static struct work_struct rfkill_global_led_trigger_work;
 
 static void rfkill_global_led_trigger_worker(struct work_struct *work)
@@ -195,6 +196,8 @@ static void rfkill_global_led_trigger_worker(struct work_struct *work)
 	mutex_unlock(&rfkill_global_mutex);
 
 	led_trigger_event(&rfkill_any_led_trigger, brightness);
+	led_trigger_event(&rfkill_none_led_trigger, brightness == LED_OFF ?
+							LED_FULL : LED_OFF);
 }
 
 static void rfkill_global_led_trigger_event(void)
@@ -202,22 +205,32 @@ static void rfkill_global_led_trigger_event(void)
 	schedule_work(&rfkill_global_led_trigger_work);
 }
 
-static void rfkill_global_led_trigger_activate(struct led_classdev *led_cdev)
-{
-	rfkill_global_led_trigger_event();
-}
-
 static int rfkill_global_led_trigger_register(void)
 {
+	int ret;
+
 	INIT_WORK(&rfkill_global_led_trigger_work,
 			rfkill_global_led_trigger_worker);
+
 	rfkill_any_led_trigger.name = "rfkill-any";
-	rfkill_any_led_trigger.activate = rfkill_global_led_trigger_activate;
-	return led_trigger_register(&rfkill_any_led_trigger);
+	ret = led_trigger_register(&rfkill_any_led_trigger);
+	if (ret)
+		return ret;
+
+	rfkill_none_led_trigger.name = "rfkill-none";
+	ret = led_trigger_register(&rfkill_none_led_trigger);
+	if (ret)
+		led_trigger_unregister(&rfkill_any_led_trigger);
+	else
+		/* Delay activation until all global triggers are registered */
+		rfkill_global_led_trigger_event();
+
+	return ret;
 }
 
 static void rfkill_global_led_trigger_unregister(void)
 {
+	led_trigger_unregister(&rfkill_none_led_trigger);
 	led_trigger_unregister(&rfkill_any_led_trigger);
 	cancel_work_sync(&rfkill_global_led_trigger_work);
 }
-- 
2.17.0
