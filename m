Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39022 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZHOKID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 06:08:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] b43: Fix sparse warnings
Date: Sat, 15 Aug 2009 12:08:01 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net> <1250285371.8137.44.camel@mj> <1250286414.8137.55.camel@mj>
In-Reply-To: <1250286414.8137.55.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908151208.01349.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 23:46:54 Pavel Roskin wrote:
> On Fri, 2009-08-14 at 17:29 -0400, Pavel Roskin wrote:
> > On Fri, 2009-08-14 at 23:00 +0200, Michael Buesch wrote:
> > > On Friday 14 August 2009 22:52:13 Pavel Roskin wrote:
> > > > On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:
> > > > 
> > > > > > -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> > > > > > +			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> > > > > 
> > > 
> > > > I would just use 0x7fff here.
> > > 
> > > That does not work if 0x8000 is a #defined bit.
> > 
> > One approach would be to use a macro and tell sparse to ignore it
> > 
> > #define NEGATE(x) (__force typeof(x))(~x)
> 
> Scratch that.  It has no change to work for constants unless we hardcode
> the size, e.g. by having NEGATE16, NEGATE32 etc.
> 
> The best I could do is:
> 
> #define NEGATE16(x) (0xFFFF & ~x)
> b43_phy_mask(dev, 0x048A, NEGATE16(0x8000));

I think the real question is whether this does really prevent any bugs or whether
it just introduces new possibilities for bugs.

void my_func(u32 x);

my_func(NEGATE16(0x8000));

-- 
Greetings, Michael.
