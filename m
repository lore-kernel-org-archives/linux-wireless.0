Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZAaOw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 09:52:26 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 9561C466AA
	for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 15:52:24 +0100 (CET)
From: Danny Kukawka <dkukawka@suse.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] b43legacy: fix led naming
Date: Sat, 31 Jan 2009 15:52:16 +0100
Cc: Helmut Schaa <hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901311552.16582.dkukawka@suse.de> (sfid-20090131_155245_092613_DBD176FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Danny Kukawka <dkukawka@suse.de>
Subject: b43legacy: fix led naming

Fixed led device naming for the b43legacy driver. Due to the
documentation of the led subsystem/class the naming should be
"devicename:colour:function" while not applying sections
should be left blank.
    
This should lead to e.g. "b43legacy-%s::rx" instead of 
"b43legacy-%s:rx".

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--
 leds.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/leds.c b/drivers/net/wireless/b43legacy/leds.c
index cacb786..cb4511f 100644
--- a/drivers/net/wireless/b43legacy/leds.c
+++ b/drivers/net/wireless/b43legacy/leds.c
@@ -146,12 +146,12 @@ static void b43legacy_map_led(struct b43legacy_wldev *dev,
 	case B43legacy_LED_TRANSFER:
 	case B43legacy_LED_APTRANSFER:
 		snprintf(name, sizeof(name),
-			 "b43legacy-%s:tx", wiphy_name(hw->wiphy));
+			 "b43legacy-%s::tx", wiphy_name(hw->wiphy));
 		b43legacy_register_led(dev, &dev->led_tx, name,
 				 ieee80211_get_tx_led_name(hw),
 				 led_index, activelow);
 		snprintf(name, sizeof(name),
-			 "b43legacy-%s:rx", wiphy_name(hw->wiphy));
+			 "b43legacy-%s::rx", wiphy_name(hw->wiphy));
 		b43legacy_register_led(dev, &dev->led_rx, name,
 				 ieee80211_get_rx_led_name(hw),
 				 led_index, activelow);
@@ -161,7 +161,7 @@ static void b43legacy_map_led(struct b43legacy_wldev *dev,
 	case B43legacy_LED_RADIO_B:
 	case B43legacy_LED_MODE_BG:
 		snprintf(name, sizeof(name),
-			 "b43legacy-%s:radio", wiphy_name(hw->wiphy));
+			 "b43legacy-%s::radio", wiphy_name(hw->wiphy));
 		b43legacy_register_led(dev, &dev->led_radio, name,
 				 b43legacy_rfkill_led_name(dev),
 				 led_index, activelow);
@@ -172,7 +172,7 @@ static void b43legacy_map_led(struct b43legacy_wldev *dev,
 	case B43legacy_LED_WEIRD:
 	case B43legacy_LED_ASSOC:
 		snprintf(name, sizeof(name),
-			 "b43legacy-%s:assoc", wiphy_name(hw->wiphy));
+			 "b43legacy-%s::assoc", wiphy_name(hw->wiphy));
 		b43legacy_register_led(dev, &dev->led_assoc, name,
 				 ieee80211_get_assoc_led_name(hw),
 				 led_index, activelow);

-- 
Danny Kukawka
dkukawka@suse.de
R&D Team Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
