Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:56222 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYKXDR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 22:17:27 -0500
Received: by ey-out-2122.google.com with SMTP id 6so739728eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 19:17:26 -0800 (PST)
Message-ID: <492A1CC5.3080702@gmail.com> (sfid-20081124_041733_556965_47CC8C92)
Date: Sun, 23 Nov 2008 22:17:25 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: mickflemm@gmail.com, mcgrof@gmail.com
Subject: [RFC][PATCH]Atheros a/b/g Frequency Support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would like to suggest modifying the ath5k code a bit to more 
accurately reflect the frequencies that the hardware supports, patch is 
as follows:

---------------------------------------------------------------------------------------------------------------------------------------

diff -Naur wireless-testing-orig/drivers/net/wireless/ath5k/caps.c 
wireless-testing/drivers/net/wireless/ath5k/caps.c
--- wireless-testing-orig/drivers/net/wireless/ath5k/caps.c     
2008-11-22 17:28:02.000000000 -0500
+++ wireless-testing/drivers/net/wireless/ath5k/caps.c  2008-11-22 
17:41:04.000000000 -0500
@@ -69,9 +69,9 @@

                if (AR5K_EEPROM_HDR_11A(ee_header)) {
                        /* 4920 */
-                       ah->ah_capabilities.cap_range.range_5ghz_min = 5005;
-                       ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
-
+                       ah->ah_capabilities.cap_range.range_5ghz_min = 4800;
+                       ah->ah_capabilities.cap_range.range_5ghz_max = 
6000; /* 6100 is what the code said but */
+                                                                            
/* it fried my Ubiquiti SRC       */
                        /* Set supported modes */
                        __set_bit(AR5K_MODE_11A,
                                        ah->ah_capabilities.cap_mode);
@@ -87,7 +87,7 @@
                if (AR5K_EEPROM_HDR_11B(ee_header) ||
                                AR5K_EEPROM_HDR_11G(ee_header)) {
                        /* 2312 */
-                       ah->ah_capabilities.cap_range.range_2ghz_min = 2412;
+                       ah->ah_capabilities.cap_range.range_2ghz_min = 
2192; /* this is the bottom of the registers */
                        ah->ah_capabilities.cap_range.range_2ghz_max = 2732;

                        if (AR5K_EEPROM_HDR_11B(ee_header))

--------------------------------------------------------------------------------------------------------------------------------------
Patch signed off by: Rick Farina

This patch modifies the top of the .11a radio DOWN from 6100 to 6000.  
This was done because after testing several cards with a spectrum 
analyzer it was found that none of the cards I could find were able to 
transmit on a frequency higher than 6000MHz and one of them (my Ubiquiti 
Super Range Cardbus) fried the pre-amp on the board (so no more 
transmit).  Please note, the original limit was set at 6100MHz and no 
where that I could find is it legal to transmit on this frequency.

Additionally the patch modifies the bottom end of the .11a radio down 
from 5005 to 4800.  Expected functionality was confirmed with several 
different cards against a spectrum analyzer.  My current personal 
version of the patch allows for the card to be set down to 4000MHz but I 
am not submitting that number yet because I have yet to confirm it 
against a spectrum analyzer (hard to borrow that kind of gear for some 
reason).  If anyone wants to test it for me I'd be glad to provide 
patches and assist.  Please note, the original limit was set at 5005MHz 
and no where that I could find is it legal to transmit at this frequency.

The maximum set for the .11b/g radio was originally set at 2732, I found 
that this was the max at which I could set the .11b/g radio.  On the 
opposite side, the lower boundary was moved from 2412 to 2192.  At 2192 
the three registers that are used to set channel are all 0, I was able 
to set lower frequencies and the registered wrapped around, I could not 
confirm functionality below 2192MHz.  The original boundary seemed to be 
clearly set by the boundary of ieee 802.11 channels, kind of funny 
because the other three boundaries were clearly not set based on ieee 
802.11 channels...

I would like this patch added to the kernel because it is a good first 
step towards establishing the fact that the driver should have the same 
support as the hardware and let crda/oldreg handle the legals.

For general reference, this patch won't actually permit tuning of 
additional channels, I will submit additional patches based on the 
responses from this one.

Thank you for your consideration.

-Rick Farina
