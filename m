Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753710AbeDRNH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 09:07:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 18 Apr 2018 18:37:26 +0530
From: govinds@codeaurora.org
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: pillair@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
In-Reply-To: <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
Message-ID: <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org> (sfid-20180418_150732_032619_8D2334E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-18 12:36, Sebastian Gottschall wrote:
> from my point of view powersave should be optional and not forced.
> 
> consider :
> iw dev <devname> set power_save on/off
> 
> so there is already a config option made for that purpose,
> 
> Sebastian
> 
> Am 17.04.2018 um 14:07 schrieb pillair@codeaurora.org:
>> From: Govind Singh <govinds@codeaurora.org>
>> 
>> Enable sta power save in fw for the targets that
>> supports idle power save. The idle ps enable command
>> will be ignored by the firmware which does not support
>> this feature.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c 
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 7e02ca02b28e..1d9222af1bb2 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4679,6 +4679,13 @@ static int ath10k_start(struct ieee80211_hw 
>> *hw)
>>   		}
>>   	}
>>   +	param = ar->wmi.pdev_param->idle_ps_config;
>> +	ret = ath10k_wmi_pdev_set_param(ar, param, 1);
>> +	if (ret && ret != -EOPNOTSUPP) {
>> +		ath10k_warn(ar, "failed to enable idle_ps_config: %d\n", ret);
>> +		goto err_core_stop;
>> +	}
>> +
>>   	__ath10k_set_antenna(ar, ar->cfg_tx_chainmask, 
>> ar->cfg_rx_chainmask);
>>     	/*

Thanks Sebastian for your review. Agree this should not be forced with 
in driver.

I will check if i can set the idle ps at the end of 
ath10k_mac_vif_setup_ps by checking arvif->ps.
I will update the patch accordingly.


BR,
Govind
