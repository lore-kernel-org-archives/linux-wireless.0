Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaI2KxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 06:53:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: request firmware flush in ath10k_flush.
References: <1411151304-31544-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQm1rZO+yBbYxihpgEvR1cGZWS4Pr0AP+KMODcG4jpd_jQ@mail.gmail.com>
	<5421818A.9040501@candelatech.com>
	<CA+BoTQkZaGSkC9mhE8UF0He0RZWmPghDukdE1A5qiO1UNAZj5Q@mail.gmail.com>
Date: Mon, 29 Sep 2014 13:53:05 +0300
In-Reply-To: <CA+BoTQkZaGSkC9mhE8UF0He0RZWmPghDukdE1A5qiO1UNAZj5Q@mail.gmail.com>
	(Michal Kazior's message of "Wed, 24 Sep 2014 08:50:38 +0200")
Message-ID: <871tqu3dgu.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_125317_822194_63FA9B0B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 23 September 2014 16:19, Ben Greear <greearb@candelatech.com> wrote:
>> On 09/23/2014 02:16 AM, Michal Kazior wrote:
>>> On 19 September 2014 20:28,  <greearb@candelatech.com> wrote:
>>> [...]
>>>>
>>>> +       /* If we are CT firmware, ask it to flush all tids on all peers
>>>> on
>>>> +        * all vdevs.  Normal firmware will just crash if you do this.
>>>> +        */
>>>> +       if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
>>>> +               ath10k_wmi_peer_flush(ar, 0xFFFFFFFF, peer_addr,
>>>> 0xFFFFFFFF);
>>>
>>> I recall you've explained this some time ago, but can you refresh my
>>> memory, please? Is this any different from iterating over all peers
>>> and flushing each? Or does your firmware do so extra magic that is
>>> impossible to do with normal firmware commands?
>>
>> My firmware does that iteration internally.
>>
>> You could probably do that in the driver, but it would be a lot
>> of messages (for all vdevs, all peers, all tids)...
>> I was not sure if there were limits to the number
>> of commands you should attempt during the flush...
>
> Thanks. I think ath10k should do this instead of having CT-specific
> flush eventually.

I agree. We should not be forking functionality unless absolutely
necessary.

-- 
Kalle Valo
