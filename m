Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2HAUpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 16:45:06 -0400
Message-ID: <1343853904.20128.1.camel@jlt3.sipsolutions.net> (sfid-20120801_224511_619042_7B805A10)
Subject: Re: [RFC 7/8] mac80211: support extended channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Aug 2012 22:45:04 +0200
In-Reply-To: <CA+XVXfdwE5-vwF6=aFVU=qmNyGMwi3csPoQ569+O6BG-jc5g8g@mail.gmail.com> (sfid-20120801_215438_675862_3A910B60)
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
	 <1343834487-23737-8-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXfegwamdK3mzP5eiAUJM4eYrFRTXY4Mr2tKP7+VBYriF-w@mail.gmail.com>
	 <1343849597.4638.20.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdwE5-vwF6=aFVU=qmNyGMwi3csPoQ569+O6BG-jc5g8g@mail.gmail.com>
	 (sfid-20120801_215438_675862_3A910B60)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 22:54 +0300, Arik Nemtsov wrote:
> On Wed, Aug 1, 2012 at 10:33 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-08-01 at 22:28 +0300, Arik Nemtsov wrote:
> >
> >> > +static void
> >> > +ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> >> > +                                u8 new_chan_no, u8 count, u8 mode,
> >> > +                                enum ieee80211_band new_band,
> >> > +                                struct ieee80211_bss *bss, u64 timestamp)
> >> >  {
> >> >         struct cfg80211_bss *cbss =
> >> >                 container_of((void *)bss, struct cfg80211_bss, priv);
> >> >         struct ieee80211_channel *new_ch;
> >> >         struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> >> > -       int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
> >> > -                                                     cbss->channel->band);
> >> > +       int new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
> >>
> >> I'm not sure a channel switch between bands should be allowed. Case in
> >> point - a device might have different HT capabilities between bands,
> >> so different rates might need to be programmed to FW. This would
> >> require a re-assoc..
> >
> > Hmm, that might require some new flags or something? I'm not even sure
> > the extended chanswitch is allowed to switch bands, but by the look of
> > it that must have been the intent?
> 
> Maybe the idea was to change the operating class while staying in the
> same band? But now I'm thinking that even without different HT caps
> per band, the change of class alone might impose new regulatory
> restrictions. For instance HT40 may now be allowed/disallowed.
> So we have to notify the driver about this somehow?
> 
> If it's too cumbersome, maybe we should just disconnect if the class
> changes? wpa_s would reconnect anyway in most situations (non p2p).

Yeah, maybe. I'm just going to drop patches 6 and 7 for now. The
extended switch handling was just something I thought about, not
actually necessary for what I'm doing (still multi-channel work)

johannes

