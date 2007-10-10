Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:49661 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbXJJPfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 11:35:07 -0400
Received: by ug-out-1314.google.com with SMTP id z38so295493ugc
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 08:35:06 -0700 (PDT)
Message-ID: <d120d5000710100835s25944ccbib27f9f242b335873@mail.gmail.com> (sfid-20071010_163516_081937_C582F908)
Date: Wed, 10 Oct 2007 11:35:05 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
Cc: "John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200710101700.47574.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200709281422.34434.mb@bu3sch.de> <200710101636.36082.mb@bu3sch.de>
	 <d120d5000710100751n7b43c3cek9a50e88661fa36c6@mail.gmail.com>
	 <200710101700.47574.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Wednesday 10 October 2007 16:51:38 Dmitry Torokhov wrote:
> > > > I don't think that broadcom driver should depend on RFKILL_INPUT...
> > > > RFKILL_INPUT is a default link between input and rfkill layers but it
> > > > is by no means a mandatory component.
> > > >
> > > > I think proper dependency should be:
> > > >
> > > >         depends on B43 && RFKILL && INPUT
> > > >         select INPUT_POLLDEV
> > > >
> > >
> > > b43 rfkill support is useless without also having RFKILL_INPUT, as
> > > the button reporting is done though it.
> > > b43 does _not_ depend on RFKILL_INPUT, but b43-rfkill support is disabled,
> > > if there's no RFKILL_INPUT compiled.
> > >
> >
> > No, it is not. One can have a userspace daemon claiming the rfkill
> > switch...
>
> No, that's impossible with b43.
>

Ah, OK. I see that you added "user_claim_unsupported" to rfkill and
just rely on rfkill-input to update internal state of rfkill. I don't
think it is a good solution - userspace may issue EVIOCGRAB on
corresponding evdev node which will cause rfkill-input to miss all
events.

It looks like we need to allow rfkill-implementing drivers that do not
allow software control their RF state to change rfkill state directly.

-- 
Dmitry
