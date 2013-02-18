Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3BRLNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 06:13:20 -0500
Message-ID: <1361185996.8555.7.camel@jlt4.sipsolutions.net> (sfid-20130218_121322_548919_13510956)
Subject: Re: patch : mac80211:Multicast patch for linux-2.6.28.1 (wl12xx
 drivers)
From: Johannes Berg <johannes@sipsolutions.net>
To: Girish Bn <Girish.BN@lnties.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 18 Feb 2013 12:13:16 +0100
In-Reply-To: <1361185913.8555.6.camel@jlt4.sipsolutions.net> (sfid-20130218_121202_160075_39158588)
References: <45566970CF58C74CB52107862E0541CD1D1F72A2@POCITMSEXMB02.LntUniverse.com>
	 (sfid-20130218_120856_334947_2BD0FBB7) <1361185913.8555.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130218_121202_160075_39158588)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 12:11 +0100, Johannes Berg wrote:
> On Mon, 2013-02-18 at 11:09 +0000, Girish Bn wrote:
> > Hi All,
> > 
> > The below patch file is required in order for the multicasting to work properly on Linux kernel below 3.2 for wl12xx drivers
> > diff -Naur a/net/mac80211/iface.c b/net/mac80211/iface.c
> > --- a/net/mac80211/iface.c          2012-09-22 22:59:15.000000000 +0530
> > +++ b/net/mac80211/iface.c      2013-02-07 12:06:03.958268798 +0530
> > @@ -811,6 +811,9 @@
> >                .ndo_uninit                        = ieee80211_teardown_sdata,
> >                .ndo_start_xmit                               = ieee80211_subif_start_xmit,
> >                .ndo_set_rx_mode        = ieee80211_set_multicast_list,
> > +#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0))
> > +             .ndo_set_multicast_list = ieee80211_set_multicast_list,
> > +#endif
> 
> LOL.

Also this:

> This mail is classified as :
> (  ) L&T IES Proprietary
> (  ) L&T IES Confidential
> (X) L&T IES Internal Use
> ( ) L&T IES General Business


In other words, you never even wanted me to see that email, which is
just as well since it's completely bogus for upstream.

johannes

