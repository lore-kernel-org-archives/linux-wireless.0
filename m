Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60356 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755265AbdL2Kwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 05:52:43 -0500
Subject: Re: [PATCH][next] wcn36xx: remove redundant assignment to
 msg_body.min_ch_time
To: Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20171219170401.15154-1-colin.king@canonical.com>
 <20171226201312.GA7480@builder>
 <CAMZdPi8hYToYoPSMggPY-tVpsJNL2W57uzB+d0nSLdfNtPK6Cg@mail.gmail.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <40d7d90a-193e-e4e5-c78c-37068d97a175@canonical.com> (sfid-20171229_115304_769905_EAF0DC78)
Date: Fri, 29 Dec 2017 10:52:41 +0000
MIME-Version: 1.0
In-Reply-To: <CAMZdPi8hYToYoPSMggPY-tVpsJNL2W57uzB+d0nSLdfNtPK6Cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/12/17 07:44, Loic Poulain wrote:
> Hi Colin, Bjorn,
> 
> On 26 December 2017 at 21:13, Bjorn Andersson
> <bjorn.andersson@linaro.org> wrote:
>> On Tue 19 Dec 09:04 PST 2017, Colin King wrote:
>>
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> msg_body.min_ch_time is being assigned twice; remove the redundant
>>> first assignment.
>>>
>>> Detected by CoverityScan, CID#1463042 ("Unused Value")
>>>
>>
>> Happy to see Coverity working for us :)
>>
>>
>> This should have had a:
>>
>> Fixes: 2f3bef4b247e ("wcn36xx: Add hardware scan offload support")
>>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  drivers/net/wireless/ath/wcn36xx/smd.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
>>> index 2914618a0335..bab2eca5fcac 100644
>>> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
>>> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
>>> @@ -625,7 +625,6 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>>>       INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_SCAN_OFFLOAD_REQ);
>>>
>>>       msg_body.scan_type = WCN36XX_HAL_SCAN_TYPE_ACTIVE;
>>> -     msg_body.min_ch_time = 30;
>>>       msg_body.min_ch_time = 100;
>>
>> But I strongly suspect the second line is supposed to be max_ch_time.
>>
>> @Loic, do you agree?
> 
> You're absolutely right.
> Colin could you please update your patch accordingly?

Resent as "wcn36xx: fix incorrect assignment to msg_body.min_ch_time"

> 
> Regards,
> Loic
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
