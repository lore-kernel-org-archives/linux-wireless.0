Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59618 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZKFRsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 12:48:23 -0500
Received: by bwz27 with SMTP id 27so1423588bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 09:48:27 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: James Grossmann <cctsurf@gmail.com>
Subject: Re: Prism54/p54pci
Date: Fri, 6 Nov 2009 18:48:21 +0100
Cc: linux-wireless@vger.kernel.org
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com> <200911021611.37354.chunkeey@googlemail.com> <167ae39b0911060900i2c8f4a78w4edecdcec36f1a38@mail.gmail.com>
In-Reply-To: <167ae39b0911060900i2c8f4a78w4edecdcec36f1a38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911061848.21681.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 18:00:54 James Grossmann wrote:
> It connects up with the patch!
> I'll attach a dmesg for any info you might be able to glean from that.
>  THANKS!

it's a start, but there are some serious implications.

but first: what is your signal (dBm) reading (iwconfig / iw dev wlanX info)?

I'm asking this because your device is only fine-tunable for
channel 1, 7, 13 & 14 with the current data points.

some performance figures would be nice as well.
e.g.: iperf (tcp) should be > 18Mbit/s,
      if you are close & free line of sight

second: what should we do about these devices?

Surely, the best thing would be to simply reprogram the eeprom,
but this (being complicated work) requires soldering skills/tools,
a steady hand and enough boredom. Therefor this is likely the least
ideal option to put into the WIKI @ wireless.kernel.org .
Any suitable ideas?

Regards,
	Chr

---
> [ 5593.622225] cfg80211: Calling CRDA to update world regulatory
> domain
> [ 5593.756965] p54pci 0000:03:00.0: PCI INT A -> Link[LNKA] -> GSI 11
> (level, low) -> IRQ 11
> [ 5593.757087] p54pci 0000:03:00.0: firmware: requesting isl3886pci
> [ 5593.799682] cfg80211: World regulatory domain updated:
> [ 5593.799693]  (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 5593.799701]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [ 5593.799708]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [ 5593.799714]  (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [ 5593.799721]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 5593.799728]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 5593.826106] phy0: p54 detected a LM86 firmware
> [ 5593.826115] p54: rx_mtu reduced from 3240 to 2376
> [ 5593.826121] phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> [ 5593.826127] phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> [ 5593.943095] phy0: hwaddr 00:xx:xx:xx:xx:xx, MAC:isl3880 RF:Frisbee
>
> [ 5593.943532] phy0: Selected rate control algorithm 'minstrel'
> [ 5593.945386] Registered led device: p54-phy0::assoc
> [ 5593.945426] Registered led device: p54-phy0::tx
> [ 5593.945466] Registered led device: p54-phy0::rx
> [ 5593.945507] Registered led device: p54-phy0::radio
> [ 5593.945521] p54pci 0000:03:00.0: is registered as 'phy0'
> [ 5593.973148] udev: renamed network interface wlan0 to wlan1
> [ 5594.105670] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 5601.380939] wlan1: deauthenticating from 00:xx:xx:xx:xx:xx by local
> choice (reason=3)
> [ 5601.381046] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx (try 1)
> [ 5601.385723] wlan1: direct probe responded
> [ 5601.385738] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx (try 1)
> [ 5601.387961] wlan1: authenticated
> [ 5601.388049] wlan1: associate with AP 00:xx:xx:xx:xx:xx (try 1)
> [ 5601.390237] wlan1: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x401
> status=0 aid=2)
> [ 5601.390246] wlan1: associated
> [ 5601.391891] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [ 5612.024163] wlan1: no IPv6 routers present
> 
