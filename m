Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47966 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbXHaXzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 19:55:42 -0400
Subject: Re: b43legacy woes
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: david@identd.dyndns.org, wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <46D8957D.2010705@lwfinger.net>
References: <BAY128-W312E506592CDC1EF65AF0C86CE0@phx.gbl>
	 <46D8957D.2010705@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 01 Sep 2007 00:55:35 +0100
Message-Id: <1188604535.985.277.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-31 at 17:26 -0500, Larry Finger wrote:
> The poor performance of the BCM4306/2 (your chip/card) is known. Ther=
e has been a report that this=20
> is a regression since 2.6.20, or so, has not been confirmed. With a 2=
=2E6.21 kernel, I got an iperf=20
> transmit rate of 4 Mbs, but that quickly dropped to 0.3 Mbs without m=
e changing anything - I just=20
> repeated the iperf command.=20

That reminds me... I accidentally invented a new wireless test. It's
intended to stream the full OS images to OLPC laptops on the production
line, and does so by multicast -- so there are no link-layer ACKs and
retries compensating for your packet loss; it all gets reported.

It's in git://git.infradead.org/mtd-utils.git; the tools are recv_image
and serve_image.

usage: recv_image <host> <port> <mtddev>
usage: serve_image <host> <port> <image> <erasesize> [<tx_rate>]

A $ dd if=3D/dev/urandom of=3Dtestfile bs=3D131072 count=3D50
A $ ./serve_image ff0f::114 12345 testfile 131072 85
	Inter-packet delay (avg): 32858=C2=B5s
	Transmit rate: 85 KiB/s
	Checking CRC....85a0d369
	Checking block CRCS.... 50/50
	Image size 6400 KiB (0x00640000). 50 blocks at 47 pkts/block
	Estimated transmit time per cycle: 77s
	Sending data block 004e0000 packet  15/70    (85 KiB/s)   =20


B $ ./recv_image ff0f::114 12345 foo
	MEMGETINFO: Inappropriate ioctl for device
	Receive to file bar with (assumed) erasesize 131072
	Received 750/2350 (31%) in 25s @82KiB/s, 6 lost (0%), 0 dup/xs =20

You can use it unicast too, and/or with Legacy IP instead of IPv6.

If your AP sends all multicast at 1Mb/s, then 85 KiB/s is about all
you'll get. If you can configure the Basic Rate set not to include the
slower speeds, or if you can change the multicast rate (which could
actually be _any_ rate in the Basic Rate set), then you can go faster.
I find it works quite nicely at 24Mb/s.

--=20
dwmw2

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
