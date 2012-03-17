Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:25158 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2CQXQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 19:16:58 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: IvDoorn@gmail.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] rt2x00: increase led's name buffer length
Date: Sun, 18 Mar 2012 00:16:52 +0100
Message-Id: <1332026212-5391-1-git-send-email-kubakici@wp.pl> (sfid-20120318_001702_591670_52D92962)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With 9-letter driver names phy's number was truncated
to two characters, which caused warnings when creating
sysfs entries for leds on systems with multiple devices.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00leds.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index ca585e3..8679d78 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -124,17 +124,15 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 
 void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 {
-	char dev_name[16];
-	char name[32];
+	char name[36];
 	int retval;
 	unsigned long on_period;
 	unsigned long off_period;
-
-	snprintf(dev_name, sizeof(dev_name), "%s-%s",
-		 rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
+	const char *phy_name = wiphy_name(rt2x00dev->hw->wiphy);
 
 	if (rt2x00dev->led_radio.flags & LED_INITIALIZED) {
-		snprintf(name, sizeof(name), "%s::radio", dev_name);
+		snprintf(name, sizeof(name), "%s-%s::radio",
+			 rt2x00dev->ops->name, phy_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_radio,
@@ -144,7 +142,8 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00dev->led_assoc.flags & LED_INITIALIZED) {
-		snprintf(name, sizeof(name), "%s::assoc", dev_name);
+		snprintf(name, sizeof(name), "%s-%s::assoc",
+			 rt2x00dev->ops->name, phy_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_assoc,
@@ -154,7 +153,8 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00dev->led_qual.flags & LED_INITIALIZED) {
-		snprintf(name, sizeof(name), "%s::quality", dev_name);
+		snprintf(name, sizeof(name), "%s-%s::quality",
+			 rt2x00dev->ops->name, phy_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_qual,
-- 
1.7.7.6

