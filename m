Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2HFP0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:26:11 -0400
Message-ID: <1344266768.4807.6.camel@jlt3.sipsolutions.net> (sfid-20120806_172615_070736_28C9D57B)
Subject: Re: [RFC 20/20] mac80211: use channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Aug 2012 17:26:08 +0200
In-Reply-To: <CA+XVXfc2QZTrWnp07oQdfNi4LwyT76ibEYDycpL8Sj5aR=_odA@mail.gmail.com> (sfid-20120806_172217_281524_60D3C550)
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1343387816-9414-21-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXfc2QZTrWnp07oQdfNi4LwyT76ibEYDycpL8Sj5aR=_odA@mail.gmail.com>
	 (sfid-20120806_172217_281524_60D3C550)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-06 at 18:21 +0300, Arik Nemtsov wrote:

> >  static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
> >                                          struct ieee80211_channel *chan,
> >                                          enum nl80211_channel_type channel_type)
> >  {
> > -       return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
> > +       return 0;
> > +//return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
> 
> typo?
> 
> [...]

More "todo", but this was indeed missing. I have addressed it in my new
versions in the mac80211-next/wip branch.

> > @@ -1278,11 +1271,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
> >         if (type == ieee80211_vif_type_p2p(&sdata->vif))
> >                 return 0;
> >
> > -       /* Setting ad-hoc mode on non-IBSS channel is not supported. */
> > -       if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
> > -           type == NL80211_IFTYPE_ADHOC)
> > -               return -EOPNOTSUPP;
> > -
> >         if (ieee80211_sdata_running(sdata)) {
> >                 ret = ieee80211_runtime_change_iftype(sdata, type);
> >                 if (ret)
> > @@ -1294,9 +1282,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
> >         }
> >
> >         /* reset some values that shouldn't be kept across type changes */
> > -       sdata->vif.bss_conf.basic_rates =
> > -               ieee80211_mandatory_rates(sdata->local,
> > -                       sdata->local->oper_channel->band);
> 
> was this a bug? shouldn't be updated to use the channel context?

Well, the first was a leftover from before we even had an explicit IBSS
join operation -- now the (default) channel is just checked when you try
to join an IBSS, so the code in the first hunk has truly been
unnecessary for quite a while.

The second hunk ... similar story, it should be set whenever we first
use the interface by starting AP, joining IBSS or connecting to an AP or
mesh or whatever else could happen. So I think it should be safe.

johannes

