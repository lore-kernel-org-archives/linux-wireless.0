Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2G0Lzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:55:39 -0400
Message-ID: <1343390137.4449.7.camel@jlt3.sipsolutions.net> (sfid-20120727_135543_119397_EDF8C566)
Subject: Re: [RFC 20/20] mac80211: use channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jul 2012 13:55:37 +0200
In-Reply-To: <50127F8D.9050602@tieto.com>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1343387816-9414-21-git-send-email-johannes@sipsolutions.net>
	 <50127F8D.9050602@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:46 +0200, Michal Kazior wrote:

> > @@ -80,17 +79,15 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
> >
> >          sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
> >
> > -       local->oper_channel = chan;
> >          channel_type = ifibss->channel_type;
> >          if (!cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
> >                  channel_type = NL80211_CHAN_HT20;
> > -       if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
> > -               /* can only fail due to HT40+/- mismatch */
> > -               channel_type = NL80211_CHAN_HT20;
> > -               WARN_ON(!ieee80211_set_channel_type(local, sdata,
> > -                                                   NL80211_CHAN_HT20));
> > -       }
> > -       ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> > +
> > +       ieee80211_vif_release_channel(sdata);
> > +       ieee80211_vif_use_channel(sdata, chan, channel_type,
> > +                                 ifibss->fixed_channel ?
> > +                                       IEEE80211_CHANCTX_SHARED :
> > +                                       IEEE80211_CHANCTX_EXCLUSIVE);
> 
> ieee80211_vif_use_channel() may fail. Can we just ignore it here?

No, I guess we shouldn't, though it's an exclusive channel context most
of the time, so it shouldn't fail. I'll fix this, not really sure what
to do about it though.

johannes

