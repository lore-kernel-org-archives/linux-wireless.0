Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48445 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZABIb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 03:31:56 -0500
Date: Fri, 2 Jan 2009 08:05:27 +0000
From: Andrew Price <andy@andrewprice.me.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: Fix radio LED type check
Message-ID: <20090102080527.GA16585@silver.sucs.org> (sfid-20090102_093159_911227_43E5A500)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 9a95dba32735534bda59def40c747bf606fedf05 "rt2x00: Fix LED
state handling", rt2x00leds_led_radio wrongly checks that the LED type
is LED_TYPE_ASSOC. This patch makes it check for LED_TYPE_RADIO once
again.

Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
---
 drivers/net/wireless/rt2x00/rt2x00leds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index 68f4e0f..a0cd35b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -97,7 +97,7 @@ void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled)
 
 void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev, bool enabled)
 {
-	if (rt2x00dev->led_radio.type == LED_TYPE_ASSOC)
+	if (rt2x00dev->led_radio.type == LED_TYPE_RADIO)
 		rt2x00led_led_simple(&rt2x00dev->led_radio, enabled);
 }
 
-- 
1.5.6.5

