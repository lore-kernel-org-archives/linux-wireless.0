Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45053 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab3DUH5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Apr 2013 03:57:30 -0400
Message-ID: <51739BE3.9070706@openwrt.org> (sfid-20130421_095743_596885_B737A5E5)
Date: Sun, 21 Apr 2013 09:57:23 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v4 2/3] mac80211/minstrel_ht: use the new rate control
 API
References: <1366385329-42690-1-git-send-email-nbd@openwrt.org> <1366385329-42690-2-git-send-email-nbd@openwrt.org> <20130420174453.GC767@gobelin>
In-Reply-To: <20130420174453.GC767@gobelin>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-20 7:44 PM, Karl Beldan wrote:
> On Fri, Apr 19, 2013 at 05:28:48PM +0200, Felix Fietkau wrote:
>> @@ -846,6 +856,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>>  
>>  	msp->is_ht = true;
>>  	memset(mi, 0, sizeof(*mi));
>> +
>> +	mi->sta = sta;
>>  	mi->stats_update = jiffies;
>>  
>>  	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1);
>> @@ -907,7 +919,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>>  	if (!n_supported)
>>  		goto use_legacy;
>>  
>> -	/* init {mi,mi->groups[*]}->{max_tp_rate,max_tp_rate2,max_prob_rate} */
>>  	minstrel_ht_update_stats(mp, mi);
>>  
> This time you kept minstrel_ht_update_stats but you got rid of the call
> to minstrel_ht_update_rates you previously had.
> If you don't minstrel_ht_update_rates, ieee80211_tx_h_rate_ctrl will
> TX_DROP the frame until minstrel's get_sample_rate returns != -1,
> Maybe you could pair update_stats with ht_update_rates, e.g move/call
> ht_update_stats in ht_update_rates ?
I really should have re-read this in a distraction free environment :)
Looking at the code again, I see why I kept them separated. In some
cases the rates change (when quickly switching to a different MCS group
when the rates fail) but the statistics are not updated yet.
Calling both functions here is the right thing to do.

- Felix

