Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:31760 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757407AbYD2SmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 14:42:21 -0400
From: bruno randolf <bruno@thinktube.com>
To: Vladimir Koutny <vlado@work.ksp.sk>
Subject: Re: [RFC] WARNING: at net/mac80211/ieee80211_rate.h:159 rate_lowest_index()
Date: Tue, 29 Apr 2008 20:42:20 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <48174652.6080909@work.ksp.sk>
In-Reply-To: <48174652.6080909@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804292042.20500.bruno@thinktube.com> (sfid-20080429_204241_952560_ADB95C87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 April 2008 18:01:22 Vladimir Koutny wrote:
> Hi,
> the warning in $subj can pop up in the following scenario:
>
> - iwconfig wlan0 mode ad-hoc; ifconfig wlan0 up
> - a frame arrives from an unknown station which triggers
>   ieee80211_ibss_sta_add() (called from prepare_for_handlers())

yep, i have seen this warning too, just didn't get around to look into it...

> In this case, we create a new sta entry, fill in supp_rates field,
> initialize rate_control algo, and insert this sta entry into the list.
>
> The problem is the assignment for supp_rates:
>
> sta->supp_rates[local->hw.conf.channel->band] =
> 	sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
>
> because sdata->u.sta.supp_rates_bits is set only when we actually
> join an ibss, which is not the case in this scenario; so we assign
> zero here. Then, the code in rate_control_pid_rate_init() calls
> rate_lowest_index() for some reason, and since no supported rate is
> found, this warning is issued.
>
>
> The question is how sta->supp_rates should be initialized:
>
> - we could initialize it to our sta's rates, but then we could
>   probably transmit to a station at unsupported rate

isn't this what is done right now, and the rateset is zero sometimes and then 
we get the warning?

this might be wrong anyways: as you said it could make us send frames at an 
unsupported rate.

> - add new ibss station only on received beacon, not on a data frame;
>   currently, beacons are ignored for this purpose (they just update
>   the bss list later on)

i think stations should be added on reception of both beacons and data frames.

> - something else (like 1Mbps only)?

what about the rate of the currently received data frame (and maybe any other 
rates we could safely deduce from that)?

bruno
