Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53553 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030421Ab3DSOPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 10:15:19 -0400
Message-ID: <51715174.8000105@openwrt.org> (sfid-20130419_161524_200671_67C2E298)
Date: Fri, 19 Apr 2013 16:15:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v3 1/3] mac80211: improve the rate control API
References: <1366376477-29376-1-git-send-email-nbd@openwrt.org> <20130419140653.GB8341@magnum.frso.rivierawaves.com>
In-Reply-To: <20130419140653.GB8341@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-19 4:06 PM, Karl Beldan wrote:
> On Fri, Apr 19, 2013 at 03:01:15PM +0200, Felix Fietkau wrote:
>> +	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
>> +		s8 baserate = 0;
>> +
>> +		rate = &sband->bitrates[rates[0].idx];
>> +
>> +		for (i = 0; i < sband->n_bitrates; i++) {
>> +			/* must be a basic rate */
>> +			if (!(vif->bss_conf.basic_rates & BIT(i)))
>> +				continue;
> [...]
>> -	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
>> -		u32 basic_rates = tx->sdata->vif.bss_conf.basic_rates;
>> -		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
>> -
>> -		rate = &sband->bitrates[info->control.rates[0].idx];
>> -
>> -		for (i = 0; i < sband->n_bitrates; i++) {
>> -			/* must be a basic rate */
>> -			if (!(basic_rates & BIT(i)))
>> -				continue;
> 
> The moved code doesn't match, missing 5253ffb.
Oh, I must have overlooked it during the merge. Will send v4, thanks.

- Felix

