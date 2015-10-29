Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35615 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbbJ2XeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:34:24 -0400
Received: by pasz6 with SMTP id z6so54238356pas.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:34:24 -0700 (PDT)
Subject: Re: [PATCH] wcn36xx: Remove warning message when dev is NULL for
 arm64 dma_alloc.
To: Kalle Valo <kvalo@codeaurora.org>
References: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
 <878u6lo34e.fsf@kamboji.qca.qualcomm.com> <5632AC81.6090905@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	me@bobcopeland.com, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
From: "fengwei.yin" <fengwei.yin@linaro.org>
Message-ID: <5632ACFA.1090709@linaro.org> (sfid-20151030_003427_698940_474A4FBF)
Date: Fri, 30 Oct 2015 07:34:18 +0800
MIME-Version: 1.0
In-Reply-To: <5632AC81.6090905@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/10/30 7:32, fengwei.yin wrote:
>
> On 2015/10/30 4:01, Kalle Valo wrote:
>> "Yin, Fengwei" <fengwei.yin@linaro.org> writes:
>>
>>> arm64 has requirement that all the dma operations have actual device.
>>> Otherwise, following warnning message shown and dma allocation fails:
>>>
>>> WARNING: CPU: 0 PID: 954 at arch/arm64/mm/dma-mapping.c:106
>>> __dma_alloc+0x24c/0x258()
>>> Use an actual device structure for DMA allocation
>>> Modules linked in: wcn36xx wcn36xx_platform
>>> CPU: 0 PID: 954 Comm: ifconfig Not tainted 4.0.0+ #14
>>> Hardware name: Qualcomm Technologies, Inc. MSM 8916 MTP (DT)
>>> Call trace:
>>> [<ffffffc000089904>] dump_backtrace+0x0/0x124
>>> [<ffffffc000089a38>] show_stack+0x10/0x1c
>>> [<ffffffc000627114>] dump_stack+0x80/0xc4
>>> [<ffffffc0000b2e64>] warn_slowpath_common+0x98/0xd0
>>> [<ffffffc0000b2ee8>] warn_slowpath_fmt+0x4c/0x58
>>> [<ffffffc00009487c>] __dma_alloc+0x248/0x258
>>> [<ffffffbffc009270>] wcn36xx_dxe_allocate_mem_pools+0xc4/0x108 [wcn36xx]
>>> [<ffffffbffc0079c4>] wcn36xx_start+0x38/0x240 [wcn36xx]
>>> [<ffffffc0005f161c>] ieee80211_do_open+0x1b0/0x9a4
>>> [<ffffffc0005f1e68>] ieee80211_open+0x58/0x68
>>> [<ffffffc00051693c>] __dev_open+0xb0/0x120
>>> [<ffffffc000516c10>] __dev_change_flags+0x88/0x150
>>> [<ffffffc000516cf4>] dev_change_flags+0x1c/0x5c
>>> [<ffffffc000570950>] devinet_ioctl+0x644/0x6f0
>>>
>>> Signed-off-by: Yin, Fengwei <fengwei.yin@linaro.org>
>>
>> Please fix your name. I don't know why but your name in git statistics
>> is now "yfw":
>>
>> yfw (1):
>>        wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
>>
>> The right format for both From header and Signed-off-by line is:
>>
>> First Lastname <username@example.com>
>>
>
> It looks like everything is fine in my side. Could you please check your
> .mailmap whether the email was mapped to "yfw"?
                    ~~~~~~~~~~ typo fix: "my email address"
>
> It's possible my name was added to your .mailmap because I sent patch to
> mail list with my email client other than git-send-email. "yfw" was used
> in my email client. Thanks.
>
> Regards
> Yin, Fengwei
