Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60393 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab3DQPj0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:39:26 -0400
Message-ID: <516EC22B.6080403@openwrt.org> (sfid-20130417_173929_885651_70BBC124)
Date: Wed, 17 Apr 2013 17:39:23 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 3/5] mac80211: improve the rate control API
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org> <1366112326-92981-3-git-send-email-nbd@openwrt.org> <20130417152339.GA4319@magnum.frso.rivierawaves.com>
In-Reply-To: <20130417152339.GA4319@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-17 5:23 PM, Karl Beldan wrote:
> On Tue, Apr 16, 2013 at 01:38:44PM +0200, Felix Fietkau wrote:
>> @@ -692,16 +692,38 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>>  	 */
>>  	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
>>  
>> -	if (unlikely(info->control.rates[0].idx < 0))
>> -		return TX_DROP;
>> +	if (tx->sta)
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
>> +
>> +			tx->rate = rate;
> tx->rate = ratetbl->rate[0];
No, the data structure in ratetbl->rate is not compatible.

- Felix

