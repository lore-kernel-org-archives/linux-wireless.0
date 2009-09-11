Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:53889 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbZIKM2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 08:28:13 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Questions about regulatory domain & passive scanning
Date: Fri, 11 Sep 2009 14:27:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909111427.39974.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

I'm playing with regulatory domain using wireless-testing, iw, 
crda and ath5 on Debian. Here are some observations:

1) Debian sucks here (while it's otherwise great!). No
   wireless-regdb, wireless-crda packages, not even in
   experimental. Maybe I need to add some Ubuntu repository
   as "deb-src" to my apt sources.list, apt-get source that
   stuff and recompile it manually.

2) I remove CONFIG_WIRELESS_OLD_REGULATORY. Then, after inserting
   the card, I see in "iw list":

         * 2412 MHz [1] (20.0 dBm)
         * 2417 MHz [2] (20.0 dBm)
         * 2422 MHz [3] (20.0 dBm)
         * 2427 MHz [4] (20.0 dBm)
         * 2432 MHz [5] (20.0 dBm)
         * 2437 MHz [6] (20.0 dBm)
         * 2442 MHz [7] (20.0 dBm)
         * 2447 MHz [8] (20.0 dBm)
         * 2452 MHz [9] (20.0 dBm)
         * 2457 MHz [10] (20.0 dBm)
         * 2462 MHz [11] (20.0 dBm)
         * 2467 MHz [12] (20.0 dBm) (passive scanning)
         * 2472 MHz [13] (20.0 dBm) (passive scanning)
         * 2484 MHz [14] (20.0 dBm) (passive scanning)

   I'd like to highlight the "passive scanning". Is this info
   from the card EEPROM?

3) After "iw reg set DE" (for germany), it's now

          2412 MHz [1] (20.0 dBm)
          2417 MHz [2] (20.0 dBm)
          2422 MHz [3] (20.0 dBm)
          2427 MHz [4] (20.0 dBm)
          2432 MHz [5] (20.0 dBm)
          2437 MHz [6] (20.0 dBm)
          2442 MHz [7] (20.0 dBm)
          2447 MHz [8] (20.0 dBm)
          2452 MHz [9] (20.0 dBm)
          2457 MHz [10] (20.0 dBm)
          2462 MHz [11] (20.0 dBm)
          2467 MHz [12] (20.0 dBm) (passive scanning)
          2472 MHz [13] (20.0 dBm) (passive scanning)
          2484 MHz [14] (disabled)

   Great, CRDA worked obviously: channel 14 has been disabled.

   And, as I understand it, CRDA can just limit settings
   further, not widening it. Therefore channels 12 and 13
   are still marked as "passive scanning".

   If I want to get them to "active scanning", would I need to
   modify the EEPROM of the card?  ath_info says "Reg. Domain:
   0x60".


-- 
http://www.holgerschurig.de
