Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 2.mo1.mail-out.ovh.net ([178.32.119.250]:36541 "EHLO
        2.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdBHRFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 12:05:36 -0500
Received: from player691.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id A17B3503A3
        for <linux-wireless@vger.kernel.org>; Wed,  8 Feb 2017 16:10:41 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 08 Feb 2017 16:09:58 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Rafa=C5=82?= =?UTF-8?Q?_Mi=C5=82ecki?=
        <zajec5@gmail.com>, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the
 __brcmf_err
In-Reply-To: <87tw84loop.fsf@kamboji.qca.qualcomm.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
 <20170202213321.11591-4-zajec5@gmail.com>
 <2812805e-9108-284f-2165-34624d603364@broadcom.com>
 <209e8eef55927a76470d44482c6d0090@milecki.pl>
 <87tw84loop.fsf@kamboji.qca.qualcomm.com>
Message-ID: <9c5aaa679783efa47b4e4fb6896f8ee2@milecki.pl> (sfid-20170208_180621_263815_AB8F6871)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-08 15:52, Kalle Valo wrote:
> Rafał Miłecki <rafal@milecki.pl> writes:
> 
>> On 2017-02-08 10:54, Arend Van Spriel wrote:
>>> On 2-2-2017 22:33, Rafał Miłecki wrote:
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>> 
>>>> This will allow getting struct device reference from the passed
>>>> brcmf_pub for the needs of dev_err. More detailed messages are 
>>>> really
>>>> important for home routers which frequently have 2 (or even 3)
>>>> wireless
>>>> cards supported by brcmfmac.
>>>> 
>>>> Note that all calls are yet to be updated as for now brcmf_err macro
>>>> always passes NULL. This will be handled in following patch to make
>>>> this
>>>> change easier to review.
>>> 
>>> I prefer brcmf_err() to have struct device reference directly
>>> instead of
>>> using brcmf_pub. That would remove the need for patches 5 till 7 as 
>>> bus
>>> specific code already has struct device. So I have acked the first
>>> three
>>> patches, but would like to revise 8 and 9.
>>> 
>>> Kalle,
>>> 
>>> I acked the first three patches. Can those three still go in for 
>>> 4.11?
>> 
>> Sounds OK to me. Kalle, I ack Arend's request if it isn't too late.
> 
> Ok, I'll try. My plan is to get everything ready for linux-next by
> tomorrow morning (Finland time), let's see how it goes.
> 
> Related to this, Rafał are you still deleting the patches from 
> patchwork
> which should be dropped? I think you are as I can't see patches 4-9
> anymore.
> 
> Now that my patchwork setup is much better (compared to how it was over
> a year ago) I would actually prefer that you don't do that anymore. The
> problem is that when you delete the patch from patchwork it completely
> disappears from patchwork and I can't check the patch or discussion
> anymore. And I'm so accustomed to use patchwork that only seldom I use
> email to find the patch.
> 
> So it would be better to leave the patches as is and let me drop them
> (=change the state Changes Requested, Rejected or similar), which is
> trivial with my script. Otherwise I get this unsure feeling of what
> happened to the patch :)

Yeah, that was me (marked 4-9 as Changes Requested), sorry ;) I won't be 
messing with patches in the future.
