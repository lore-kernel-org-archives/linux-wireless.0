Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:56057 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750937AbZD2Nvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 09:51:46 -0400
From: Alf <alf@mypals.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Problems with ADM8211 driver
Date: Wed, 29 Apr 2009 07:51:45 -0600
References: <200904251431.02196.alf@mypals.org> <43e72e890904271303q7f4c956fv176deb6e33fe3a56@mail.gmail.com>
In-Reply-To: <43e72e890904271303q7f4c956fv176deb6e33fe3a56@mail.gmail.com>
MIME-Version: 1.0
Cc: Michael Wu <aluminum.tape@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904290751.45688.alf@mypals.org> (sfid-20090429_155152_928454_2A4E7E21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 April 2009 02:03:17 pm you wrote:
> May want to try wireless-testing

I tried it and it work for a little bit.  Here are the messages I received:

===== dmesg =====
Apr 29 06:51:54 cfg80211: Using static regulatory domain info
Apr 29 06:51:54 cfg80211: Regulatory domain: US
Apr 29 06:51:54      (start_freq - end_freq @ bandwidth), (max_antenn
a_gain, max_eirp)
Apr 29 06:51:54      (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mB
i, 2700 mBm)
Apr 29 06:51:54      (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mB
i, 2300 mBm)
Apr 29 06:51:54      (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mB
i, 2300 mBm)
Apr 29 06:51:54      (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mB
i, 2300 mBm)
Apr 29 06:51:54      (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mB
i, 2300 mBm)
Apr 29 06:51:54      (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mB
i, 3000 mBm)
Apr 29 06:51:54 cfg80211: Calling CRDA for country: US
Apr 29 06:51:54 adm8211 0000:00:07.0: PCI INT A -> GSI 18 (level, low
) -> IRQ 18
Apr 29 06:51:54 0000:00:07.0 (adm8211): Channel range: 1 - 11
Apr 29 06:51:54 0000:00:07.0 (adm8211): RFtype=1 BBPtype=1 Specific B
BP=0 Transceiver=0
Apr 29 06:51:54 phy0: Selected rate control algorithm 'minstrel'
Apr 29 06:51:54 phy0: hwaddr 00:40:05:90:3d:89, Rev 0x11
Apr 29 06:52:23 wlan0: authenticate with AP 00:30:bd:60:d3:44
Apr 29 06:52:23 wlan0: authenticated
Apr 29 06:52:23 wlan0: associate with AP 00:30:bd:60:d3:44
Apr 29 06:52:23 wlan0: RX AssocResp from 00:30:bd:60:d3:44 (capab=0x11 
status=0 aid=95)
Apr 29 06:52:23 wlan0: associated
Apr 29 06:52:23 phy0: Allocated STA 00:30:bd:60:d3:44
Apr 29 06:52:23 phy0: Inserted STA 00:30:bd:60:d3:44
Apr 29 06:53:54 phy0: Removed STA 00:30:bd:60:d3:44
Apr 29 06:53:54 phy0: Destroyed STA 00:30:bd:60:d3:44
Apr 29 06:53:56 wlan0: authenticate with AP 00:30:bd:60:d3:44
Apr 29 06:53:56 wlan0: authenticated
Apr 29 06:53:56 wlan0: associate with AP 00:30:bd:60:d3:44
Apr 29 06:53:56 wlan0: RX ReassocResp from 00:30:bd:60:d3:44 (capab=0x11 
status=0 aid=97)
Apr 29 06:53:56 wlan0: associated
Apr 29 06:53:56 phy0: Allocated STA 00:30:bd:60:d3:44
Apr 29 06:53:56 phy0: Inserted STA 00:30:bd:60:d3:44
Apr 29 07:13:39 wlan0: disassociated (Reason: 4)
Apr 29 07:13:39 phy0: Removed STA 00:30:bd:60:d3:44
Apr 29 07:13:39 phy0: Destroyed STA 00:30:bd:60:d3:44
Apr 29 07:13:40 wlan0: associate with AP 00:30:bd:60:d3:44
Apr 29 07:13:40 wlan0: deauthenticated (Reason: 9)
Apr 29 07:13:41 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
Apr 29 07:13:41 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
Apr 29 07:13:41 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
Apr 29 07:13:41 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
Apr 29 07:22:14 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
Apr 29 07:22:14 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
Apr 29 07:22:14 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
Apr 29 07:22:14 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
===== end dmesg =====

After that the card stopped working.

What I find odd are the delays in authenticating with the AP (about 30 
seconds) and when the STA is inserted to the next report (about 90 seconds).  
When the card works, it takes about 3 minutes for it to come up.

I also tried kernel 2.6.30-rc3 and that one didn't work.  So there is 
something in the wireless testing tree that fixes the situation, although 
temporarily.

> or compat-wireless to see if the
> issue is still present.

Today's snapshot of compat-wireless didn't compile with a 2.6.29.1 kernel:

 CC [M]  /home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.o
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c: In function 
'ieee80211_led_init':
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:58: error: 
invalid application of 'sizeof' to incomplete type 'struct led_trigger'
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:62: error: 
dereferencing pointer to incomplete type
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:63: error: 
implicit declaration of function 'led_trigger_register'
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:69: error: 
invalid application of 'sizeof' to incomplete type 'struct led_trigger'
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:73: error: 
dereferencing pointer to incomplete type
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:80: error: 
invalid application of 'sizeof' to incomplete type 'struct led_trigger'
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:84: error: 
dereferencing pointer to incomplete type
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:91: error: 
invalid application of 'sizeof' to incomplete type 'struct led_trigger'
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:95: error: 
dereferencing pointer to incomplete type
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c: In function 
'ieee80211_led_exit':
/home/alberto/git/compat-wireless-2009-04-29/net/mac80211/led.c:106: error: 
implicit declaration of function 'led_trigger_unregister'

> This driver is old and the maintainer is no
> longer active

That's too bad.

-- 
Alf
@


