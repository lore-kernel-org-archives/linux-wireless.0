Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33555 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbbJ1IVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 04:21:36 -0400
Received: by qgeo38 with SMTP id o38so121321qge.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 01:21:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <562EC022.4030302@linaro.org>
References: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
	<CAJAp7OjPmX70ZvSEDuneaDn=yJnOgJVwPTmikrE4HjX2ycdq1Q@mail.gmail.com>
	<562EC022.4030302@linaro.org>
Date: Wed, 28 Oct 2015 08:21:35 +0000
Message-ID: <CAFSJ42ax9=eB+MPkVY_MFaS7zQNaLQ79hwnEAdKccuJ3EUhKJw@mail.gmail.com> (sfid-20151028_092143_974058_3A8CB11F)
Subject: Re: [PATCH] wcn36xx: Remove warning message when dev is NULL for
 arm64 dma_alloc.
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: yfw <fengwei.yin@linaro.org>
Cc: Bjorn Andersson <bjorn@kryo.se>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Bob Copeland <me@bobcopeland.com>,
	Bjorn Andersson <bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me.

2015-10-27 0:06 GMT+00:00 yfw <fengwei.yin@linaro.org>:
>
>
> On 2015/10/27 2:24, Bjorn Andersson wrote:
>>
>> On Sun, Oct 25, 2015 at 7:36 PM, Yin, Fengwei <fengwei.yin@linaro.org>
>> wrote:
>>>
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
>>
>> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>
> Thanks for the Acked-by.
>
> Regards
> Yin, Fengwei
>
>>
>> Regards,
>> Bjorn
>>
>



-- 
Best regards,
Eugene
