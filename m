Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:25937 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbZHNVfd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:35:33 -0400
Subject: Re: [PATCH] b43: Fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <69e28c910908141404q42685aebo93718a7504020c06@mail.gmail.com>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
	 <200908142215.38112.mb@bu3sch.de> <1250283133.8137.16.camel@mj>
	 <200908142300.01397.mb@bu3sch.de>
	 <69e28c910908141404q42685aebo93718a7504020c06@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 14 Aug 2009 17:35:29 -0400
Message-Id: <1250285729.8137.48.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-08-14 at 23:04 +0200, Gábor Stefanik wrote:
> On Fri, Aug 14, 2009 at 11:00 PM, Michael Buesch<mb@bu3sch.de> wrote:
> > On Friday 14 August 2009 22:52:13 Pavel Roskin wrote:
> >> On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:
> >>
> >> > > -                 b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> >> > > +                 b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> >> >
> >
> >> I would just use 0x7fff here.
> >
> > That does not work if 0x8000 is a #defined bit.
> 
> What about ~((u16)0x8000)?

phy_g.c:974: warning: large integer implicitly truncated to unsigned
type

>  (Or maybe ~(u16)0x8000 is enough, without
> the extra parentheses.)

Same thing.  Sparse complains whether the cast is explicit or implicit.

-- 
Regards,
Pavel Roskin
