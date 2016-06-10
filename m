Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:32953 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbcFJMw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:52:59 -0400
Message-ID: <575AB829.10101@candelatech.com> (sfid-20160610_145302_967861_3B86E8D4)
Date: Fri, 10 Jun 2016 05:52:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org, "A. Benz" <ash.benz@bk.ru>
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru> <CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com> <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name> <877fdxfd2l.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877fdxfd2l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/10/2016 05:22 AM, Kalle Valo wrote:
> Felix Fietkau <nbd@nbd.name> writes:
>
>> On 2016-06-10 10:50, Michal Kazior wrote:
>>> On 9 June 2016 at 09:46, A. Benz <ash.benz@bk.ru> wrote:
>>>> Dear All,
>>>>
>>>> I am using LEDE on my IPQ806x (QCA9980) system (Archer C2600).
>>>> With compat-wireless-2016-05-12, I observed traces attached below.
>>>> The router is unstable and eventually reboots by itself (randomly).
>>>>
>>>> Upon reverting to compat-wireless-2016-01, the issue disappears. Nothing
>>>> else is changed (software-wise or hardware).
>>>> This was confirmed with other users.
>>>>
>>>> A new compile with the fixes below:
>>>> https://git.lede-project.org/?p=lede/nbd/staging.git;a=commit;h=858e26f3c0fc11231f25497cbb2ddca1e5f101e0
>>>>
>>>> Did not solve the problem.
>>>>
>>>> Please let me know if I need to provide any further information.
>>>>
>>>> ------------[ cut here ]------------
>>>> WARNING: CPU: 0 PID: 558 at
>>>> compat-wireless-2016-05-12/net/mac80211/rx.c:4068
>>>> ieee80211_rx_napi+0x8c/0x8a4 [mac80211]()
>>>
>>> Can you post what is at rx.c line 4068 (and +/- 3 lines), please?
>> It's early in ieee80211_rx_napi:
>>
>>      sband = local->hw.wiphy->bands[status->band];
>>      if (WARN_ON(!sband))
>>          goto drop;
>>
>> I could not easily find a scenario under which status->band would not be
>> set properly by the driver, so my guess is there is some nasty memory
>> corruption going on.
>>
>> FWIW, I've received several reports like this from different people on
>> different devices. They're also confirming that reverting to the
>> snapshot from January makes things stable again.
>
> Adding ath10k list to the loop.

This looks a lot like the problems I was having.

Two of these 5 patches recently made it upstream (but may not be in LEDE yet),
but the other patches also were related to memory corruption.

See my patches posted on 4/1/16:

https://patchwork.kernel.org/project/ath10k/list/

I don't know where the 5/5 patch ended up.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
