Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:58591 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764063AbYCSVFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 17:05:46 -0400
Date: Wed, 19 Mar 2008 11:00:53 +0100 (CET)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: linux-wireless@vger.kernel.org
cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	julian.calaby@gmail.com, david@woodhou.se, dwmw2@infradead.org,
	andreamrl@tiscali.it
Subject: Marvell 88w8335 [Libertas]
Message-ID: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de> (sfid-20080319_210623_129378_7B284F29)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am trying to use the WLAN part of an Option Fusion+ UMTS and WLAN card. 
UMTS is working fine, WLAN works OK with ndiswrapper. Seen the emails on 
infradead and linuxwireless from 2007 and beginning of March, I was trying 
to get it natively supported.

I modified the mac80211 port of mrv8k from 
http://david.woodhou.se/mrv.tar.gz so that it compiles against 2.6.24 
Debian kernel.

It is available here:
https://www.comnets.uni-bremen.de/~mab/mrv8k/mrv8kng-mab.tgz

The firmware I am using is extracted from Mrvw123.sys from the CD of the 
UMTS/WLAN card using mrv8k_extract_fw.

The module loads (does not bail out in the interrupt handler) and 
creates the devices:

Mar 19 09:55:07 shelbyville kernel: d80211 Marvell Libertas PCI driver
Mar 19 09:55:07 shelbyville kernel: Andrea Merello <andreamrl *at* tiscali.it>
Mar 19 09:55:20 shelbyville kernel: pccard: CardBus card inserted into slot 0
Mar 19 09:55:20 shelbyville kernel: PCI: Enabling device 0000:16:00.0 (0000 -> 0002)
Mar 19 09:55:20 shelbyville kernel: ACPI: PCI Interrupt 0000:16:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Mar 19 09:55:20 shelbyville kernel: PCI: Setting latency timer of device 0000:16:00.0 to 64
Mar 19 09:55:20 shelbyville kernel: Bootstrap loaded OK, jumping in..
Mar 19 09:55:22 shelbyville kernel: Firmware load successfully
Mar 19 09:55:22 shelbyville kernel: Card mac address is xx:xx:xx:xx:xx:xx
Mar 19 09:55:22 shelbyville kernel: Fw V 3020007, Hw V 3, Anennas: 2, Region code 48
Mar 19 09:55:22 shelbyville kernel: phy7: Selected rate control algorithm 'simple'
[Snipped out nozomi UMTS driver.]

It is not yet fully working, however. The card does not seem to react on 
the scanning/set_channel commands:

Mar 19 09:55:48 shelbyville kernel: Command timeout
Mar 19 09:55:48 shelbyville kernel: Could not set channel
Mar 19 09:55:48 shelbyville kernel: Failed to set channel
Mar 19 09:55:48 shelbyville kernel: wlan1: failed to set channel 2 (2417 MHz) for scan
Mar 19 09:55:50 shelbyville kernel: Command timeout
Mar 19 09:55:50 shelbyville kernel: Could not set channel
Mar 19 09:55:50 shelbyville kernel: Failed to set channel
Mar 19 09:55:50 shelbyville kernel: wlan1: failed to set channel 3 (2422 MHz) for scan
[...]

If someone is interested in helping (I am not very familiar with linux 
wireless development), please contact me.

Best regards,
Markus

------------------------------------------------
| Dipl.-Ing. Markus Becker
| Communication Networks
| Mobile Research Center
| TZI - Center for Computing Technologies
| University Bremen
| Germany
------------------------------------------------
| web: http://www.comnets.uni-bremen.de/~mab/
| mailto: mab@comnets.uni-bremen.de
| telephone: +49 421 218 2287
| building: NW1 room: N2260
------------------------------------------------
