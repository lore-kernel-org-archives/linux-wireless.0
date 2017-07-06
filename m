Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lucky1.263xmail.com ([211.157.147.133]:45406 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdGFIrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 04:47:37 -0400
Message-ID: <595DF921.2020108@rock-chips.com> (sfid-20170706_104759_945620_5F9822DC)
Date: Thu, 06 Jul 2017 16:47:29 +0800
From: jeffy <jeffy.chen@rock-chips.com>
MIME-Version: 1.0
To: Brian Norris <briannorris@chromium.org>
CC: linux-wireless@vger.kernel.org, akarwar@marvell.com,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mwifiex: uninit wakeup info when failed to add card
References: <1499068470-8022-1-git-send-email-jeffy.chen@rock-chips.com> <20170705180813.GA115427@google.com>
In-Reply-To: <20170705180813.GA115427@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi brian,

On 07/06/2017 02:08 AM, Brian Norris wrote:
> On Mon, Jul 03, 2017 at 03:54:30PM +0800, Jeffy Chen wrote:
>> We inited wakeup info at the beginning of mwifiex_add_card, so we need
>> to uninit it in the error handling.
>>
>> It's much the same as what we did in:
>> 36908c4 mwifiex: uninit wakeup info when removing device
>
> Yeah, I noticed I hadn't covered all the error cases, so your change is
> part of the fix. But you're not covering the error paths when the
> firmware doesn't load correctly -- this happens asynchronously to
> mwifiex_add_card(). i.e., you need to fixup the error paths in
> _mwifiex_fw_dpc() too.
right, so we need to uninit it before every mwifiex_free_adapter :)
>
> Brian
>
>> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
>>
>> ---
>>
>>   drivers/net/wireless/marvell/mwifiex/main.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
>> index f2600b8..17d2cbe 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/main.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
>> @@ -1655,6 +1655,8 @@ mwifiex_add_card(void *card, struct completion *fw_done,
>>   		mwifiex_shutdown_drv(adapter);
>>   	}
>>   err_kmalloc:
>> +	if (adapter->irq_wakeup >= 0)
>> +		device_init_wakeup(adapter->dev, false);
>>   	mwifiex_free_adapter(adapter);
>>
>>   err_init_sw:
>> --
>> 2.1.4
>>
>>
>
>
>
