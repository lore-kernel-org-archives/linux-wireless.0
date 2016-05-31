Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcEaNOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:14:51 -0400
Message-ID: <1464700487.3076.28.camel@sipsolutions.net> (sfid-20160531_151455_160036_A2B32282)
Subject: Re: [PATCH iw] add "channels" PHY command listing frequencies with
 more details
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 31 May 2016 15:14:47 +0200
In-Reply-To: <CACna6rw--bPNdWcp1Bx1GOKv9cnOgfr5D_YU1RF7A8CS_Bt7Vg@mail.gmail.com> (sfid-20160531_151009_650354_316F309E)
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
	 <1464689804.3076.13.camel@sipsolutions.net>
	 <CACna6rw--bPNdWcp1Bx1GOKv9cnOgfr5D_YU1RF7A8CS_Bt7Vg@mail.gmail.com>
	 (sfid-20160531_151009_650354_316F309E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-31 at 15:10 +0200, Rafał Miłecki wrote:

> > Unfortunately, I get compiler warnings about width_* being possibly
> > used uninitialized. Can you address that please?
> It's nice your compiled got this mistake, my didn't. There were
> actually meant to be static. I'll fix that.

I actually think the compiler is wrong, and there's no reason for them
to be static, is there?

The first iteration of the loop should always initialize since -1 is
used for initialization?

In any case, I'd prefer to avoid static, if necessary pass some kind of
context structure in to the function?

> > > +TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_PHY,
> > > handle_channels, "Show available channels.");
> > Maybe that should be allowed for a CIB_DEV too?
> Since this is PHY specific, I was thinking it should be CIB_PHY. I
> didn't see reason to allow querying devices. Similarly we don't
> support "iw dev wlan0 reg get".
> 
> Anyway, I can change that if you think it's better for some reason.

I was just thinking that supporting it with wlan0 would in certain
cases make it easier for the user (not having to look up the phy
number)

> Any hint how to make command usable with both: phy and dev?

Just add:

TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_NETDEV, ...);

johannes
