Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab3KYURk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 15:17:40 -0500
Message-ID: <1385410695.26827.4.camel@dcbw.foobar.com> (sfid-20131125_211745_273951_0B8A6000)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Troels Nilsson <nilsson.troels@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 14:18:15 -0600
In-Reply-To: <1385404573.4443.58.camel@jlt4.sipsolutions.net>
References: <loom.20131118T143002-687@post.gmane.org>
	 (sfid-20131118_145509_206573_37D8C413) <1385396191.4443.44.camel@jlt4.sipsolutions.net>
	 <1385399816.8710.16.camel@dcbw.foobar.com>
	 <1385404573.4443.58.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-25 at 19:36 +0100, Johannes Berg wrote:
> On Mon, 2013-11-25 at 11:16 -0600, Dan Williams wrote:
> > On Mon, 2013-11-25 at 17:16 +0100, Johannes Berg wrote:
> > > On Mon, 2013-11-18 at 13:50 +0000, Troels Nilsson wrote:
> > > > Hi,
> > > > 
> > > > We are having a problem with a custom device which uses the libertas wifi
> > > > driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
> > > > specifically, whenever wpa_supplicant attempts to roam to a different access
> > > > point it gets a EALREADY error.
> > > > 
> > > > I have tracked down the problem to this check in sme.c:
> > > > 
> > > >         if (wdev->sme_state != CFG80211_SME_IDLE)
> > > >                 return -EALREADY;
> > > 
> > > This no longer exists - please try a newer kernel.
> > 
> > Yeah, though the code there hasn't changed much in cfg80211 in the
> > "connect" case from what he's using.  It seems that
> > supplicant-controlled roaming simply won't work with "connect" devices
> > unless a disconnect is done first?  Libertas is kinda different here
> > since it does allow userspace roaming control.
> 
> I believe the code *does* in fact allow connect() while connected right
> now, though arguably that's a bug and shouldn't be done. It would make
> some more sense to allow NL80211_CMD_ROAM to be used for something like
> that, but ...

I think you're right in the libertas case; neither nl80211_connect() or
cfg80211_connect() care about whether the device is associated or not.
I was looking at cfg80211_sme_connect(), which gets run for drivers that
do not implement connect() themselves, and that function *doesn't*
appear to allow roaming.

So if the driver does implement connect() it can allow roaming from
connect() if it wants, but if the driver does not implement connect()
then the stack will not allow roaming from connect().  Seems a bit
inconsistent, so what's the best-practice for drivers here?  Disallow
roaming from connect() and  CMD_ROAM instead?

We'd have to actually implement CMD_ROAM then, I guess...

Dan

