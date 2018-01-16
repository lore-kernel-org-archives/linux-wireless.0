Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0109.outbound.protection.outlook.com ([104.47.36.109]:28364
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750826AbeAPBwj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 20:52:39 -0500
Subject: Re: [PATCH v2] brcmfmac: fix CLM load error for legacy chips when
 user helper is enabled
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
References: <1515743056-8109-1-git-send-email-wright.feng@cypress.com>
 <5A589428.7020502@broadcom.com> <87a7xjs4xa.fsf@kamboji.qca.qualcomm.com>
 <713a8666-8b72-9198-03a3-a3656c5cb84d@cypress.com>
 <5A5D06FF.2060909@broadcom.com>
From: Wright Feng <wright.feng@cypress.com>
Message-ID: <f1a469eb-0a20-8e14-fc70-9829b874cff3@cypress.com> (sfid-20180116_025244_243959_1DA6FBD8)
Date: Tue, 16 Jan 2018 09:52:10 +0800
MIME-Version: 1.0
In-Reply-To: <5A5D06FF.2060909@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2018/1/16 上午 03:54, Arend van Spriel wrote:
> On 1/15/2018 11:09 AM, Wright Feng wrote:
>>
> 
> [...]
> 
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 12
>> ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> index 6a59d06..aaab0e6 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> @@ -182,12 +182,12 @@ static int brcmf_c_process_clm_blob(struct
>> brcmf_if *ifp)
>>
>>       err = request_firmware(&clm, clm_name, dev);
>>       if (err) {
>> -        if (err == -ENOENT) {
>> -            brcmf_dbg(INFO, "continue with CLM data currently present
>> in firmware\n");
>> -            return 0;
>> -        }
>> -        brcmf_err("request CLM blob file failed (%d)\n", err);
>> -        return err;
>> +        if (err == -ENOENT || err == -EAGAIN)
>> +            brcmf_info("continue with CLM data in FW\n");
>> +        else
>> +            brcmf_err("request clm_blob failed(%d) continue with CLM
>> data in FW\n",
>> +                  err);
> 
> Don't see much value in doing it this way. Either way we need to inform 
> the user about the consequence of this, ie.:
> 
>      brcmf_info("no clm_blob available (%d). device may have limited 
> channels available\n", err);
>> +        return 0;
>>       }
> 
> Regards,
> Arend
Thanks for the comment, I will post patch v3 with your suggestion later.
The patch will include one brcmf_info print and returning 0 regardless
of errors from request_firmware.

Regards,
Wright
