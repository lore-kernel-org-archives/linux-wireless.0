Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55061 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030883Ab3DSOwS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 10:52:18 -0400
Message-ID: <51715A20.1080503@openwrt.org> (sfid-20130419_165228_466178_39ADA658)
Date: Fri, 19 Apr 2013 16:52:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v3 2/3] mac80211/minstrel_ht: use the new rate control
 API
References: <1366376477-29376-1-git-send-email-nbd@openwrt.org> <1366376477-29376-2-git-send-email-nbd@openwrt.org> <20130419141645.GC8341@magnum.frso.rivierawaves.com>
In-Reply-To: <20130419141645.GC8341@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-19 4:18 PM, Karl Beldan wrote:
> On Fri, Apr 19, 2013 at 03:01:16PM +0200, Felix Fietkau wrote:
>> +	if (mp->hw->max_rates >= 2) {
>> +		/*
>> +		 * At least 2 tx rates supported, use max_prob_rate next */
>>  
> One \n too much.
> 
>> @@ -907,8 +919,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>>  	if (!n_supported)
>>  		goto use_legacy;
>>  
>> -	/* init {mi,mi->groups[*]}->{max_tp_rate,max_tp_rate2,max_prob_rate} */
>> -	minstrel_ht_update_stats(mp, mi);
> We need to keep it.
Right, I intended to change the update_rates that I had in there to
update_stats.

- Felix

