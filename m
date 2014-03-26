Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:55958 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaCZTl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:41:28 -0400
Received: by mail-lb0-f182.google.com with SMTP id n15so1892244lbi.13
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:41:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5332E6C6.7040700@candelatech.com>
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
	<871txr7svw.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmquq7dXTV0sSV1mJ0+8-9OuiCnqz2iN8VNO4J3iaeexQ@mail.gmail.com>
	<53306239.2020006@candelatech.com>
	<CA+BoTQkCmJbvQjZ3vTV7AP1EwdcH_pAd0pex_v9bZDzwZdufbw@mail.gmail.com>
	<53319D65.4090907@candelatech.com>
	<CA+BoTQnMmwsz0438yVrP_bQ-AKZaoktW7NrGAODVEx4w21-dEA@mail.gmail.com>
	<5332E6C6.7040700@candelatech.com>
Date: Wed, 26 Mar 2014 20:41:26 +0100
Message-ID: <CALhHN=o+G2vmou_Kofz--+fE-cvQcBXg9MZv4ERd9ik8EZLUiw@mail.gmail.com> (sfid-20140326_204133_170364_8A98C9D1)
Subject: Re: [PATCH 1/3] ath10k: Add debugging for tx-credits usage.
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 March 2014 15:40, Ben Greear <greearb@candelatech.com> wrote:
> On 03/26/2014 12:18 AM, Michal Kazior wrote:
>>
>> On 25 March 2014 16:14, Ben Greear <greearb@candelatech.com> wrote:
>>>
>>> On 03/25/2014 12:27 AM, Michal Kazior wrote:
>>>>
>>>>
>>>> On 24 March 2014 17:50, Ben Greear <greearb@candelatech.com> wrote:
>>>>>
>>>>>
>>>>> On 03/24/2014 04:21 AM, Michal Kazior wrote:
>>>>>>
>>>>>>
>>>>>> On 24 March 2014 12:12, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>>>>> -     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
>>>>>>>> +     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Using line numbers in debug messages is very cumbersome. Some people
>>>>>>> cherry pick patches, have their own changes and whatnot which will
>>>>>>> make
>>>>>>> it more difficult to read the debug logs. Isn't there any better way
>>>>>>> to
>>>>>>> do this?
>>>>>>
>>>>>>
>>>>>>
>>>>>> I would prefer to explicitly wait for tx credit replenishment in
>>>>>> ath10k_wmi_cmd_send() after a command is sent instead of all these
>>>>>> prints. This way you can get a full call trace if it times out.
>>>>>
>>>>>
>>>>>
>>>>> Would that be a performance problem (by effectively allowing only a
>>>>> single
>>>>> item to be sent to the firmware at any given time?)
>>>>
>>>>
>>>>
>>>> The only thing that may suffer here is wmi mgmt tx but I wouldn't
>>>> consider that performance critical.
>>>
>>>
>>>
>>> In that case, why use credits at all?
>>
>>
>> Excellent question.
>>
>> Firmware provides 2 HTC tx credits for WMI. I guess this is on
>> purpose. I imagine WMI mgmt tx can hang (i.e. not replenish tx
>> credits). In that case the remaining tx credit could be used to try
>> recovering, e.g. down/stop vdev (I think it should drop all pending tx
>> and thus free the stuck HTC tx credit).
>>
>> It might be a good idea to keep this recovery strategy in mind when
>> implementing the "wait for tx replenishment" wmi tx blocking.
>
>
> Seems to me we should just fix the firmware to respond quickly..and if we
> know exactly which
> command is not being answered (quickly) in the firmware, it might be easier
> to debug
> it.
>
> That said, while debugging I think I have seen cases where one message would
> be consumed for a long time, and then suddenly it frees up again.
>
> So, I'm not sure what to do.  Maybe could improve firmware to return an id
> so we know exactly which of the messages was processed, and then the driver
> could do the work of figuring out what commands are outstanding by just
> keeping
> a copy in RAM....
>

I suspect mgmt_tx frames (for AP FW we send them using WMI) without
ACK couse this problem (disassoc + deauth probably). Question if we
saw this problem with 636 firmware? In 636 we send mgmt frames using
HTT, so we don't consume WMI credits.

I will try to reproduce this tommorow.

BR
Janusz
