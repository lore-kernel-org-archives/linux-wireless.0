Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42780 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYIQQPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 12:15:34 -0400
Subject: Re: [RFC/RFT] p54: Fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <48CBDF0B.5080303@lwfinger.net>
References: <48cab1e3.m0lac7LoL3DFxIu6%Larry.Finger@lwfinger.net>
	 <200809122036.03553.mb@bu3sch.de> <48CABA84.2060404@lwfinger.net>
	 <200809131440.01505.mb@bu3sch.de>  <48CBDF0B.5080303@lwfinger.net>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 12:15:31 -0400
Message-Id: <1221668131.18202.10.camel@dv> (sfid-20080917_181538_569710_8F505FD2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-09-13 at 10:40 -0500, Larry Finger wrote:
> Michael Buesch wrote:
> > On Friday 12 September 2008 20:52:52 Larry Finger wrote:
> >> No, it won't avoid any casts. The program uses the data area 7 times 
> >> in native-cpu order, once as be32, and once in little-endian order 
> > 
> > Is the native use correct? Smells fishy.
> 
> It does to me as well.

I think we should assume fixed byte order unless the hardware is
programmed differently for big-endian hosts (e.g. Atheros chipsets can
byte-swap some registers).  If the driver is working on little-endian
systems, we should assume little-endian data unless testing proves us to
be wrong.

>  I just got a copy of Intersil's data sheet for
> the MAC and everything looks little endian, but until we get a tester
> with a big-endian machine, we won't know. So far, no volunteers have
> come forward.

I have a PowerMac and a Prism54 card, so I can test.

-- 
Regards,
Pavel Roskin
