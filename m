Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:18415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbXI0U6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 16:58:51 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2842517fkz
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 13:58:49 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] b43: RF-kill support
Date: Thu, 27 Sep 2007 23:12:43 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200709272135.35686.mb@bu3sch.de> <200709272254.44608.IvDoorn@gmail.com> <200709272241.06570.mb@bu3sch.de>
In-Reply-To: <200709272241.06570.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709272312.43994.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 September 2007, Michael Buesch wrote:
> On Thursday 27 September 2007 22:54:44 Ivo van Doorn wrote:
> > Hi,
> > 
> > > @@ -2401,8 +2401,7 @@ static void b43_periodic_every1sec(struc
> > >  	radio_hw_enable = b43_is_hw_radio_enabled(dev);
> > >  	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
> > >  		dev->radio_hw_enable = radio_hw_enable;
> > > -		b43info(dev->wl, "Radio hardware status changed to %s\n",
> > > -			radio_hw_enable ? "ENABLED" : "DISABLED");
> > > +		b43_rfkill_toggled(dev, radio_hw_enable);
> > 
> > Isn't it better to use the input_polldev for scheduled input device checking?
> > 
> > > +static void b43_notify_rfkill_press(struct work_struct *work)
> > > +{
> > > +	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
> > > +					      notify_work);
> > > +	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
> > > +	struct b43_wldev *dev;
> > > +	enum rfkill_state state;
> > 
> > Same here, input_polldev was created especially for hardware
> > devices that don't trigger interrupts when the button was pressed.
> 
> Ah, well. Will change that later. This works for now.

It might work, but this means that userspace is not made aware of
the key toggling and would thus make rfkill useless in this case.

Ivo

