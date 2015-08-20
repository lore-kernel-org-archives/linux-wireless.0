Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33977 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbHTPxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:53:25 -0400
Received: by iodb91 with SMTP id b91so50749024iod.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 08:53:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D4F864.4000604@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<1436553071-32423-2-git-send-email-arend@broadcom.com>
	<CACna6ryt8iVUt18fODjDMiD-c3RLM22T2J_PM8NtEvBvWm8yBg@mail.gmail.com>
	<55D4F34D.2010505@broadcom.com>
	<55D4F864.4000604@broadcom.com>
Date: Thu, 20 Aug 2015 17:53:24 +0200
Message-ID: <CACna6rzJGChrpqTL9FrVvrcMk5haiukQHNX+v29VoS1gGtXDUA@mail.gmail.com> (sfid-20150820_175328_457154_4B651150)
Subject: Re: [PATCH v2 1/7] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2015 at 23:43, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/19/2015 11:21 PM, Arend van Spriel wrote:
>>
>> subject changed to v2. So let's go over your beef.
>>
>> On 07/11/2015 07:09 PM, Rafał Miłecki wrote:
>>>
>>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>>>
>>>> @@ -146,7 +147,7 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
>>>>          u32 cplen;
>>>>
>>>>          c = nvp->data[nvp->pos];
>>>> -       if (!is_nvram_char(c)) {
>>>> +       if (!is_nvram_char(c) && (c != ' ')) {
>>>
>>>
>>> This is redundant, please drop this change.
>>> See fc23e81eb8f4 ("brcmfmac: allow NVRAM values to contain spaces")
>>
>>
>> done
>>
>>>> @@ -426,19 +428,34 @@ static void brcmf_fw_request_nvram_done(const
>>>> struct firmware *fw, void *ctx)
>>>>          struct brcmf_fw *fwctx = ctx;
>>>>          u32 nvram_length = 0;
>>>>          void *nvram = NULL;
>>>> +       u8 *data = NULL;
>>>
>>>
>>> This can be const.
>>
>>
>> done
>
>
> Actually this is not done, but either way will require a cast because
> bcm47xx_nvram_release_contents expects char* so there is nothing gained.
> Unless someone will change bcm47xx_nvram_get/release_contents api to const
> char*.

Passing non-const pointer to function taking const one is OK. You
don't need casting, compiler won't complain about this.

On the other hand casing const pointer to the non-const one is hacky
and I believe you should avoid that.
