Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52926 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1GMHWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 03:22:31 -0400
Message-ID: <4E1D47B2.4080706@qca.qualcomm.com> (sfid-20110713_092234_629997_468578AC)
Date: Wed, 13 Jul 2011 10:22:26 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 03/24] ath6kl: add cfg80211.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013324.8517.86411.stgit@localhost6.localdomain6> <1310531343.1143.26.camel@Joe-Laptop>
In-Reply-To: <1310531343.1143.26.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 07:29 AM, Joe Perches wrote:
> On Wed, 2011-07-13 at 04:33 +0300, Kalle Valo wrote: 
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> [] 
>> +static struct ieee80211_rate ath6kl_rates[] = {
> 
> const?
> 
>> +static struct ieee80211_channel ath6kl_2ghz_channels[] = {
> 
> const?
> 
>> +static struct ieee80211_channel ath6kl_5ghz_a_channels[] = {
> 
> const?
> 
>> +static struct ieee80211_supported_band ath6kl_band_2ghz = {
> 
> const?
> 
>> +static struct ieee80211_supported_band ath6kl_band_5ghz = {
> 
> const?

cfg80211 requires them to be non-const.

>> +		ath6kl_err("%s: %u not spported\n", __func__, wpa_version);
>> +		ath6kl_err("%s: 0x%x not spported\n", __func__, auth_type);
> 
> supported

Fixed.

>> +		wait_event_interruptible_timeout(ar->event_wq,
>> +						 ar->
>> +						 tx_pending[wmi_get_control_ep
>> +							     (ar->wmi)] == 0,
>> +						 WMI_TIMEOUT);
> 
> I think you can ignore 80 columns for this.
> 
> 		wait_event_interruptible_timeout(ar->event_wq,
> 						 ar->tx_pending[wmi_get_control_ep(ar->wmi)] == 0,
> 						 WMI_TIMEOUT);
> 
> or maybe use different argument alignment when appropriate:
> 
> 		wait_event_interruptible_timeout(ar->event_wq,
> 			ar->tx_pending[wmi_get_control_ep(ar->wmi)] == 0,
> 			WMI_TIMEOUT);

I took the latter approach to avoid checkpatch warnings.

>> +		if (sme->key_idx < WMI_MIN_KEY_INDEX
>> +		    || sme->key_idx > WMI_MAX_KEY_INDEX) {
> 
> I think it's more consistent with other files in drivers/net
> to use logical continuations at EOL
> 
> if (sme->key_idx < WMI_MIN_KEY_INDEX ||
>     sme->key_idx > WMI_MAX_KEY_INDEX) {

Yes, we just had missed that. Fixed.

> 
>> +			ath6kl_err("%s: key index %d out of bounds\n", __func__,
>> +				   sme->key_idx);
> 
> I think it's better to use format on one line,
> arguments on another.
> 
> 			ath6kl_err("%s: key index %d out of bounds\n",
> 				    __func__, sme->key_idx);
> 

Fixed.

> It seems almost all of your ath6kl_<level> logging
> messages use __func__.  Perhaps you might as well
> #define it to take __func__ instead of using it
> in-place over and over.

Actually I would like to get rid of __func__ usage from logging
altogether, IMHO they just clutter the logs. I started doing that but
haven't removed all of them yet (obviously).

Kalle
