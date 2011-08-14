Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:37199 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753243Ab1HNUq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 16:46:28 -0400
Date: Sun, 14 Aug 2011 21:46:26 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael =?ISO-8859-1?B?QvxzY2g=?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 error under heavy load
Message-ID: <20110814214626.4413d7cf@boulder.homenet> (sfid-20110814_224639_148751_D89EF508)
In-Reply-To: <CACna6rybejfyg+rNg9ozimHnfGh742EVsjxKZbYKvspFrQS_9w@mail.gmail.com>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
	<BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com>
	<BANLkTi=TohOdjurvgqZT8=GXKbWfNe4v+w@mail.gmail.com>
	<20110601114839.433ae42d@boulder.homenet>
	<BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
	<20110601130842.077da1c3@boulder.homenet>
	<BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com>
	<20110601160101.75e30b3d@boulder.homenet>
	<BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com>
	<20110601184931.499557c6@boulder.homenet>
	<CACna6rxH8_9pc+vZizLyAkNCLK7-CmK6GZP-E2FKUfwR9uD8Xg@mail.gmail.com>
	<CACna6rybejfyg+rNg9ozimHnfGh742EVsjxKZbYKvspFrQS_9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 14 Aug 2011 13:11:12 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/8/14 Rafał Miłecki <zajec5@gmail.com>:
> > Hey Chris,
> >
> > 2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> >> Summary: Traffic sent up from the broadcom wireless device
> >> generates copious reports of "Stopped TX ring 1" but always
> >> carries on with its job and stays up, although its traffic is
> >> slower than on received packets.  Received traffic on the other
> >> hand reports no errors until the spate of "Out of order TX status
> >> report on DMA ring 1" errors occurs, which seems to happen at
> >> random (albeit accompanied on my failed transfer by a single
> >> "Stopped TX ring 1" log entry), and when it does happen brings the
> >> wireless link to a halt. Wireless traffic can be restarted simply
> >> by reassociating with the AP.
> >
> > So it seems heavy load of RX can cause problems with TX. I just
> > though of one another reason, could you test one more thing for me?
> >
> > Edit drivers/net/wireless/b43/dma.h and change define from value 64
> > to in the line:
> > #define B43_RXRING_SLOTS                64
> 
> I meant "to 8":
> #define B43_RXRING_SLOTS                8

It is not an improvement.  Different errors occur earlier (approx 100MB
of download), upon which the wireless disassociates from the network.
dmesg produces the output at the end of this post (with MAC addresses
munged).

Chris

*****

b43-phy0 ERROR: PHY transmission error
ieee80211 phy0: wlan0: No probe response from AP 00:xx:xx:xx:xx:xx after 500ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: JP
cfg80211: Regulatory domain changed to country: JP
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
cfg80211:     (4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
cfg80211:     (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
cfg80211:     (4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
cfg80211:     (5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
cfg80211:     (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
cfg80211:     (5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
wlan0: authenticate with 00:xx:xx:xx:xx:xx (try 1)
wlan0: deauthenticating from 00:xx:xx:xx:xx:xx by local choice (reason=3)
b43-phy0 debug: Removing Interface type 2
b43-phy0 debug: Wireless interface stopped
b43-phy0 debug: DMA-64 rx_ring: Used slots 7/8, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_BK: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_BE: Used slots 102/256, Failed frames 3/84586 = 0.0%, Average tries 1.12
b43-phy0 debug: DMA-64 tx_ring_AC_VI: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_VO: Used slots 2/256, Failed frames 4/606 = 0.6%, Average tries 1.04
b43-phy0 debug: DMA-64 tx_ring_mcast: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0: Loading firmware version 508.1084 (2009-01-14 01:32:01)
b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
b43-phy0 debug: Chip initialized
b43-phy0 debug: 64-bit DMA initialized
b43-phy0 debug: QoS enabled
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with 00:xx:xx:xx:xx:xx (try 1)
wlan0: authenticated
wlan0: associate with 00:xx:xx:xx:xx:xx (try 1)
wlan0: RX AssocResp from 00:xx:xx:xx:xx:xx (capab=0x411 status=12 aid=0)
wlan0: 00:xx:xx:xx:xx:xx denied association (code=12)
wlan0: deauthenticating from 00:xx:xx:xx:xx:xx by local choice (reason=3)
wlan0: deauthenticating from 00:xx:xx:xx:xx:xx by local choice (reason=3)
b43-phy0 debug: Removing Interface type 2
b43-phy0 debug: Wireless interface stopped
b43-phy0 debug: DMA-64 rx_ring: Used slots 1/8, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_BK: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_BE: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_VI: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
b43-phy0 debug: DMA-64 tx_ring_AC_VO: Used slots 2/256, Failed frames 0/4 = 0.0%, Average tries 1.00
b43-phy0 debug: DMA-64 tx_ring_mcast: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00


