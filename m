Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36557 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZHSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 03:18:21 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so4364016wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 00:18:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53319D65.4090907@candelatech.com>
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
	<871txr7svw.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmquq7dXTV0sSV1mJ0+8-9OuiCnqz2iN8VNO4J3iaeexQ@mail.gmail.com>
	<53306239.2020006@candelatech.com>
	<CA+BoTQkCmJbvQjZ3vTV7AP1EwdcH_pAd0pex_v9bZDzwZdufbw@mail.gmail.com>
	<53319D65.4090907@candelatech.com>
Date: Wed, 26 Mar 2014 08:18:20 +0100
Message-ID: <CA+BoTQnMmwsz0438yVrP_bQ-AKZaoktW7NrGAODVEx4w21-dEA@mail.gmail.com> (sfid-20140326_081826_275968_BFB4950F)
Subject: Re: [PATCH 1/3] ath10k: Add debugging for tx-credits usage.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2014 16:14, Ben Greear <greearb@candelatech.com> wrote:
> On 03/25/2014 12:27 AM, Michal Kazior wrote:
>>
>> On 24 March 2014 17:50, Ben Greear <greearb@candelatech.com> wrote:
>>>
>>> On 03/24/2014 04:21 AM, Michal Kazior wrote:
>>>>
>>>> On 24 March 2014 12:12, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>
>>>
>>>>>> -     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
>>>>>> +     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
>>>>>
>>>>>
>>>>> Using line numbers in debug messages is very cumbersome. Some people
>>>>> cherry pick patches, have their own changes and whatnot which will make
>>>>> it more difficult to read the debug logs. Isn't there any better way to
>>>>> do this?
>>>>
>>>>
>>>> I would prefer to explicitly wait for tx credit replenishment in
>>>> ath10k_wmi_cmd_send() after a command is sent instead of all these
>>>> prints. This way you can get a full call trace if it times out.
>>>
>>>
>>> Would that be a performance problem (by effectively allowing only a
>>> single
>>> item to be sent to the firmware at any given time?)
>>
>>
>> The only thing that may suffer here is wmi mgmt tx but I wouldn't
>> consider that performance critical.
>
>
> In that case, why use credits at all?

Excellent question.

Firmware provides 2 HTC tx credits for WMI. I guess this is on
purpose. I imagine WMI mgmt tx can hang (i.e. not replenish tx
credits). In that case the remaining tx credit could be used to try
recovering, e.g. down/stop vdev (I think it should drop all pending tx
and thus free the stuck HTC tx credit).

It might be a good idea to keep this recovery strategy in mind when
implementing the "wait for tx replenishment" wmi tx blocking.


Michał
