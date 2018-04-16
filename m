Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52060 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbeDPOli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 10:41:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH 5/5] wcn36xx: pass information elements in scan requests
References: <20180416131634.25432-1-daniel@zonque.org>
        <20180416131634.25432-6-daniel@zonque.org>
        <87lgdnp7sy.fsf@kamboji.qca.qualcomm.com>
        <0595a559-8220-bc22-0c33-4580119c774d@zonque.org>
        <87h8obp7c0.fsf@kamboji.qca.qualcomm.com>
        <384e608f-0f59-8ba6-5223-8a52e2ac86f9@zonque.org>
Date: Mon, 16 Apr 2018 17:41:32 +0300
In-Reply-To: <384e608f-0f59-8ba6-5223-8a52e2ac86f9@zonque.org> (Daniel Mack's
        message of "Mon, 16 Apr 2018 16:29:03 +0200")
Message-ID: <87d0yzp61v.fsf@kamboji.qca.qualcomm.com> (sfid-20180416_164144_093477_70638320)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> On Monday, April 16, 2018 04:13 PM, Kalle Valo wrote:
>> Daniel Mack <daniel@zonque.org> writes:
>>> On Monday, April 16, 2018 04:03 PM, Kalle Valo wrote:
>>>> Daniel Mack <daniel@zonque.org> writes:
>
>>>>> them to the firmware message. The driver currently tells the core that
>>>>> it is capable of attaching up to WCN36XX_MAX_SCAN_IE_LEN octets, but
>>>>> doesn't actually pass them to the the hardware.
>>>>>
>>>>> Some defines were moved around to avoid cyclic include dependencies.
>>>>
>>>> Does this fix anything or change functionality somehow? You should
>>>> document that also in the commit log.
>>>
>>> I don't have a test case for this, no. But as the change was pretty much
>>> straight forward, I sent it anyway.
>> 
>> Ok, but you should still explain that in the commit log. In other words,
>> you should always answer the question "Why?" in the commit log.
>> 
>>> I can resend with some more information on this if you like.
>> 
>> No need to resend because of this, I can edit the commit log.
>
> Hmm, given that I can't even be sure the firmware does the right thing
> when instructed this way, we should probably just drop this patch from
> the series. The others are more important anyway, as they address bugs
> that hit me on actual hardware.

IMHO it's useful and if you don't see anything breaking I would prefer
to take it anyway. I can't immeadiately say in what use cases this helps
or fixes, though. But maybe you (or someone else) could verify that it
works correctly by comparing before and after probe requests with a
sniffer?

-- 
Kalle Valo
