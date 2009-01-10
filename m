Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49537 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZAJKHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 05:07:55 -0500
Received: from welshbyte by silver.sucs.swan.ac.uk with local (Exim 4.62)
	(envelope-from <welshbyte@sucs.org>)
	id 1LLaky-00086z-2B
	for linux-wireless@vger.kernel.org; Sat, 10 Jan 2009 10:07:52 +0000
Date: Sat, 10 Jan 2009 10:07:52 +0000
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-wireless@vger.kernel.org
Subject: [RFC] rt2500pci: turn on led_qual for default LED mode
Message-ID: <20090110100751.GA29761@silver.sucs.org> (sfid-20090110_110759_846980_977777A3)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a check for LED_MODE_DEFAULT so that we initialise the link LED.

Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
---

I'm submitting this patch just as an RFC as I have no idea whether it works
with all rt2500pci devices. With my card, value holds 0 after the call to
rt2x00_get_field16() and so the added check for LED_MODE_DEFAULT (which is 0)
is needed for the link LED to work.

My card is a "RaLink RT2500 802.11g Cardbus/mini-PCI [1814:0201]" Belkin
F5D7010 according to lspci.

Any advice would be much appreciated. Does this patch look reasonable? Are
there any docs/specs which I could read to learn how this should be handled?

P.S. This is not related to my previous LED patch. This one is for the other
LED which has never worked as far as I can remember, until now :-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d3bc218..651cb4f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1524,7 +1524,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_radio, LED_TYPE_RADIO);
-	if (value == LED_MODE_TXRX_ACTIVITY)
+	if (value == LED_MODE_TXRX_ACTIVITY || value == LED_MODE_DEFAULT)
 		rt2500pci_init_led(rt2x00dev, &rt2x00dev->led_qual,
 				   LED_TYPE_ACTIVITY);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
-- 
1.5.6.5

