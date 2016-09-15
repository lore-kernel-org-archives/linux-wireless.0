Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46968 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752318AbcIOOMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:12:54 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 10/21] ath10k: support logging ath10k_info as
 KERN_DEBUG
Date: Thu, 15 Sep 2016 14:12:48 +0000
Message-ID: <87fup1b6ao.fsf@kamboji.qca.qualcomm.com> (sfid-20160915_161258_582875_C9398646)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-11-git-send-email-greearb@candelatech.com>
        <87k2eeef79.fsf@kamboji.qca.qualcomm.com>       <57D9696B.10103@candelatech.com>
In-Reply-To: <57D9696B.10103@candelatech.com> (Ben Greear's message of "Wed,
        14 Sep 2016 08:14:51 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/14/2016 07:19 AM, Valo, Kalle wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Helps keep messages off of (serial) console when
>>> that is desired.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> Isn't /proc/sys/kernel/print exactly for this purpose? At least I recall
>> using it.
>
> I just wanted to hide some ath10k logs from the console, not all
> system logs. I don't think that /proc/sys/kernel/print has any
> granularity?

It should be based on KERN_ log levels. I don't know what your kernel
does, but ath10k should be printing only very few messages with level
KERN_INFO or above, all of of the debug messages. So you should be
easily able to filter out all ath10k debug messages as they are sent
with KERN_DEBUG.

--=20
Kalle Valo=
