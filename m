Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59890
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbXJJPBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 11:01:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] b43: Use input-polldev for the rfkill switch
Date: Wed, 10 Oct 2007 17:00:47 +0200
Cc: "John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200709281422.34434.mb@bu3sch.de> <200710101636.36082.mb@bu3sch.de> <d120d5000710100751n7b43c3cek9a50e88661fa36c6@mail.gmail.com>
In-Reply-To: <d120d5000710100751n7b43c3cek9a50e88661fa36c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710101700.47574.mb@bu3sch.de> (sfid-20071010_160125_852870_00A91FD6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 October 2007 16:51:38 Dmitry Torokhov wrote:
> > > I don't think that broadcom driver should depend on RFKILL_INPUT...
> > > RFKILL_INPUT is a default link between input and rfkill layers but it
> > > is by no means a mandatory component.
> > >
> > > I think proper dependency should be:
> > >
> > >         depends on B43 && RFKILL && INPUT
> > >         select INPUT_POLLDEV
> > >
> >
> > b43 rfkill support is useless without also having RFKILL_INPUT, as
> > the button reporting is done though it.
> > b43 does _not_ depend on RFKILL_INPUT, but b43-rfkill support is disabled,
> > if there's no RFKILL_INPUT compiled.
> >
> 
> No, it is not. One can have a userspace daemon claiming the rfkill
> switch...

No, that's impossible with b43.

> We normally specify dependencies that are needed to build the code,
> not necessarily to use it. It's like various joystick drivers do not
> depend on joydev or evdev modules although most people would need
> these modules as well to use their joysticks. Or SCSI drivers don't
> depend on sd or sr being selected, etc, etc.

Yeah, well. As I said. This is not a dependency. It's an auto-select
option, which automatically selects the code.

-- 
Greetings Michael.
