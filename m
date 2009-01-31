Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZAaOwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 09:52:30 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 003C7429B4
	for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 15:52:28 +0100 (CET)
From: Danny Kukawka <dkukawka@suse.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] rt2x00: fix led naming
Date: Sat, 31 Jan 2009 15:52:20 +0100
Cc: Helmut Schaa <hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901311552.20951.dkukawka@suse.de> (sfid-20090131_155245_336369_418C5239)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Danny Kukawka <dkukawka@suse.de>
Subject: rt2x00: fix led naming

Fixed led device naming for the rt2x00 driver. Due to the
documentation of the led subsystem/class the naming should be
"devicename:colour:function" while not applying sections
should be left blank.
    
This should lead to e.g. "%s::radio" instead of "%s:radio".

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--
 rt2x00leds.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index a0cd35b..c741d77 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -134,7 +134,7 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 		 rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
 
 	if (rt2x00dev->led_radio.flags & LED_INITIALIZED) {
-		snprintf(name, sizeof(name), "%s:radio", dev_name);
+		snprintf(name, sizeof(name), "%s::radio", dev_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_radio,
@@ -144,7 +144,7 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00dev->led_assoc.flags & LED_INITIALIZED) {
-		snprintf(name, sizeof(name), "%s:assoc", dev_name);
+		snprintf(name, sizeof(name), "%s::assoc", dev_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_assoc,
@@ -154,7 +154,7 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00dev->led_qual.flags & LED_INITIALIZED) {
-		snprintf(name, sizeof(name), "%s:quality", dev_name);
+		snprintf(name, sizeof(name), "%s::quality", dev_name);
 
 		retval = rt2x00leds_register_led(rt2x00dev,
 						 &rt2x00dev->led_qual,
-- 
Danny Kukawka
dkukawka@suse.de
R&D Team Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
