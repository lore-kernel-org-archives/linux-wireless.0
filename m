Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:35900 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3KZIYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 03:24:21 -0500
Received: by mail-oa0-f45.google.com with SMTP id o6so5610650oag.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 00:24:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385410695.26827.4.camel@dcbw.foobar.com>
References: <loom.20131118T143002-687@post.gmane.org>
	<1385396191.4443.44.camel@jlt4.sipsolutions.net>
	<1385399816.8710.16.camel@dcbw.foobar.com>
	<1385404573.4443.58.camel@jlt4.sipsolutions.net>
	<1385410695.26827.4.camel@dcbw.foobar.com>
Date: Tue, 26 Nov 2013 09:24:20 +0100
Message-ID: <CABo8O+fRPk0GJxw-UA4wD-8fcoNF-Zqt-_DjoALpm91Oz95ZaA@mail.gmail.com> (sfid-20131126_092425_007075_0C9A6954)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Troels Nilsson <nilsson.troels@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > > Hi,
> > > > >
> > > > > We are having a problem with a custom device which uses the libertas wifi
> > > > > driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
> > > > > specifically, whenever wpa_supplicant attempts to roam to a different access
> > > > > point it gets a EALREADY error.
> > > > >
> > > > > I have tracked down the problem to this check in sme.c:
> > > > >
> > > > >         if (wdev->sme_state != CFG80211_SME_IDLE)
> > > > >                 return -EALREADY;
> > > >
> > > > This no longer exists - please try a newer kernel.
Yes, I saw that it was removed/rewritten in 3.11. However, that is
quite a jump in kernel versions for us at this point, so we will
probably prefer to patch the 3.4 series.

> > >
> > > Yeah, though the code there hasn't changed much in cfg80211 in the
> > > "connect" case from what he's using.  It seems that
> > > supplicant-controlled roaming simply won't work with "connect" devices
> > > unless a disconnect is done first?  Libertas is kinda different here
> > > since it does allow userspace roaming control.
> >
> > I believe the code *does* in fact allow connect() while connected right
> > now, though arguably that's a bug and shouldn't be done. It would make
> > some more sense to allow NL80211_CMD_ROAM to be used for something like
> > that, but ...
>
> I think you're right in the libertas case; neither nl80211_connect() or
> cfg80211_connect() care about whether the device is associated or not.
> I was looking at cfg80211_sme_connect(), which gets run for drivers that
> do not implement connect() themselves, and that function *doesn't*
> appear to allow roaming.
>
> So if the driver does implement connect() it can allow roaming from
> connect() if it wants, but if the driver does not implement connect()
> then the stack will not allow roaming from connect().  Seems a bit
> inconsistent, so what's the best-practice for drivers here?  Disallow
> roaming from connect() and  CMD_ROAM instead?
>
> We'd have to actually implement CMD_ROAM then, I guess...
So I guess the conclusion is that there isn't currently a "correct"
way to do roaming (until CMD_ROAM gets implemented)?

In that case we will go with patching the check to only fail with
-EALREADY in the case where sme_state is CFG80211_SME_CONNECTING,
since that means roaming works with libertas.
