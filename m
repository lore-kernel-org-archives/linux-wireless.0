Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37184 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbeHWUgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 16:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <87in41nxfx.fsf@kamboji.qca.qualcomm.com>
References: <20180208052801.15670-1-kai.heng.feng@canonical.com>
 <56d650e6-d26f-087c-4e86-2e5d4e859414@nbd.name> <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com>
 <87k1vmeip8.fsf@kamboji.qca.qualcomm.com> <E500FA42-23F1-433F-9BFB-78A2FD1946AF@canonical.com>
 <7170e2d5-a59d-8260-fa8e-f02f583b773f@nbd.name> <6A0F65EF-A7C4-469F-8FAF-CBE314676237@canonical.com>
 <9AF82E83-2EBE-4076-BAFA-EEA44B1DB423@canonical.com> <87in41nxfx.fsf@kamboji.qca.qualcomm.com>
From: Tom Psyborg <pozega.tomislav@gmail.com>
Date: Thu, 23 Aug 2018 19:06:04 +0200
Message-ID: <CAKR_QV+6yW6c51ve3sV=yadhL5fgPDTKQOfahnjNhtE1RHDzUw@mail.gmail.com> (sfid-20180823_190615_315944_226A37F9)
Subject: Re: [PATCH] ath9k: turn on btcoex_enable as default
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Felix Fietkau <nbd@nbd.name>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I keep this setting on all the time and just when i read this mail
again i'm suspicious if the bluetooth could actually have an impact on
wifi reception? I am using AR9462 card and it can transmit at 215Mbps
average, but receives only about 125Mbps (2spatial streams AP, 2.4GHz,
AR9531)

On 23/08/2018, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>
>> at 12:15, Kai Heng Feng <kai.heng.feng@canonical.com> wrote:
>>
>>>
>>>
>>>> On 10 Feb 2018, at 10:05 PM, Felix Fietkau <nbd@nbd.name> wrote:
>>>>
>>>> On 2018-02-10 14:56, Kai Heng Feng wrote:
>>>>>> On 9 Feb 2018, at 3:16 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>>>> Sure, but we have to make sure that we don't create regressions on
>>>>>> existing systems. For example, did you test this with any system
>>>>>> which
>>>>>> don't support btcoex? (just asking, haven't tested this myself)
>>>>>
>>>>> No not really, but I will definitely test it.
>>>>> The only module I have that uses ath9k is Dell=E2=80=99s DW1707.
>>>>> How do I check if it support btcoex or not?
>>>> I just reviewed the code again, and I am sure that we cannot merge thi=
s
>>>> patch. Enabling the btcoex parameter makes the driver enable a whole
>>>> bunch of code starting timers, listening to some GPIOs, etc.
>>>>
>>>> On non-btcoex systems, some of those GPIOs might be floating or even
>>>> connected to different things, which could cause a lot of undefined
>>>> behavior.
>>>>
>>>> This is simply too big a risk, so there absolutely needs to be a
>>>> whitelist for systems that need this, otherwise it has to remain
>>>> disabled by default.
>>>
>>> So what information can we use to whitelist btcoex chips?
>>> Can we get btcoex support status at ath9k probing?
>>
>> Sorry for bringing this up again.
>>
>> Is DMI based match an acceptable approach for ath9k?
>
> I don't know what Felix thinkgs, but to me using DMI sounds like a good
> idea to try, assuming the matches are unique enough and there's no risk
> of enabling bt coex on wrong platforms. Should the PCI bus number etc
> checked as well in case the user adds more ath9k devices to the
> platform?
>
> But of course I need to see the patch to comment more.
>
> --
> Kalle Valo
>
