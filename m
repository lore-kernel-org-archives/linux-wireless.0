Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58738 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbbJETUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:20:17 -0400
Message-ID: <1444072812.2971.0.camel@sipsolutions.net> (sfid-20151005_212021_194909_1B323DB5)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Mon, 05 Oct 2015 21:20:12 +0200
In-Reply-To: <wrfjy4fh9l8y.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
	 <wrfjvbbsp6ot.fsf@redhat.com> <1441275474.2565.18.camel@sipsolutions.net>
	 <wrfjmvx2gi0m.fsf@redhat.com>
	 <21994.26976.882903.355191@gargle.gargle.HOWL>
	 <1442508413.2821.11.camel@sipsolutions.net> <wrfjk2r1b16i.fsf@redhat.com>
	 <1444071403.21467.0.camel@sipsolutions.net> <wrfj8u7hb0hh.fsf@redhat.com>
	 <1444072372.1962.1.camel@sipsolutions.net> <wrfjy4fh9l8y.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-05 at 15:19 -0400, Jes Sorensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> > On Mon, 2015-10-05 at 15:04 -0400, Jes Sorensen wrote:
> > > 
> > > I have this in the code - that said, I may not be getting a 
> > > pointer 
> > > back ever?
> > > 
> > > 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
> > > ...
> > > 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
> > > 		if (sta) {
> > > 			sta_priv = (struct rtl8xxxu_sta_priv 
> > > *)sta
> > > ->drv_priv;
> > > 			if (bss_conf->use_short_preamble)
> > > 				sta_priv->short_preamble = true;
> > > 			else
> > > 				sta_priv->short_preamble = 
> > > false;
> > > 
> > 
> > Ah, ok. You'd of course get a pointer back here - but it's 
> > pointless.
> > 
> > You might as well store the value in some private vif data, or 
> > perhaps
> > just use vif->bss_conf.use_short_preamble in the place that you're 
> > now
> > using sta_priv->short_preamble - the point was that a per-station
> > setting of short-preamble doesn't make sense, it needs to be per
> > -vif.
> 
> I see - what is the correct way to get to the vif from with the .tx()
> function then?
> 

You have a pointer right there in the skb's cb (info) [though it might
be NULL in some rare cases]

johannes
