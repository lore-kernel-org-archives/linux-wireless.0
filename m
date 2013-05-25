Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3EYIU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 04:20:57 -0400
Message-ID: <1369470049.9074.2.camel@jlt4.sipsolutions.net> (sfid-20130525_102122_853345_EC0D9DCF)
Subject: Re: [PATCH 3/3] {nl,mac,cfg}80211: Allow user to configure basic
 rates for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Date: Sat, 25 May 2013 10:20:49 +0200
In-Reply-To: <CACcxo+pWnCFW3wvdjhHZvhb065Trup1KL=8fj7bbBhC5m4evqQ@mail.gmail.com> (sfid-20130525_011407_378756_F59410FC)
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
	 <1368233453-10581-3-git-send-email-ashok@cozybit.com>
	 <1369432740.13623.12.camel@johannes>
	 <CACcxo+pWnCFW3wvdjhHZvhb065Trup1KL=8fj7bbBhC5m4evqQ@mail.gmail.com>
	 (sfid-20130525_011407_378756_F59410FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I think you should consider allowing this attribute only if the channel
> > is also specified (NL80211_ATTR_WIPHY_FREQ, parsed below), and not make
> > it nested with rates for both bands but just the selected band.
> >
> Yes, I think by this approach, we eliminate the need for the user to
> provide rates for both bands and also not require to have a per-band
> for basic_rates.
> 
> Said that, I am wondering why give mcast_rate for both bands, but
> basic_rates only for one band?

Heh, good question. I think it was probably copied from IBSS where you
can pick another channel? Doesn't make all that much sense for mesh I
guess, unless MBSS channel switch could cause us to use another channel?
But then presumably you should follow the basic rates from the STA
initiating the switch, or something, since mesh networks are only
compatible with the same basic rates, right?

johannes

