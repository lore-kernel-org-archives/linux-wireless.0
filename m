Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61737 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaH0IPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 04:15:41 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so15552846wgh.29
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 01:15:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878umaxujj.fsf@kamboji.qca.qualcomm.com>
References: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
	<1408961963-3682-4-git-send-email-michal.kazior@tieto.com>
	<878umaxujj.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 27 Aug 2014 10:15:40 +0200
Message-ID: <CA+BoTQnM+CVnaFLAfGr=0QdRCCgSGUcGEGeDijh6nS6tYO5DyA@mail.gmail.com> (sfid-20140827_101548_937926_BE404C09)
Subject: Re: [PATCH v2 3/3] ath10k: make target endianess more explicit
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2014 09:26, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Some copy engine structures are target specific
>> and are uploaded to the device during
>> init/configuration.
>>
>> This also cleans up a bit diag_mem_read/write
>> implicit byteswap mess leaving only
>> diag_access_read/write with an implicit endianess
>> byteswap.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>>  static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
>>  {
>> -     return ath10k_pci_diag_read_mem(ar, address, value, sizeof(u32));
>> +     __le32 val = 0;
>> +     int ret;
>> +
>> +     ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(__le32));
>> +     *value = __le32_to_cpu(val);
>> +
>> +     return ret;
>>  }
>
> For consistency, I folded a patch below. Is that ok?
>
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -620,7 +620,7 @@ static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
>         __le32 val = 0;
>         int ret;
>
> -       ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(__le32));
> +       ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(val));
>         *value = __le32_to_cpu(val);
>
>         return ret;
>
> https://github.com/kvalo/ath/commit/1850a415873cb34a6f84b699dfb9a283df3252ec

I'm okay with that, thanks.


Michał
