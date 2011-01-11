Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AKMS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 07:18:56 -0500
Subject: Re: [PATCH] cfg80211: Extend channel to frequency mapping for
 802.11j
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Brian Prodoehl <bprodoehl@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com
In-Reply-To: <201101111817.40309.br1@einfach.org>
References: <20110107052600.18730.98168.stgit@localhost6.localdomain6>
	 <201101081243.56629.br1@einfach.org>
	 <AANLkTimYjvJbm9DPPDWWCsD76_DnFcBG3a2Z_B8Mhpzm@mail.gmail.com>
	 <201101111817.40309.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 13:18:49 +0100
Message-ID: <1294748329.3611.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 18:17 +0900, Bruno Randolf wrote:

> > compat-wireless-2011-01-07.orig/drivers/net/wireless/libertas/cfg.c	2011-0
> > 1-07 15:03:59.000000000 -0500
> > +++
> > compat-wireless-2011-01-07/drivers/net/wireless/libertas/cfg.c	2011-01-08
> > 07:51:23.947290769 -0500
> > @@ -607,7 +607,8 @@
> >  		/* No channel, no luck */
> >  		if (chan_no != -1) {
> >  			struct wiphy *wiphy = priv->wdev->wiphy;
> > -			int freq = ieee80211_channel_to_frequency(chan_no);
> > +			int freq = ieee80211_channel_to_frequency(chan_no,
> > +					chan_no <= 14 ? IEEE80211_BAND_2GHZ : 
> IEEE80211_BAND_5GHZ);
> 
> The whole point of having the band argument is to avoid this. We now have 
> overlapping channel numbers: channel 8 and 12 are defined in 5GHz as well as 
> in 2.4GHz (that is for 20MHz channel width, there are more for 10 and 5MHz 
> width, but we don't support that yet). The band has to come from the hardware 
> or driver configuration.

I don't think libertas (or orinoco) support the frequencies that
overlap, and they use the channel number in HW config, so it should be
fine.

johannes

