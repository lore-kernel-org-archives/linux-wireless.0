Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17810 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbbEVIbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:31:49 -0400
Message-ID: <555EE972.7040801@broadcom.com> (sfid-20150522_103213_612369_CB4B00DF)
Date: Fri, 22 May 2015 10:31:46 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>	<1432123792-4155-7-git-send-email-arend@broadcom.com> <CACna6rx_bBogPXZoa24JTqLED4GsGhezjVLZL_De=2uTqevsPA@mail.gmail.com>
In-Reply-To: <CACna6rx_bBogPXZoa24JTqLED4GsGhezjVLZL_De=2uTqevsPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch is dropped, but I still owe you a response to this. I missed 
it because you sent 2 or 3 replies confusing me.

On 05/20/15 17:02, Rafał Miłecki wrote:
> On 20 May 2015 at 14:09, Arend van Spriel<arend@broadcom.com>  wrote:
>> @@ -139,11 +165,11 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
>>          char *ekv;
>>          u32 cplen;
>>
>> -       c = nvp->fwnv->data[nvp->pos];
>> -       if (!is_nvram_char(c)) {
>> +       c = nvp->data[nvp->pos];
>> +       if (!is_nvram_char(c)&&  (c != ' ')) {
>
> Don't smuggle behavior changes in patches doing something else!

The subject is "Add support for host platform NVRAM loading" and guess 
what. That type of NVRAM turned out to have spaces in the entries so in 
my opinion it is related to this patch. I can split it up if you feel 
strongly about this.

>> @@ -406,19 +434,34 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>>          struct brcmf_fw *fwctx = ctx;
>>          u32 nvram_length = 0;
>>          void *nvram = NULL;
>> +       u8 *data = NULL;
>> +       size_t data_len;
>> +       bool raw_nvram;
>>
>>          brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
>> -       if (!fw&&  !(fwctx->flags&  BRCMF_FW_REQ_NV_OPTIONAL))
>> -               goto fail;
>> +       if ((fw)&&  (fw->data)) {
>
> if (fw&&  fw->data)
> will work just fine, I'm surprised checkpatch doesn't complain.

I ran checkpatch.pl --strict and did not get complaint about this change.

Regards,
Arend
