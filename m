Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33394 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422742AbbEVJFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 05:05:21 -0400
Received: by igbpi8 with SMTP id pi8so31270348igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 02:05:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555EE972.7040801@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
	<1432123792-4155-7-git-send-email-arend@broadcom.com>
	<CACna6rx_bBogPXZoa24JTqLED4GsGhezjVLZL_De=2uTqevsPA@mail.gmail.com>
	<555EE972.7040801@broadcom.com>
Date: Fri, 22 May 2015 11:05:20 +0200
Message-ID: <CACna6rx3PK9SH44BUDqKTWcWkvpVeGSfbL5Jm31Zj26O=8KK-Q@mail.gmail.com> (sfid-20150522_110533_101089_83F0FDB0)
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2015 at 10:31, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/20/15 17:02, Rafał Miłecki wrote:
>>
>> On 20 May 2015 at 14:09, Arend van Spriel<arend@broadcom.com>  wrote:
>>>
>>> @@ -139,11 +165,11 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
>>>          char *ekv;
>>>          u32 cplen;
>>>
>>> -       c = nvp->fwnv->data[nvp->pos];
>>> -       if (!is_nvram_char(c)) {
>>> +       c = nvp->data[nvp->pos];
>>> +       if (!is_nvram_char(c)&&  (c != ' ')) {
>>
>>
>> Don't smuggle behavior changes in patches doing something else!
>
>
> The subject is "Add support for host platform NVRAM loading" and guess what.
> That type of NVRAM turned out to have spaces in the entries so in my opinion
> it is related to this patch. I can split it up if you feel strongly about
> this.

I'd expect such patch to just implement *loading* from different
source and nothing else. If there are additional changes needed, I
think they should go in separated patch if possible.

I noticed the same problem with parsing NVRAM values and sent
[PATCH] brcmfmac: allow NVRAM values to contain space and '#' chars
, so you should be able to drop this patch of your patch anyway.
You may give me an Ack if you have a moment :)


>>> @@ -406,19 +434,34 @@ static void brcmf_fw_request_nvram_done(const
>>> struct firmware *fw, void *ctx)
>>>          struct brcmf_fw *fwctx = ctx;
>>>          u32 nvram_length = 0;
>>>          void *nvram = NULL;
>>> +       u8 *data = NULL;
>>> +       size_t data_len;
>>> +       bool raw_nvram;
>>>
>>>          brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
>>> -       if (!fw&&  !(fwctx->flags&  BRCMF_FW_REQ_NV_OPTIONAL))
>>> -               goto fail;
>>> +       if ((fw)&&  (fw->data)) {
>>
>>
>> if (fw&&  fw->data)
>> will work just fine, I'm surprised checkpatch doesn't complain.
>
> I ran checkpatch.pl --strict and did not get complaint about this change.

I know, it's weird. Maybe I'll report this an improvement idea to
checkpatch maintainer.

-- 
Rafał
