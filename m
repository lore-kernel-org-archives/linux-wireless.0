Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52596 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab3DVOIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:08:23 -0400
Message-ID: <51754455.40804@openwrt.org> (sfid-20130422_160826_746517_0CEFBB43)
Date: Mon, 22 Apr 2013 16:08:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, karl.beldan@gmail.com
Subject: Re: [PATCH v5 1/3] mac80211: improve the rate control API
References: <1366625393-11647-1-git-send-email-nbd@openwrt.org> <1366638766.8637.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366638766.8637.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-22 3:52 PM, Johannes Berg wrote:
> On Mon, 2013-04-22 at 12:09 +0200, Felix Fietkau wrote:
> 
>> @@ -692,16 +692,38 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>>  	 */
>>  	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
>>  
>> -	if (unlikely(info->control.rates[0].idx < 0))
>> -		return TX_DROP;
>> +	if (tx->sta && !info->control.skip_table)
>> +		ratetbl = rcu_dereference(tx->sta->sta.rates);
>> +
>> +	if (unlikely(info->control.rates[0].idx < 0)) {
>> +		if (ratetbl) {
>> +			struct ieee80211_tx_rate rate = {
>> +				.idx = ratetbl->rate[0].idx,
>> +				.flags = ratetbl->rate[0].flags,
>> +				.count = ratetbl->rate[0].count
>> +			};
>> +
>> +			if (ratetbl->rate[0].idx < 0)
>> +				return TX_DROP;
> 
> This can't happen, idx is unsigned. Did you intend idx to be signed?
Right, shouldn't the compiler warn about this? Will send v6.

- Felix

