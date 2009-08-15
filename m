Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38408 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZHOKEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 06:04:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] b43: Fix sparse warnings
Date: Sat, 15 Aug 2009 12:04:10 +0200
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net> <69e28c910908141404q42685aebo93718a7504020c06@mail.gmail.com> <1250285729.8137.48.camel@mj>
In-Reply-To: <1250285729.8137.48.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908151204.11024.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 23:35:29 Pavel Roskin wrote:
> On Fri, 2009-08-14 at 23:04 +0200, Gábor Stefanik wrote:
> > On Fri, Aug 14, 2009 at 11:00 PM, Michael Buesch<mb@bu3sch.de> wrote:
> > > On Friday 14 August 2009 22:52:13 Pavel Roskin wrote:
> > >> On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:
> > >>
> > >> > > -                 b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> > >> > > +                 b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
> > >> >
> > >
> > >> I would just use 0x7fff here.
> > >
> > > That does not work if 0x8000 is a #defined bit.
> > 
> > What about ~((u16)0x8000)?
> 
> phy_g.c:974: warning: large integer implicitly truncated to unsigned
> type
> 
> >  (Or maybe ~(u16)0x8000 is enough, without
> > the extra parentheses.)
> 
> Same thing.  Sparse complains whether the cast is explicit or implicit.
> 

I still do not understand why it does complain about an _explicit_ truncation.
That's simply stupid. If I program an explicit truncation I _do_ mean to truncate the value.

-- 
Greetings, Michael.
