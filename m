Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:42037 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3DUIp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Apr 2013 04:45:28 -0400
Received: by mail-we0-f173.google.com with SMTP id t57so4939868wey.4
        for <linux-wireless@vger.kernel.org>; Sun, 21 Apr 2013 01:45:27 -0700 (PDT)
Date: Sun, 21 Apr 2013 10:45:04 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v4 2/3] mac80211/minstrel_ht: use the new rate control API
Message-ID: <20130421084504.GA831@gobelin> (sfid-20130421_104534_609474_F8000C76)
References: <1366385329-42690-1-git-send-email-nbd@openwrt.org>
 <1366385329-42690-2-git-send-email-nbd@openwrt.org>
 <20130420174453.GC767@gobelin>
 <51739BE3.9070706@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <51739BE3.9070706@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 21, 2013 at 09:57:23AM +0200, Felix Fietkau wrote:
> On 2013-04-20 7:44 PM, Karl Beldan wrote:
> > On Fri, Apr 19, 2013 at 05:28:48PM +0200, Felix Fietkau wrote:
> >> @@ -846,6 +856,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
> >>  
> >>  	msp->is_ht = true;
> >>  	memset(mi, 0, sizeof(*mi));
> >> +
> >> +	mi->sta = sta;
> >>  	mi->stats_update = jiffies;
> >>  
> >>  	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1);
> >> @@ -907,7 +919,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
> >>  	if (!n_supported)
> >>  		goto use_legacy;
> >>  
> >> -	/* init {mi,mi->groups[*]}->{max_tp_rate,max_tp_rate2,max_prob_rate} */
> >>  	minstrel_ht_update_stats(mp, mi);
> >>  
> > This time you kept minstrel_ht_update_stats but you got rid of the call
> > to minstrel_ht_update_rates you previously had.
> > If you don't minstrel_ht_update_rates, ieee80211_tx_h_rate_ctrl will
> > TX_DROP the frame until minstrel's get_sample_rate returns != -1,
> > Maybe you could pair update_stats with ht_update_rates, e.g move/call
> > ht_update_stats in ht_update_rates ?
> I really should have re-read this in a distraction free environment :)
> Looking at the code again, I see why I kept them separated. In some
> cases the rates change (when quickly switching to a different MCS group
> when the rates fail) but the statistics are not updated yet.
> Calling both functions here is the right thing to do.
> 
Good, note that minstrel ht_update_rates != its ht_rate_update and that
ht_update_stats will always be called whenever ht_update_rates is, but I
too prefer keeping them separated.
Other than that and the 'low' rates issue I sent I think I'm good.

 
Karl

