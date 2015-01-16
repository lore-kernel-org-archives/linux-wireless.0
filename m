Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45515 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbbAPPdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 10:33:32 -0500
Received: by mail-wg0-f54.google.com with SMTP id z12so21134033wgg.13
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 07:33:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87iog8ryes.fsf@kamboji.qca.qualcomm.com>
References: <20150106035319.GA4082@vaishali-Ideapad-Z570>
	<87iog8ryes.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 16 Jan 2015 21:03:31 +0530
Message-ID: <CAK-LDbKfK5zda00xJTEq56Wwi7eVwuFUWD=X9pf505iwexEiZw@mail.gmail.com> (sfid-20150116_163335_769922_390E766D)
Subject: Re: [PATCH] brcmfmac: Use put_unaligned_le32
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 15, 2015 at 6:30 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Vaishali Thakkar <vthakkar1994@gmail.com> writes:
>
>> This patch introduces the use of function put_unaligned_le32.
>>
>> This is done using Coccinelle and semantic patch used is as follows:
>>
>> @a@
>> typedef u32, __le32, uint32_t;
>> {u32,__le32,uint32_t} e32;
>> identifier tmp;
>> expression ptr;
>> expression y,e;
>> type T;
>> type T;
>> @@
>>
>> - tmp = cpu_to_le32(y);
>>
>> <+... when != tmp
>> (
>> - memcpy(ptr, (T)&tmp, \(4\|sizeof(u32)\|sizeof(__le32)\|sizeof(uint32_t)\|s
>> + put_unaligned_le32(y,ptr);
>> |
>> - memcpy(ptr, (T)&tmp, ...);
>> + put_unaligned_le32(y,ptr);
>> )
>> ...+>
>> ? tmp = e
>>
>> @@ type T; identifier a.tmp; @@
>>
>> - T tmp;
>> ...when != tmp
>>
>> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
>
> This failed to apply, please rebase:
>
> Applying: brcmfmac: Use put_unaligned_le32
> error: drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: does not exist in index
> Patch failed at 0001 brcmfmac: Use put_unaligned_le32
>

Yes. Sorry. Because of some technical problems with my machine, I
couldn't be able to send new patch as I didn't have code with me.
Actually I sent follow up mail to John about dropping this patch
[about 6 days back] until I rebase it. But forgot to cced it to
mailing list. I will send rebased patch.

Sorry again.

> --
> Kalle Valo



-- 
Vaishali
