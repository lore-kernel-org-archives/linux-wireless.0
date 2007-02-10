Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:58924 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbXBJXaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 18:30:17 -0500
Received: by ug-out-1314.google.com with SMTP id 44so267247uga
        for <linux-wireless@vger.kernel.org>; Sat, 10 Feb 2007 15:30:15 -0800 (PST)
Message-ID: <a44ae5cd0702101530j38c983bfy9c1496fd50ca8b1c@mail.gmail.com>
Date: Sat, 10 Feb 2007 18:30:14 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: RFT: The real fix for BCM4311 and BCM4312
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <45C9D9D6.2070700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <45C96B8A.8010000@lwfinger.net> <1170830071.11150.62.camel@dv>
	 <200702071443.19676.rjw@sisk.pl> <45C9D9D6.2070700@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am testing this patch applied to the wireless-net git tree.
The card is a Linksys WPC54G.  The card is still getting very
weak signal strength and the connection seems unresponsive
most of the time.

lspci shows:
Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN
Controller (rev 02)

Here is the output of "dmesg | grep bcm":

bcm43xx driver
bcm43xx: Chip ID 0x4318, rev 0x2
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0xd, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0x9, vendor 0x4243
bcm43xx: Core 2: ID 0x804, rev 0xc, vendor 0x4243
bcm43xx: Core 3: ID 0x80d, rev 0x7, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Version: 3, Type 2, Revision 7
bcm43xx: Detected Radio: ID: 8205017f (Manuf: 17f Ver: 2050 Rev: 8)
bcm43xx: Radio turned off
bcm43xx: Radio turned off
bcm43xx: PHY connected
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: Radio turned off
bcm43xx: DMA-32 0x0200 (RX) max used slots: 2/64
bcm43xx: DMA-32 0x02A0 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0280 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0260 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0240 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0220 (TX) max used slots: 2/512
bcm43xx: DMA-32 0x0200 (TX) max used slots: 0/512
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: Radio turned off
bcm43xx: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx: DMA-32 0x02A0 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0280 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0260 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0240 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0220 (TX) max used slots: 5/512
bcm43xx: DMA-32 0x0200 (TX) max used slots: 0/512
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: Radio turned off
bcm43xx: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx: DMA-32 0x02A0 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0280 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0260 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0240 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0220 (TX) max used slots: 9/512
bcm43xx: DMA-32 0x0200 (TX) max used slots: 0/512
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0

I just tried the firmware that was included with the card.  It looks
like it is an earlier revision.  The performance seems the same.
