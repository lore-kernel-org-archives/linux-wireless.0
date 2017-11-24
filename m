Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:46994 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbdKXKWf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 05:22:35 -0500
Received: by mail-qk0-f194.google.com with SMTP id b85so23961531qkc.13
        for <linux-wireless@vger.kernel.org>; Fri, 24 Nov 2017 02:22:35 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: transfer firmware error to Linux error code in
 fwil
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
References: <1511341876-10198-1-git-send-email-wright.feng@cypress.com>
 <5A16A5D2.8020600@broadcom.com>
 <3874d5a7-ff87-a7d9-8ecd-e50db80b93d8@cypress.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A17F2E8.4090305@broadcom.com> (sfid-20171124_112250_599461_A7C2FCE3)
Date: Fri, 24 Nov 2017 11:22:32 +0100
MIME-Version: 1.0
In-Reply-To: <3874d5a7-ff87-a7d9-8ecd-e50db80b93d8@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2017 7:35 AM, Wright Feng wrote:
> Hi Arend,
>

[...]

>>
>> However, the consequence of this was that we ended up returning
>> firmware error codes into the kernel domain and user-space >
>> Below the change I came up with. Let me know what you think.
> Thanks for the info, now I know the whole history.
> And I have 2 comments below.
>>
>> Regards,
>> Arend
>> ---8<--------------------------------------------------------
>> commit e340892a4bb5a74248b19504bb972497d38a4a03
>> Author: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Date:   Thu Nov 23 11:13:41 2017 +0100
>>
>>      brcmfmac: separate firmware errors from i/o errors
>>
>>      When using the firmware api it can fail simply because firmware does
>>      not like the request or it fails due to issues in the host
>> interface.
>>      Currently, there is only a single error code which is confusing. So
>>      adding a parameter to pass the firmware error separately and in case
>>      of a firmware error always return -EBADE to user-space.
>>
>>      Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>>      Reviewed-by: Pieter-Paul Giesberts
>> <pieter-paul.giesberts@broadcom.com>
>>      Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>>      Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> index 9f2d0b0..353ed28 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> @@ -165,7 +165,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub
>> *drvr, u32 id, u32 len)
>>
>>   static int
>>   brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint
>> cmd,
>> -                void *buf, uint len)
>> +                void *buf, uint len, int *fwerr)
>>   {
>>       struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
>>       struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
>> @@ -175,6 +175,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub
>> *drvr, u32 id, u32 len)
>>
>>       brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
>>
>> +    *fwerr = 0;
>>       ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, false);
>>       if (ret < 0) {
>>           brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
>> @@ -211,17 +212,18 @@ static int brcmf_proto_bcdc_cmplt(struct
>> brcmf_pub *drvr, u32 id, u32 len)
>>           memcpy(buf, info, len);
>>       }
>>
>> +    ret = 0;
>> +
>>       /* Check the ERROR flag */
>>       if (flags & BCDC_DCMD_ERROR)
>> -        ret = le32_to_cpu(msg->status);
>> -
>> +        *fwerr = le32_to_cpu(msg->status);
>>   done:
>>       return ret;
>>   }
>>
>>   static int
>>   brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
>> -              void *buf, uint len)
>> +              void *buf, uint len, int *fwerr)
>>   {
>>       struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
>>       struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
>> @@ -230,6 +232,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub
>> *drvr, u32 id, u32 len)
>>
>>       brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
>>
>> +    *fwerr = 0;
>>       ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, true);
>>       if (ret < 0)
>>           goto done;
>> @@ -251,7 +254,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub
>> *drvr, u32 id, u32 len)
>>
> Does it exist any possible case or set command that causes the ret value
> is greater than 0? The positive ret value may be identified as error
> because following check is removed from brcmf_fil_cmd_data function.
>      if (err >= 0)
>          return 0;

The only possible case is with brcmf_proto_bcdc_query_dcmd() as it 
returns the length of the firmware response. However, I added ret = 0 
there after dealing with (ret < 0) case. I actually want to do that in a 
separate patch.

>
>>       /* Check the ERROR flag */
>>       if (flags & BCDC_DCMD_ERROR)
>> -        ret = le32_to_cpu(msg->status);
>> +        *fwerr = le32_to_cpu(msg->status);
>>
>>   done:
>>       return ret;

[...]

>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
>> index 2404f8a..8a8e08f 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
>> @@ -30,9 +30,9 @@ struct brcmf_proto {
>>       int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
>>                  struct sk_buff *skb, struct brcmf_if **ifp);
>>       int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
>> -              void *buf, uint len);
>> +              void *buf, uint len, int *fwerr);
>>       int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
>> void *buf,
>> -            uint len);
>> +            uint len, int *fwerr);
>>       int (*tx_queue_data)(struct brcmf_pub *drvr, int ifidx,
>>                    struct sk_buff *skb);
>>       int (*txdata)(struct brcmf_pub *drvr, int ifidx, u8 offset,
>> @@ -71,14 +71,16 @@ static inline int brcmf_proto_hdrpull(struct
>> brcmf_pub *drvr, bool do_fws,
>>       return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
>>   }
>>   static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int
>> ifidx,
>> -                     uint cmd, void *buf, uint len)
>> +                     uint cmd, void *buf, uint len,
>> +                     int *fwerr)
>>   {
>> -    return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len);
>> +    return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len,fwerr);
> A blank space is missing before fwerr.

Good catch. Will fix it.

Thanks,
Arend
