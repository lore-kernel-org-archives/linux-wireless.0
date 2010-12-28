Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:24392 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750789Ab0L1Fbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 00:31:51 -0500
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0778584306
	for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 14:31:49 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for 802.11j
Date: Tue, 28 Dec 2010 14:31:46 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6> <1293447459.3544.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1293447459.3544.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012281431.46536.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon December 27 2010 19:57:39 Johannes Berg wrote:
> On Fri, 2010-12-24 at 16:44 +0900, Bruno Randolf wrote:
> >  static bool freq_is_chan_12_13_14(u16 freq)
> >  {
> > 
> > -	if (freq == ieee80211_channel_to_frequency(12) ||
> > -	    freq == ieee80211_channel_to_frequency(13) ||
> > -	    freq == ieee80211_channel_to_frequency(14))
> > +	if (freq == ieee80211_channel_to_frequency(12, IEEE80211_BAND_2GHZ) ||
> > +	    freq == ieee80211_channel_to_frequency(13, IEEE80211_BAND_2GHZ) ||
> > +	    freq == ieee80211_channel_to_frequency(14, IEEE80211_BAND_2GHZ))
> > 
> >  		return true;
> 
> This seems strange ... why not just hardcode the values??

True, but this is not my code, I just did the change for the new function 
parameter. It's in net/wireless/reg.c, so I'll CC: Luis.

> >  	if (freq->e == 0) {
> > 
> > +		int band = IEEE80211_BAND_2GHZ;
> 
> enum?

Ok, thanks.

Any other comments on the code or purpose of this patch?

bruno
