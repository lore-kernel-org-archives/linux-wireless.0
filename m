Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:51720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYJ3Wlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 18:41:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Orinoco-devel] 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Date: Thu, 30 Oct 2008 23:46:10 +0100
Cc: Dave <kilroyd@googlemail.com>, linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>
References: <200810282219.51492.arvidjaar@mail.ru> <4909F9BC.3050306@gmail.com> <200810302139.37864.arvidjaar@mail.ru>
In-Reply-To: <200810302139.37864.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810302346.11547.rjw@sisk.pl> (sfid-20081030_234152_948202_A8783352)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, 30 of October 2008, Andrey Borzenkov wrote:
> On Thursday 30 October 2008, Dave wrote:
> > After much faffing about, I managed to bisect this. In retrospect the
> > above hint (thanks Russell) and a code inspection ought to have made the
> > bug obvious. The offending commit is:
> > 
> > commit 1168386aa7d850ead2ae135d5a7949a592c6e9a0
> > pcmcia: deprecate CS_OUT_OF_RESOURCE
> > 
> > in which the following change is made (among others):
> > 
> > @@ -352,7 +352,9 @@ int verify_cis_cache(struct pcmcia_socket *s)
> > 
> >         buf = kmalloc(256, GFP_KERNEL);
> >         if (buf == NULL)
> > -               return -1;
> > +               dev_printk(KERN_WARNING, &s->dev,
> > +                          "no memory for verifying CIS\n");
> > +               return -ENOMEM;
> >         list_for_each_entry(cis, &s->cis_cache, node) {
> >                 int len = cis->len;
> > 
> 
> Oh, my ... I have been looking over this dozens of times ... it just
> proves how addictive to bisecting in place of proper debugging we became :(

Bisection is one of debugging techiques and it's as much "proper" as any other
one of them IMO.

> Dave, thank you!
> 
> Rafael, this falls in obvious "regression with patches" case I think.

Yes, I added it as http://bugzilla.kernel.org/show_bug.cgi?id=11911 .

Thanks,
Rafael
