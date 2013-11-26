Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab3KZQxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 11:53:52 -0500
Message-ID: <1385484870.7838.11.camel@dcbw.foobar.com> (sfid-20131126_175356_105077_9B3CE354)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Dan Williams <dcbw@redhat.com>
To: Troels Nilsson <nilsson.troels@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 10:54:30 -0600
In-Reply-To: <CABo8O+fRPk0GJxw-UA4wD-8fcoNF-Zqt-_DjoALpm91Oz95ZaA@mail.gmail.com>
References: <loom.20131118T143002-687@post.gmane.org>
	 <1385396191.4443.44.camel@jlt4.sipsolutions.net>
	 <1385399816.8710.16.camel@dcbw.foobar.com>
	 <1385404573.4443.58.camel@jlt4.sipsolutions.net>
	 <1385410695.26827.4.camel@dcbw.foobar.com>
	 <CABo8O+fRPk0GJxw-UA4wD-8fcoNF-Zqt-_DjoALpm91Oz95ZaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-26 at 09:24 +0100, Troels Nilsson wrote:
> > > > > > Hi,
> > > > > >
> > > > > > We are having a problem with a custom device which uses the libertas wifi
> > > > > > driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
> > > > > > specifically, whenever wpa_supplicant attempts to roam to a different access
> > > > > > point it gets a EALREADY error.
> > > > > >
> > > > > > I have tracked down the problem to this check in sme.c:
> > > > > >
> > > > > >         if (wdev->sme_state != CFG80211_SME_IDLE)
> > > > > >                 return -EALREADY;
> > > > >
> > > > > This no longer exists - please try a newer kernel.
> Yes, I saw that it was removed/rewritten in 3.11. However, that is
> quite a jump in kernel versions for us at this point, so we will
> probably prefer to patch the 3.4 series.
> 
> > > >
> > > > Yeah, though the code there hasn't changed much in cfg80211 in the
> > > > "connect" case from what he's using.  It seems that
> > > > supplicant-controlled roaming simply won't work with "connect" devices
> > > > unless a disconnect is done first?  Libertas is kinda different here
> > > > since it does allow userspace roaming control.
> > >
> > > I believe the code *does* in fact allow connect() while connected right
> > > now, though arguably that's a bug and shouldn't be done. It would make
> > > some more sense to allow NL80211_CMD_ROAM to be used for something like
> > > that, but ...
> >
> > I think you're right in the libertas case; neither nl80211_connect() or
> > cfg80211_connect() care about whether the device is associated or not.
> > I was looking at cfg80211_sme_connect(), which gets run for drivers that
> > do not implement connect() themselves, and that function *doesn't*
> > appear to allow roaming.
> >
> > So if the driver does implement connect() it can allow roaming from
> > connect() if it wants, but if the driver does not implement connect()
> > then the stack will not allow roaming from connect().  Seems a bit
> > inconsistent, so what's the best-practice for drivers here?  Disallow
> > roaming from connect() and  CMD_ROAM instead?
> >
> > We'd have to actually implement CMD_ROAM then, I guess...
> So I guess the conclusion is that there isn't currently a "correct"
> way to do roaming (until CMD_ROAM gets implemented)?

Not quite; since libertas implements connect() itself, it would appear
(on the face of things) that supplicant-directed roaming should work if
you're using a recent kernel.  Next steps are to (1) use a recent kernel
version, and (2) do something like:

rmmod usb8xxx
rmmod libertas_sdio
rmmod libertas
modprobe libertas lbs_debug=0x20043a7
modprobe libertas_sdio
modprobe usb8xxx

and then let the supplicant try to roam again, and grab the 'dmesg'
output when things fail so we can see what's going on.

Dan

