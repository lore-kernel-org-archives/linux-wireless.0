Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:40358 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1171728AbdDXNpj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 09:45:39 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3ODiAHm001244
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 14:45:36 +0100
Received: from mail-wm0-f71.google.com (mail-wm0-f71.google.com [74.125.82.71])
        by mx08-00252a01.pphosted.com with ESMTP id 29yunf93nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 14:45:36 +0100
Received: by mail-wm0-f71.google.com with SMTP id 65so1946652wmi.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 06:45:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f2c96267-8fec-f878-760d-90e93323d807@broadcom.com>
References: <20170420154704.32144-1-james.hughes@raspberrypi.org> <f2c96267-8fec-f878-760d-90e93323d807@broadcom.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Mon, 24 Apr 2017 14:45:34 +0100
Message-ID: <CAE_XsMKL_+ZsrgTv8yTbMuHMpKxbUYfKZFYJBzsSfRqXkoXs=w@mail.gmail.com> (sfid-20170424_154601_412847_1845CC05)
Subject: Re: [PATCH] brcm80211: brcmfmac: Ensure header writes are on writable skb
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 April 2017 at 20:22, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 4/20/2017 5:47 PM, James Hughes wrote:
>>
>> Driver was writing to skb header area without ensuring it was
>> writable i.e. uncloned.
>>
>> Used skb_cow_header to ensure that header buffer is large enough
>> and is uncloned.
>>
>> Detected when, in combination with the smsc85xx driver, both drivers
>> attempted to write different headers to the same header buffer.
>
>
> I guess this patch is limited to one file to address the comment from Eric
> Dumazet. I prefer to talk through the initial patch you sent. Just a
> procedural remark or two here. 1) Please drop 'brcm80211:' from the Subject
> as the 'brcmfmac' prefix is sufficient, and 2) despite the change of the
> Subject you should consider this version 2 of the initial patch so the
> Subject should read '[PATCH V2] brcmfmac: ....'.
>
>> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
>> ---
>
> Related to remark 2) above you should provide a changelog here listing what
> is changed compared to the initial patch.
>
> Regards,
> Arend
>
> ---
>>
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 15
>> +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>
>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> index 038a960..b9d7d08 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
>> @@ -249,14 +249,19 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr,
>> int ifidx, uint cmd,
>>         return ret;
>>   }
>>   -static void
>> +static int
>>   brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
>>                          struct sk_buff *pktbuf)
>>   {
>>         struct brcmf_proto_bcdc_header *h;
>> +       int err;
>>         brcmf_dbg(BCDC, "Enter\n");
>>   +     err = skb_cow_head(pktbuf, BCDC_HEADER_LEN);
>> +       if (err)
>> +               return err;
>> +
>>         /* Push BDC header used to convey priority for buses that don't */
>>         skb_push(pktbuf, BCDC_HEADER_LEN);
>>   @@ -271,6 +276,8 @@ brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int
>> ifidx, u8 offset,
>>         h->data_offset = offset;
>>         BCDC_SET_IF_IDX(h, ifidx);
>>         trace_brcmf_bcdchdr(pktbuf->data);
>> +
>> +       return 0;
>>   }
>>     static int
>> @@ -330,7 +337,11 @@ static int
>>   brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
>>                         struct sk_buff *pktbuf)
>>   {
>> -       brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
>> +       int err = brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
>> +
>> +       if (err)
>> +               return err;
>> +
>>         return brcmf_bus_txdata(drvr->bus_if, pktbuf);
>>   }
>>

This patch has been superseded, please ignore.
