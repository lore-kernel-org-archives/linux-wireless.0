Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58063
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbXJJOhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:37:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
Date: Wed, 10 Oct 2007 16:36:35 +0200
Cc: "John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200709281422.34434.mb@bu3sch.de> <d120d5000710100730j243247e1te570ff57522693eb@mail.gmail.com>
In-Reply-To: <d120d5000710100730j243247e1te570ff57522693eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710101636.36082.mb@bu3sch.de> (sfid-20071010_153723_433661_862A91C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 October 2007 16:30:35 Dmitry Torokhov wrote:
> Hi Michael,
> 
> On 9/28/07, Michael Buesch <mb@bu3sch.de> wrote:
> > This removes the direct call to rfkill on an rfkill event
> > and replaces it with an input device. This way userspace is also
> > notified about the event.
> >
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >
> > Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
> > ===================================================================
> > --- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig  2007-09-27 21:31:15.000000000 +0200
> > +++ wireless-2.6/drivers/net/wireless/b43/Kconfig       2007-09-28 12:34:23.000000000 +0200
> > @@ -70,7 +70,7 @@ config B43_LEDS
> >  # RFKILL support
> >  config B43_RFKILL
> >        bool
> > -       depends on B43 && RFKILL
> > +       depends on B43 && RFKILL && RFKILL_INPUT && INPUT_POLLDEV
> >        default y
> 
> I don't think that broadcom driver should depend on RFKILL_INPUT...
> RFKILL_INPUT is a default link between input and rfkill layers but it
> is by no means a mandatory component.
> 
> I think proper dependency should be:
> 
>         depends on B43 && RFKILL && INPUT
>         select INPUT_POLLDEV
> 

b43 rfkill support is useless without also having RFKILL_INPUT, as
the button reporting is done though it.
b43 does _not_ depend on RFKILL_INPUT, but b43-rfkill support is disabled,
if there's no RFKILL_INPUT compiled.

-- 
Greetings Michael.
