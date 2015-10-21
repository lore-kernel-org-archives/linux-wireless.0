Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37238 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbJUH2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 03:28:09 -0400
Received: by wicfv8 with SMTP id fv8so61209352wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2015 00:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56273D3F.6080804@gmail.com>
References: <20151020112513.14879.47438.stgit@potku.adurom.net>
	<5625E6BD.6020307@gmail.com>
	<CA+BoTQnSQmdCCqF43+Q5cxyVVLrM_BxRMT+Ydpfe6_5yRV2+Lw@mail.gmail.com>
	<56273D3F.6080804@gmail.com>
Date: Wed, 21 Oct 2015 09:28:08 +0200
Message-ID: <CA+BoTQ=y3-AmpTbpurCvEd2RxQHmMjbU+r7Gy57oz9LsC3VR1Q@mail.gmail.com> (sfid-20151021_092813_894026_4763FA37)
Subject: Re: [PATCH v2] ath10k: add FW API support to test mode
From: Michal Kazior <michal.kazior@tieto.com>
To: Manikanta <manikanta.pubbisetty@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2015 at 09:22, Manikanta <manikanta.pubbisetty@gmail.com> wrote:
> On Wednesday 21 October 2015 12:36 PM, Michal Kazior wrote:
>> On 20 October 2015 at 09:01, Manikanta Pubbisetty
>> <manikanta.pubbisetty@gmail.com> wrote:
>>> On 10/20/2015 04:55 PM, Kalle Valo wrote:
>>>>
>>>> From: Alan Liu <alanliu@qca.qualcomm.com>
>>>>
>>>> Add WMI-TLV and FW API support in ath10k testmode.
>>>> Ath10k can get right wmi command format from UTF image
>>>> to communicate UTF firmware.
>>>>
>>>> Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
>>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>>> ---
[...]
>>>> +       /* loop elements */
>>>> +       while (len > sizeof(struct ath10k_fw_ie)) {
>>>> +               hdr = (struct ath10k_fw_ie *)data;
>>>> +
>>>> +               ie_id = le32_to_cpu(hdr->id);
>>>> +               ie_len = le32_to_cpu(hdr->len);
>>>> +
>>>> +               len -= sizeof(*hdr);
>>>> +               data += sizeof(*hdr);
>>>> +
>>>> +               if (len < ie_len) {
>>>> +                       ath10k_err(ar, "invalid length for FW IE %d (%zu
>>>> <
>>>> %zu)\n",
>>>> +                                  ie_id, len, ie_len);
>>>> +                       ret = -EINVAL;
>>>> +                       goto err;
>>>> +               }
>>>> +
>>>> +               switch (ie_id) {
>>>> +               case ATH10K_FW_IE_FW_VERSION:
>>>
>>>
>>> Something like ATH10K_UTF_IE_FW_VERSION or ATH10K_TESTMODE_IE_FW_VERSION
>>> would be less confusing and better, isn't it?
>>
>> I don't really see a reason to. UTF is just another main program to
>> run on the device.
>>
>> If anything I would suggest to unify the FW API parsing logic to work
>> with a dedicated structure instead of `struct ath10k` directly, i.e.
>>
>>    struct ath10k_fw {
>>      void *data;
>>      size_t data_len;
>>      enum wmi_op_version wmi_op_version;
>>      // ...
>>    };
>>
>>    int ath10k_core_fw_api_parse(struct ath10k *ar,
>>                                 struct ath10k_fw *arfw,
>>                                 struct firmware *fw)
>>     {
>>       // parse and fill in `arfw`
>>     }
>>
>>    struct ath10k {
>>      // ...
>>      struct ath10k_fw fw_normal;
>>      struct ath10k_fw fw_utf;
>>      // ...
>>    };
>>
>>
>> Michał
>
> Hmmm, this way we will have a unified firmware parsing logic. Is this a task
> which can be taken up easily or any other hidden complexities are invloved
> ?.

Decoupling the parsing logic should be rather easy. I don't think
there are any gotchas.


> I mean can we do the changes for current parsing logic and then rework the
> test mode patch ? what is your suggestion ?

If you want to do the unified parsing logic approach you should first
decouple the logic (i.e. make it not fill `struct ath10k` directly)
and then rework the testmode patch on top of that.


Michał
