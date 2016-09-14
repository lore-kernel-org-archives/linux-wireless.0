Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55658 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756348AbcINPY4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:24:56 -0400
Message-ID: <57D96BC7.1080609@candelatech.com> (sfid-20160914_172506_006844_FB3FCDD9)
Date: Wed, 14 Sep 2016 08:24:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 15/21] ath10k: support CT firmware flag.
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com> <1462986153-16318-16-git-send-email-greearb@candelatech.com> <87bmzqeeox.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bmzqeeox.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:30 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Add placeholder so CT firmware can more easily co-exist with upstream
>> kernel.  CT firmware should be backwards compatible with existing kernels,
>> but it also has many new features.  Subsequent patches, if acceptable for
>> upstream, can enable and further describe those features.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/core.c | 1 +
>>   drivers/net/wireless/ath/ath10k/core.h | 3 +++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>> index fa71d57..49c85c3 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -235,6 +235,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
>>   	[ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA] = "adaptive-cca",
>>   	[ATH10K_FW_FEATURE_MFP_SUPPORT] = "mfp",
>>   	[ATH10K_FW_FEATURE_PEER_FLOW_CONTROL] = "peer-flow-ctrl",
>> +	[ATH10K_FW_FEATURE_WMI_10X_CT] = "wmi-10.x-CT",
>>   };
>>
>>   static unsigned int ath10k_core_get_fw_feature_str(char *buf,
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index cb6aa8c..f9e3b20 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -566,6 +566,9 @@ enum ath10k_fw_features {
>>   	 */
>>   	ATH10K_FW_FEATURE_PEER_FLOW_CONTROL = 13,
>>
>> +	/* Firmware from Candela Technologies, enables more VIFs, etc */
>> +	ATH10K_FW_FEATURE_WMI_10X_CT = 31,
>
> The idea of firmware feature flags to enable (or disable) one particular
> feature, not a group of features. This way it's easy to enable certain
> features on different firmware branches. It also makes the maintenance
> easier as you don't need to remember all the different features one flag
> enables.

One potential use for this flag:  Bug reports could be automatically directed to me instead
of QCA.

I have actually re-written much of my earlier logic so that it uses specific
feature flags now.  I still like the idea of having the driver (and user)
know it is using CT firmware, but I can live without this flag if needed.

Even if I change generation of my new firmware, all of my older firmware
will have this flag set though, so I would still prefer the flag exist
in the driver, even if it is not used for any serious decisions.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
