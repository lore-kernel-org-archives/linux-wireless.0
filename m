Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38002 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3EEUGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 16:06:18 -0400
Received: by mail-lb0-f169.google.com with SMTP id z5so2860747lbh.14
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 13:06:17 -0700 (PDT)
Date: Sun, 5 May 2013 22:06:14 +0200 (CEST)
From: Thommy Jakobsson <thommyj@gmail.com>
To: =?ISO-8859-15?Q?Michael_B=FCsch?= <m@bues.ch>
cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, piotras@gmail.com,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
In-Reply-To: <20130505215800.65ae7aea@milhouse>
Message-ID: <alpine.DEB.2.02.1305052201110.1469@kelly.ryd.net> (sfid-20130505_220630_360159_8DF4A333)
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> <CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com> <CACna6ry+F45PhCXahPpJtzu-w+vLE29ksHo9njXfTcfY3Av6LA@mail.gmail.com>
 <20130505192405.0cf4350e@milhouse> <CACna6rz+PsN1GyniJL7JZJmb7T6Fnk_g101M8DeePr29LsAXaA@mail.gmail.com> <20130505215800.65ae7aea@milhouse>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sun, 5 May 2013, Michael B?sch wrote:

> On Sun, 5 May 2013 21:50:33 +0200
> Rafa? Mi?ecki <zajec5@gmail.com> wrote:
> 
> > 2013/5/5 Michael B?sch <m@bues.ch>:
> > > On Sun, 5 May 2013 18:31:20 +0200
> > > Rafa? Mi?ecki <zajec5@gmail.com> wrote:
> > >
> > >> Still worth considering is my previous e-mail. Why writing (for
> > >> example) 1 to RXSTOPINDEX doesn't stop firmware from using slot 1?
> > >
> > > What makes you think this register does not work?
> > 
> > Take a look at this:
> > 
> > [  327.224976] [DBG] old current:5      new current:6
> > [  327.224982] [DBG] reading slot 5
> > [  327.224997] [DBG] writing stop slot 6
> > 
> > In above ring->slot was 5, but IRQ was generated, and we read new
> > "current" using get_current_rxslot. It appeared to be 6. So we read
> > packet from slot 5 and then called
> > ops->set_current_rxslot(ring, 6);
> > AFAIU hardware shouldn't use slot 6, right? But take a look at what
> > happens next:
> > 
> > [  327.319582] [DBG] old current:6      new current:7
> > [  327.319590] [DBG] reading slot 6
> > [  327.319619] [DBG] writing stop slot 7
> > 
> > Hardware generated IRQ and we get_current_rxslot returned 7. It means
> > we're allowed to read slots up to 7 (excluding). It other words it
> > means firmware used slot 6... but 100ms earlier we forbid firmware to
> > use slot 6!
> 
> I'd rather say that this is a race condition between your testing code
> and the firmware.
If I understood Rafael this is the normal rx-code (with some 
printouts). When you use set_current_rxslot you dont forbid the hardware 
to use slot 6, you say that the last slot that you can use is 5.So the 
firmware actually checks if we step from 5 to 6, not if the slot is 6.

//Thommy
