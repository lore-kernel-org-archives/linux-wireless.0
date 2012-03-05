Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37813 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab2CEPgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 10:36:50 -0500
Message-ID: <4F54DD8A.2090003@openwrt.org> (sfid-20120305_163654_790665_5650C76A)
Date: Mon, 05 Mar 2012 16:36:42 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 1/5] ath9k_hw: use cold instead of warm reset on AR9280
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org> <20308.15129.941982.125893@gargle.gargle.HOWL>
In-Reply-To: <20308.15129.941982.125893@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-05 5:03 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> Cold reset is more reliable for getting the hardware out of some specific
>> stuck states.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/hw.c |   14 ++++++++++----
>>  1 files changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 8c840ca..d582cf7 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -1386,10 +1386,16 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
>>  static bool ath9k_hw_chip_reset(struct ath_hw *ah,
>>  				struct ath9k_channel *chan)
>>  {
>> -	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)) {
>> -		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
>> -			return false;
>> -	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
>> +	int reset_type = ATH9K_RESET_WARM;
>> +
>> +	if (AR_SREV_9280(ah)) {
>> +		if (ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
>> +			reset_type = ATH9K_RESET_POWER_ON;
>> +		else
>> +			reset_type = ATH9K_RESET_COLD;
>> +	}
>> +
>> +	if (!ath9k_hw_set_reset_reg(ah, reset_type))
>>  		return false;
>>  
>>  	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
> 
> I think this needs to be verified a bit more thoroughly, since AR7010+AR9280 USB
> devices would also be affected by this change. What issue is exactly fixed by this
> change ? More background, etc. would be helpful.
I don't have much background on the details. The issue description was
AR9280 in AP mode getting stuck in a reset loop from which the driver
was unable to recover. This usually happened only after a few days of
uptime. I gave this patch to some people that could reproduce the issue,
and with it the issue went away.
I don't see any negative consequences for AR7010+AR9280. This patch has
been in OpenWrt for a few months now, and OpenWrt+ath9k_htc users did
not report any issues with it either.

- Felix
