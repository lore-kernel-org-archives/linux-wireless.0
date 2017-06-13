Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.135]:53572 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752774AbdFMGyi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 02:54:38 -0400
Subject: Re: [PATCH] mwifiex: fixes the trivial print
To: Kalle Valo <kvalo@codeaurora.org>
Cc: amitkarwar@gmail.com, huxm@marvell.com, nishants@marvell.com,
        gbhat@marvell.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        briannorris@chromium.org, jeffy.chen@rock-chips.com
References: <1497008411-15223-1-git-send-email-wxt@rock-chips.com>
 <87poe8pfjs.fsf@purkki.adurom.net>
From: Caesar Wang <wxt@rock-chips.com>
Message-ID: <b5621250-c9c8-b413-0dae-88b326c729bf@rock-chips.com> (sfid-20170613_085554_833633_0DC667A3)
Date: Tue, 13 Jun 2017 14:54:15 +0800
MIME-Version: 1.0
In-Reply-To: <87poe8pfjs.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

在 2017年06月13日 14:28, Kalle Valo 写道:
> Caesar Wang <wxt@rock-chips.com> writes:
>
>> We have always met the unused log be printed as following.
>>
>> ...
>> [23193.523182] mwifiex_pcie 0000:01:00.0: mwifiex_get_cfp:
>> cannot find cfp by band 2    & channel=13 freq=0
>> [23378.633684] mwifiex_pcie 0000:01:00.0: mwifiex_get_cfp:
>> cannot find cfp by band 2    & channel=13 freq=0
>>
>> Maybe that's related to wifi regdom, since wifi default area
>> was US and didn't support 12~14 channels.
>>
>> As Frequencies:
>> * 2412 MHz [1] (30.0 dBm)
>> * 2417 MHz [2] (30.0 dBm)
>> * 2422 MHz [3] (30.0 dBm)
>> * 2427 MHz [4] (30.0 dBm)
>> * 2432 MHz [5] (30.0 dBm)
>> * 2437 MHz [6] (30.0 dBm)
>> * 2442 MHz [7] (30.0 dBm)
>> * 2447 MHz [8] (30.0 dBm)
>> * 2452 MHz [9] (30.0 dBm)
>> * 2457 MHz [10] (30.0 dBm)
>> * 2462 MHz [11] (30.0 dBm)
>> * 2467 MHz [12] (disabled)
>> * 2472 MHz [13] (disabled)
>> * 2484 MHz [14] (disabled)
>>
>> Signed-off-by: Caesar Wang <wxt@rock-chips.com>
>> ---
>>
>>   drivers/net/wireless/marvell/mwifiex/cfp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
>> index 1ff2205..6e29943 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/cfp.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
>> @@ -350,7 +350,7 @@ mwifiex_get_cfp(struct mwifiex_private *priv, u8 band, u16 channel, u32 freq)
>>   		}
>>   	}
>>   	if (i == sband->n_channels) {
>> -		mwifiex_dbg(priv->adapter, ERROR,
>> +		mwifiex_dbg(priv->adapter, WARN,
>>   			    "%s: cannot find cfp by band %d\t"
>>   			    "& channel=%d freq=%d\n",
>>   			    __func__, band, channel, freq);
> I don't see how this fixes anything, care to explain? And the title is
> quite vague.

Sorry for the description maybe unclear.
I'm assuming the print log is expected for marvel wifi driver. Do we 
should use 'WARN' to instead of the 'ERROR' here.

>
> And I would rather fix the root cause, mwifiex folks please comment.

Indeed, that's my expected.


-Caesar
>
