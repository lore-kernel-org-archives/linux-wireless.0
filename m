Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbeB0NU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:20:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH] wcn36xx: reduce verbosity of drivers messages
References: <20180217202510.13707-1-rfried@codeaurora.org>
        <87zi3uhm86.fsf@codeaurora.org>
        <d2614854-478c-80d5-a3e0-b75442bb862c@codeaurora.org>
Date: Tue, 27 Feb 2018 15:20:22 +0200
In-Reply-To: <d2614854-478c-80d5-a3e0-b75442bb862c@codeaurora.org> (Ramon
        Fried's message of "Tue, 27 Feb 2018 10:52:24 +0200")
Message-ID: <871sh6tvqh.fsf@kamboji.qca.qualcomm.com> (sfid-20180227_142031_689575_0FA2C59A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ramon,

you dropped the mailing lists from CC, I'll add them back.

Ramon Fried <rfried@codeaurora.org> writes:

> On 2/27/2018 10:26 AM, Kalle Valo wrote:
>> Ramon Fried <rfried@codeaurora.org> writes:
>>
>>> --- a/drivers/net/wireless/ath/wcn36xx/main.c
>>> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
>>> @@ -261,7 +261,7 @@ static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
>>>  
>>>  	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
>>>  		if (get_feat_caps(wcn->fw_feat_caps, i))
>>> -			wcn36xx_info("FW Cap %s\n", wcn36xx_get_cap_name(i));
>>> +			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
>>>  	}
>>>  }
>>>  
>>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
>>> index 2a4871ca9c72..7c4d19b041bc 100644
>>> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
>>> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
>>> @@ -409,10 +409,10 @@ static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
>>>  	wcn->fw_minor = rsp->start_rsp_params.version.minor;
>>>  	wcn->fw_major = rsp->start_rsp_params.version.major;
>>>  
>>> -	wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
>>> +	wcn36xx_dbg(WCN36XX_DBG_HAL, "firmware WLAN version '%s' and CRM version '%s'\n",
>>>  		     wcn->wlan_version, wcn->crm_version);
>>>  
>>> -	wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
>>> +	wcn36xx_dbg(WCN36XX_DBG_HAL, "firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
>>>  		     wcn->fw_major, wcn->fw_minor,
>>>  		     wcn->fw_version, wcn->fw_revision,
>>>  		     rsp->start_rsp_params.stations,
>>
>> I think that printing this information, especially the firmware version,
>> is useful. Isn't there a better way to solve this, like print this only
>> once during the driver is loaded or during the first start() call?
>
> I agree regarding the firmware version. I can fix it.

Good, thanks.

> the capabilities IMHO is really only relevant for debug and hackers
> who can turn debug on.

Yeah, makes sense.

-- 
Kalle Valo
