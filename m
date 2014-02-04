Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDMMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:12:23 -0500
Message-ID: <1391515939.4134.8.camel@jlt4.sipsolutions.net> (sfid-20140204_131226_648563_CFBD43C0)
Subject: Re: [RFC 1/2] mac80211: merge STA CSA code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 04 Feb 2014 13:12:19 +0100
In-Reply-To: <CA+BoTQkdorOFytjLYHC9OhxH1w=sNTTPRF7b2cSAWy8OCeBQ0A@mail.gmail.com> (sfid-20140204_122947_345678_74D2DD3F)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-2-git-send-email-michal.kazior@tieto.com>
	 <1391504990.26522.34.camel@porter.coelho.fi>
	 <CA+BoTQkdorOFytjLYHC9OhxH1w=sNTTPRF7b2cSAWy8OCeBQ0A@mail.gmail.com>
	 (sfid-20140204_122947_345678_74D2DD3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 12:29 +0100, Michal Kazior wrote:

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

Well, if mac80211 ends up doing that, we just need an API call to send
the event and reset cfg80211's info. I didn't add one yet because the
locking might get a bit tricky, but others actually wanted such an API
for firmware bugs anyway.

johannes

