Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47662 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYGIQMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 12:12:55 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KGcHf-0005W1-Tb
	for linux-wireless@vger.kernel.org; Wed, 09 Jul 2008 16:12:48 +0000
Received: from 206-248-135-194.dsl.teksavvy.com ([206.248.135.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 16:12:47 +0000
Received: from monnier by 206-248-135-194.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 16:12:47 +0000
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: Slow b43 with 2.6.25.9 on an asus wl-700ge home-router
Date: Wed, 09 Jul 2008 12:12:34 -0400
Message-ID: <jwv7ibvqci3.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org> (sfid-20080709_181259_644875_67AF0700)
References: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<4874D8DD.3020803@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What model is your card? Please post the output of 'dmesg | grep b43'.

   b43-phy0: Broadcom 4318 WLAN found
   b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
   b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
   b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
   input: b43-phy0 as /devices/virtual/input/input0
   b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
   b43-phy0 debug: Chip initialized
   b43-phy0 debug: 32-bit DMA initialized
   Registered led device: b43-phy0::radio
   b43-phy0 debug: Wireless interface started
   b43-phy0 debug: Adding Interface type 2
   b43-phy0 debug: Removing Interface type 2
   b43-phy0 debug: Wireless interface stopped
   b43-phy0 debug: DMA-32 rx_ring: Used slots 0/64, Failed frames 0/0 = 0.0%, Average tries 0.00
   b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
   b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
   b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
   b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
   b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/128, Failed frames 0/0 = 0.0%, Average tries 0.00
   input: b43-phy0 as /devices/virtual/input/input1
   b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
   b43-phy0 debug: Chip initialized
   b43-phy0 debug: 32-bit DMA initialized
   Registered led device: b43-phy0::radio
   b43-phy0 debug: Wireless interface started
   b43-phy0 debug: Adding Interface type 2

> With the current versions of mac80211, the rate-setting mechanism is very
> good. If you force a high rate, i.e. with 'iwconfig ... 54M', you run the
> risk of increasing your error rate causing many more retransmits, and might
> reduce the throughput.

Yes, that's what I'd expect.  I only did it to see if it made any
difference, and as a matter of fact, it makes no difference: I get the
same 90-92 KB/s on average (averaged over a 3.6MB http transfer).

> That may not be happening here, but I wonder why the
> rate capped at 2M. Incidentally, the quality numbers for my BCM4312 located
> about 2m from the AP are "Link Quality=93/100  Signal level:-37 dBm  Noise
> level=-71 dBm". My Link Quality is lower than yours, but S/N is much
> better - not that any of those numbers have much validity.

I've moved the machine to get a better signal, it now says:

wlan0     IEEE 802.11  ESSID:"MM"  
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:18:3F:CB:5A:59   
          Bit Rate=2 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:ADAD-D31C-F6E7-1781-F165-21F0-A155-44C2-03C4-0D43-167C-05E8-C6EE-B111-1125-F1CD [2]
          Link Quality=114/100  Signal level:-41 dBm  Noise level=-64 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I.e. it's not just better: it's more than perfect ;-)
But the bandwidth is still the same 90-92KB/s.

> My transmit throughput is consistently over 2 Mbs,

All the other wireless clients I've used around here (other
broadcomm-based home routers, rt73usb dongles, and iwl3945, hostap,
madwifi laptops), I basically always get pretty much the same bandwidth,
of around 10Mb/s, so there's definitely something odd going on here.

> but I'm not bridging.  Roughly 6 months ago, I did set up routing, but
> that was using iptables, not a formal bridge device. That
> configuration had full speed.

As mentioned, I get the same result without bridging.

> If you shut down the bridge, what speed do you get?

Same old 90-92KB/s.


        Stefan


PS: The code I use is the one from the OpenWRT svn repository.

