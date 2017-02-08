Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40260 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752823AbdBHOyB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 09:54:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?Q?Rafa=C5=82?= =?utf-8?Q?_Mi=C5=82ecki?=
        <zajec5@gmail.com>, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the __brcmf_err
References: <20170202213321.11591-1-zajec5@gmail.com>
        <20170202213321.11591-4-zajec5@gmail.com>
        <2812805e-9108-284f-2165-34624d603364@broadcom.com>
        <209e8eef55927a76470d44482c6d0090@milecki.pl>
Date: Wed, 08 Feb 2017 16:52:54 +0200
In-Reply-To: <209e8eef55927a76470d44482c6d0090@milecki.pl> (=?utf-8?Q?=22R?=
 =?utf-8?Q?afa=C5=82_Mi=C5=82ecki=22's?=
        message of "Wed, 08 Feb 2017 11:00:47 +0100")
Message-ID: <87tw84loop.fsf@kamboji.qca.qualcomm.com> (sfid-20170208_155518_376718_B365F1AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> writes:

> On 2017-02-08 10:54, Arend Van Spriel wrote:
>> On 2-2-2017 22:33, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> This will allow getting struct device reference from the passed
>>> brcmf_pub for the needs of dev_err. More detailed messages are really
>>> important for home routers which frequently have 2 (or even 3)
>>> wireless
>>> cards supported by brcmfmac.
>>>
>>> Note that all calls are yet to be updated as for now brcmf_err macro
>>> always passes NULL. This will be handled in following patch to make
>>> this
>>> change easier to review.
>>
>> I prefer brcmf_err() to have struct device reference directly
>> instead of
>> using brcmf_pub. That would remove the need for patches 5 till 7 as bus
>> specific code already has struct device. So I have acked the first
>> three
>> patches, but would like to revise 8 and 9.
>>
>> Kalle,
>>
>> I acked the first three patches. Can those three still go in for 4.11?
>
> Sounds OK to me. Kalle, I ack Arend's request if it isn't too late.

Ok, I'll try. My plan is to get everything ready for linux-next by
tomorrow morning (Finland time), let's see how it goes.

Related to this, Rafa=C5=82 are you still deleting the patches from patchwo=
rk
which should be dropped? I think you are as I can't see patches 4-9
anymore.

Now that my patchwork setup is much better (compared to how it was over
a year ago) I would actually prefer that you don't do that anymore. The
problem is that when you delete the patch from patchwork it completely
disappears from patchwork and I can't check the patch or discussion
anymore. And I'm so accustomed to use patchwork that only seldom I use
email to find the patch.

So it would be better to leave the patches as is and let me drop them
(=3Dchange the state Changes Requested, Rejected or similar), which is
trivial with my script. Otherwise I get this unsure feeling of what
happened to the patch :)

--=20
Kalle Valo
