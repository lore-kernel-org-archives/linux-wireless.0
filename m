Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46113
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXI0VRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 17:17:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] b43: RF-kill support
Date: Thu, 27 Sep 2007 23:14:16 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200709272135.35686.mb@bu3sch.de> <200709272303.57040.mb@bu3sch.de> <200709272323.45730.IvDoorn@gmail.com>
In-Reply-To: <200709272323.45730.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709272314.16401.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 September 2007 23:23:45 Ivo van Doorn wrote:
> On Thursday 27 September 2007, Michael Buesch wrote:
> > On Thursday 27 September 2007 23:12:43 Ivo van Doorn wrote:
> > > On Thursday 27 September 2007, Michael Buesch wrote:
> > > > On Thursday 27 September 2007 22:54:44 Ivo van Doorn wrote:
> > > > > Hi,
> > > > > 
> > > > > > @@ -2401,8 +2401,7 @@ static void b43_periodic_every1sec(struc
> > > > > >  	radio_hw_enable = b43_is_hw_radio_enabled(dev);
> > > > > >  	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
> > > > > >  		dev->radio_hw_enable = radio_hw_enable;
> > > > > > -		b43info(dev->wl, "Radio hardware status changed to %s\n",
> > > > > > -			radio_hw_enable ? "ENABLED" : "DISABLED");
> > > > > > +		b43_rfkill_toggled(dev, radio_hw_enable);
> > > > > 
> > > > > Isn't it better to use the input_polldev for scheduled input device checking?
> > > > > 
> > > > > > +static void b43_notify_rfkill_press(struct work_struct *work)
> > > > > > +{
> > > > > > +	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
> > > > > > +					      notify_work);
> > > > > > +	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
> > > > > > +	struct b43_wldev *dev;
> > > > > > +	enum rfkill_state state;
> > > > > 
> > > > > Same here, input_polldev was created especially for hardware
> > > > > devices that don't trigger interrupts when the button was pressed.
> > > > 
> > > > Ah, well. Will change that later. This works for now.
> > > 
> > > It might work, but this means that userspace is not made aware of
> > > the key toggling and would thus make rfkill useless in this case.
> > 
> > Yeah, sure. But it's not useless. The other functionality is still available.
> > I'll fix that. But in a seperate patch. No need to delay this one because
> > of this (IMO) minor issue.
> 
> I agree, no need to delay this patch.
> 
> But since I never added proper documentation from the start of rfkill,
> and rt2x00 did it wrong for a while as well, I just wanted to make sure you
> were aware of the correct approach. :)

Yeah, thanks. I thought this was correct.
So if it's not correct to use the "switch" API function from outside, please
remove it from the public header and put it into some private inside of
the net/rfkill directory.

-- 
Greetings Michael.
