Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43721 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZHNV3f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:29:35 -0400
Subject: Re: [PATCH] b43: Fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200908142300.01397.mb@bu3sch.de>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
	 <200908142215.38112.mb@bu3sch.de> <1250283133.8137.16.camel@mj>
	 <200908142300.01397.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 17:29:31 -0400
Message-Id: <1250285371.8137.44.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-08-14 at 23:00 +0200, Michael Buesch wrote:
> On Friday 14 August 2009 22:52:13 Pavel Roskin wrote:
> > On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:
> > 
> > > > -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> > > > +			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> > > 
> 
> > I would just use 0x7fff here.
> 
> That does not work if 0x8000 is a #defined bit.

One approach would be to use a macro and tell sparse to ignore it

#define NEGATE(x) (__force typeof(x))(~x)

Another approach would be to have b43_phy_mask() and similar functions
accept int and do the bit cutting in one place.

It should also be possible to have separate functions e.g.
b43_phy_unmask() that would do the negation, so that the caller won't
need to do it.

-- 
Regards,
Pavel Roskin
