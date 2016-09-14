Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55788 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761890AbcINP2C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:28:02 -0400
Message-ID: <57D96C81.4010503@candelatech.com> (sfid-20160914_172805_979172_1B93205B)
Date: Wed, 14 Sep 2016 08:28:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 19/21] ath10k: Enable adhoc mode for CT firmware.
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com> <1462986153-16318-20-git-send-email-greearb@candelatech.com> <877faeeedm.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877faeeedm.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:37 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> CT firmware can support IBSS mode, so allow users to configure this.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index f1bfb3a..3fc9006 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -7482,6 +7482,10 @@ static const struct ieee80211_iface_limit ath10k_10x_ct_if_limits[] = {
>>   	.max	= 7,
>>   	.types	= BIT(NL80211_IFTYPE_AP)
>>   	},
>> +	{
>> +	.max	= 1,
>> +	.types	= BIT(NL80211_IFTYPE_ADHOC)
>> +	},
>>   };
>>
>>   static const struct ieee80211_iface_combination ath10k_if_comb[] = {
>> @@ -7862,6 +7866,7 @@ int ath10k_mac_register(struct ath10k *ar)
>>   			ar->hw->wiphy->iface_combinations = ath10k_10x_ct_if_comb;
>>   			ar->hw->wiphy->n_iface_combinations =
>>   				ARRAY_SIZE(ath10k_10x_ct_if_comb);
>> +			ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
>>   		} else {
>>   			ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
>>   			ar->hw->wiphy->n_iface_combinations =
>
> There should a feature flag ATH10K_FW_FEATURE_SUPPORTS_ADHOC and we use
> that flag as an indication to enable the mode. I wish we had done that
> from the beginning, using wmi_op_version to guess that just creates
> problems :(

No argument there.  If you want to add a feature flag I can start setting it in
my firmware.

But, the if-combinations crap is a bigger problem than that anyway.  I have
some later patches to re-work it to make it dynamically created instead of static,
but that is a fairly big change and I figured I had a better chance of getting
smaller changes upstream first.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
