Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:44123 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbaBDLuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 06:50:03 -0500
Message-ID: <1391514600.26522.93.camel@porter.coelho.fi> (sfid-20140204_125007_334254_6B29EAF3)
Subject: Re: [RFC 1/2] mac80211: merge STA CSA code
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 04 Feb 2014 13:50:00 +0200
In-Reply-To: <CA+BoTQkdorOFytjLYHC9OhxH1w=sNTTPRF7b2cSAWy8OCeBQ0A@mail.gmail.com>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-2-git-send-email-michal.kazior@tieto.com>
	 <1391504990.26522.34.camel@porter.coelho.fi>
	 <CA+BoTQkdorOFytjLYHC9OhxH1w=sNTTPRF7b2cSAWy8OCeBQ0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 12:29 +0100, Michal Kazior wrote:
> On 4 February 2014 10:09, Luca Coelho <luca@coelho.fi> wrote:
> > On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
> >> +void ieee80211_csa_disconnect(struct ieee80211_sub_if_data *sdata)
> >> +{
> >> +     struct ieee80211_local *local = sdata->local;
> >> +     struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> >> +
> >> +     switch (sdata->vif.type) {
> >> +     case NL80211_IFTYPE_STATION:
> >> +     case NL80211_IFTYPE_P2P_CLIENT:
> >> +             ieee80211_queue_work(&local->hw,
> >> +                                  &ifmgd->csa_connection_drop_work);
> >> +             break;
> >> +     default:
> >> +             /* XXX: other iftypes should be halted too */
> >
> > Good point.  This case would suck, but we need to do something because
> > the stations will think that we're on the different channel at this
> > point.  But maybe instead the userspace should be notified instead of
> > halting here? It could retry with a count 0, for example.
> 
> Ideally cfg80211 should be the one stopping interfaces. This way you'd
> get AP stopped event (recently done by Johannes) and userspace can do
> something about (e.g. re-start APs from scratch).

Yeah, this is a tricky case and the best we can do is probably just stop
the interface.


> >> -int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
> >> -                          struct cfg80211_csa_settings *params)
> >> +int __ieee80211_channel_switch(struct ieee80211_sub_if_data *sdata,
> >> +                            struct cfg80211_csa_settings *params)
> >
> > Why did you have to split this function? All cases where you call
> > __ieee80211_channel_switch() you lock->call->unlock anyway.
> 
> It was shorter. The function does a bunch of return's so I'd have to
> do err+goto. Since it asserts sdata lock is held I decided to assert
> chanctx_mtx is held as well and lock the thing from call sites.

Fair enough.


> >> @@ -998,6 +944,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> >>       if (res)
> >>               return;
> >>
> >> +     /* FIXME: This check should be moved to cfg80211 */
> >
> > This is not really related to this patch.
> >
> >
> >>       if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
> >>                                    IEEE80211_CHAN_DISABLED)) {
> >>               sdata_info(sdata,
> 
> Ideally mac80211 shouldn't be the one checking that - it should be
> cfg80211, shouldn't it?

Yes, but this patch doesn't change anything regarding this.  In any
case, it's an informative FIXME, so I guess it can go together with any
patch (it would be silly to have a separate patch just to add the
FIXME).  So, fine by me. :)

--
Luca.

