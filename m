Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2GEPJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 11:09:32 -0400
Message-ID: <1341500968.4455.45.camel@jlt3.sipsolutions.net> (sfid-20120705_170935_659895_28F75731)
Subject: Re: [PATCH] mac80211: always set in_reconfig=false on wakeup
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 05 Jul 2012 17:09:28 +0200
In-Reply-To: <CAB3XZEe-ckFE3ivCpYtRsZaFw0v6dFjDaywUje4TKO18kWiz3A@mail.gmail.com> (sfid-20120705_170201_005883_931AD321)
References: <1341230905-8929-1-git-send-email-eliad@wizery.com>
	 <1341231541.19642.3.camel@jlt3.sipsolutions.net>
	 <20120702181747.GA2010@tuxdriver.com>
	 <CAB3XZEe-ckFE3ivCpYtRsZaFw0v6dFjDaywUje4TKO18kWiz3A@mail.gmail.com>
	 (sfid-20120705_170201_005883_931AD321)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-05 at 18:01 +0300, Eliad Peller wrote:

> >> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> >> > index 242ecde..e1b7c63 100644
> >> > --- a/net/mac80211/util.c
> >> > +++ b/net/mac80211/util.c
> >> > @@ -1411,10 +1411,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
> >> >             if (ieee80211_sdata_running(sdata))
> >> >                     ieee80211_enable_keys(sdata);
> >> >
> >> > + wake_up:
> >> >     local->in_reconfig = false;
> >> >     barrier();
> >> >
> >> > - wake_up:
> >> >     /*
> >> >      * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
> >> >      * sessions can be established after a resume.
> >
> > This doesn't apply to 3.5 -- the "local->in_reconfig = false" bit isn't there.
> >
> err... my mistake. this only applies on wireless-next.
> sorry for the hassle.

I'll pick it up

johannes

