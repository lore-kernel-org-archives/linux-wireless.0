Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbJETxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:53:15 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
	<wrfj4mjcqn3x.fsf@redhat.com> <wrfjvbbsp6ot.fsf@redhat.com>
	<1441275474.2565.18.camel@sipsolutions.net>
	<wrfjmvx2gi0m.fsf@redhat.com>
	<21994.26976.882903.355191@gargle.gargle.HOWL>
	<1442508413.2821.11.camel@sipsolutions.net>
	<wrfjk2r1b16i.fsf@redhat.com>
	<1444071403.21467.0.camel@sipsolutions.net>
	<wrfj8u7hb0hh.fsf@redhat.com>
	<1444072372.1962.1.camel@sipsolutions.net>
	<wrfjy4fh9l8y.fsf@redhat.com>
	<1444072812.2971.0.camel@sipsolutions.net>
Date: Mon, 05 Oct 2015 15:53:13 -0400
In-Reply-To: <1444072812.2971.0.camel@sipsolutions.net> (Johannes Berg's
	message of "Mon, 05 Oct 2015 21:20:12 +0200")
Message-ID: <wrfjoagd9jo6.fsf@redhat.com> (sfid-20151005_215323_168449_DD8A7D9B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Mon, 2015-10-05 at 15:19 -0400, Jes Sorensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> > On Mon, 2015-10-05 at 15:04 -0400, Jes Sorensen wrote:
>> > > 
>> > > I have this in the code - that said, I may not be getting a 
>> > > pointer 
>> > > back ever?
>> > > 
>> > > 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
>> > > ...
>> > > 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
>> > > 		if (sta) {
>> > > 			sta_priv = (struct rtl8xxxu_sta_priv 
>> > > *)sta
>> > > ->drv_priv;
>> > > 			if (bss_conf->use_short_preamble)
>> > > 				sta_priv->short_preamble = true;
>> > > 			else
>> > > 				sta_priv->short_preamble = 
>> > > false;
>> > > 
>> > 
>> > Ah, ok. You'd of course get a pointer back here - but it's 
>> > pointless.
>> > 
>> > You might as well store the value in some private vif data, or 
>> > perhaps
>> > just use vif->bss_conf.use_short_preamble in the place that you're 
>> > now
>> > using sta_priv->short_preamble - the point was that a per-station
>> > setting of short-preamble doesn't make sense, it needs to be per
>> > -vif.
>> 
>> I see - what is the correct way to get to the vif from with the .tx()
>> function then?
>
> You have a pointer right there in the skb's cb (info) [though it might
> be NULL in some rare cases]

Think I got it right now - this allowed me to get rid of the sta_priv
stuff as well.

Thanks a lot for the help!

Cheers,
Jes
