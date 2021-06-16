Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C46C48BE6
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jun 2021 19:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D35F61246
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jun 2021 19:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhFPTaS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jun 2021 15:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbhFPTaS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jun 2021 15:30:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9540C061767
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2021 12:28:11 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ltbCq-007jnG-BU; Wed, 16 Jun 2021 21:28:08 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't open-code LED manipulations
Date:   Wed, 16 Jun 2021 21:28:05 +0200
Message-Id: <20210616212804.b19ba1c60353.I8ea1b4defd5e12fc20ef281291e602feeec336a6@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We shouldn't open-code led_trigger_blink() or led_trigger_event(),
use them instead of badly open-coding them. This also fixes the
locking, led_trigger_blink() and led_trigger_event() now use
read_lock_irqsave().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/led.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index b275c8853074..6de8d0ad5497 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -259,7 +259,6 @@ static void tpt_trig_timer(struct timer_list *t)
 {
 	struct tpt_led_trigger *tpt_trig = from_timer(tpt_trig, t, timer);
 	struct ieee80211_local *local = tpt_trig->local;
-	struct led_classdev *led_cdev;
 	unsigned long on, off, tpt;
 	int i;
 
@@ -283,10 +282,7 @@ static void tpt_trig_timer(struct timer_list *t)
 		}
 	}
 
-	read_lock(&local->tpt_led.leddev_list_lock);
-	list_for_each_entry(led_cdev, &local->tpt_led.led_cdevs, trig_list)
-		led_blink_set(led_cdev, &on, &off);
-	read_unlock(&local->tpt_led.leddev_list_lock);
+	led_trigger_blink(&local->tpt_led, &on, &off);
 }
 
 const char *
@@ -341,7 +337,6 @@ static void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
 static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
 {
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
-	struct led_classdev *led_cdev;
 
 	if (!tpt_trig->running)
 		return;
@@ -349,10 +344,7 @@ static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
 	tpt_trig->running = false;
 	del_timer_sync(&tpt_trig->timer);
 
-	read_lock(&local->tpt_led.leddev_list_lock);
-	list_for_each_entry(led_cdev, &local->tpt_led.led_cdevs, trig_list)
-		led_set_brightness(led_cdev, LED_OFF);
-	read_unlock(&local->tpt_led.leddev_list_lock);
+	led_trigger_event(&local->tpt_led, LED_OFF);
 }
 
 void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
-- 
2.31.1

