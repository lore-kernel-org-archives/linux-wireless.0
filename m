Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:50191 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161483AbXDLCXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 22:23:50 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1Hbow7-0001bt-Dc
	for linux-wireless@vger.kernel.org; Wed, 11 Apr 2007 22:21:23 -0400
Subject: Re: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20070412012051.GC3473@tuxdriver.com>
References: <200704111901.06403.flamingice@sourmilk.net>
	 <20070412012051.GC3473@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 22:23:43 -0400
Message-Id: <1176344623.21564.46.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-04-11 at 21:20 -0400, John W. Linville wrote:
> On Wed, Apr 11, 2007 at 07:01:06PM -0400, Michael Wu wrote:
> > bcm43xx: Hide if bcm43xx-mac80211 is builtin
> > 
> > From: Michael Wu <flamingice@sourmilk.net>
> > 
> > This prevents users from compiling bcm43xx (softmac) and bcm43xx-mac80211
> > into the kernel at the same time. In the case that it is attempted, make
> > bcm43xx (softmac) not build.
> 
> Since the two drivers use different firmware and the (currently)
> softmac-based driver will evolve into bcm4301 with support for older
> hardware, I'd prefer to leave this one out.

It's possible to bind and unbind drivers, so having two drivers for the
same hardware is not a problem per se.

The problem is that such configuration won't compile as it stands now.
It can be fixed by massive renaming of the symbols in one of the
drivers, but I'm not sure we settled on a specific name.  I suggested
bcm4301, which was well received, but it sound like it won't happen
until bcm43xx_mac80211 matures.

If "bcm4301" prefix is too confusing or "humiliating" for the
softmac-based driver, we could consider something more acceptable in the
short term, like bcm4k, broadcom, bcom, brcm (Broadcom's stock ticker),
bcm43sm (after softmac), bcmwifi, bcmw, bcw (just to amuse Theo) and so
on.

If the symbols are not renamed, we need some protection in Kconfig, or
we'll fail "make allyesconfig".

-- 
Regards,
Pavel Roskin

