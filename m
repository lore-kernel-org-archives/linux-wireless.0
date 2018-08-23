Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48367 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeHWFBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 01:01:17 -0400
Received: from mail-pf1-f199.google.com ([209.85.210.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1fseVe-0001mu-Do
        for linux-wireless@vger.kernel.org; Thu, 23 Aug 2018 01:34:02 +0000
Received: by mail-pf1-f199.google.com with SMTP id p5-v6so2229265pfh.11
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2018 18:34:02 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH] ath9k: turn on btcoex_enable as default
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <6A0F65EF-A7C4-469F-8FAF-CBE314676237@canonical.com>
Date: Thu, 23 Aug 2018 09:33:56 +0800
Cc: Kalle Valo <kvalo@codeaurora.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <9AF82E83-2EBE-4076-BAFA-EEA44B1DB423@canonical.com> (sfid-20180823_033422_069373_1FB316E2)
References: <20180208052801.15670-1-kai.heng.feng@canonical.com>
 <56d650e6-d26f-087c-4e86-2e5d4e859414@nbd.name>
 <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com>
 <87k1vmeip8.fsf@kamboji.qca.qualcomm.com>
 <E500FA42-23F1-433F-9BFB-78A2FD1946AF@canonical.com>
 <7170e2d5-a59d-8260-fa8e-f02f583b773f@nbd.name>
 <6A0F65EF-A7C4-469F-8FAF-CBE314676237@canonical.com>
To: Felix Fietkau <nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at 12:15, Kai Heng Feng <kai.heng.feng@canonical.com> wrote:

>
>
>> On 10 Feb 2018, at 10:05 PM, Felix Fietkau <nbd@nbd.name> wrote:
>>
>> On 2018-02-10 14:56, Kai Heng Feng wrote:
>>>> On 9 Feb 2018, at 3:16 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> Sure, but we have to make sure that we don't create regressions on
>>>> existing systems. For example, did you test this with any system which
>>>> don't support btcoex? (just asking, haven't tested this myself)
>>>
>>> No not really, but I will definitely test it.
>>> The only module I have that uses ath9k is Dell’s DW1707.
>>> How do I check if it support btcoex or not?
>> I just reviewed the code again, and I am sure that we cannot merge this
>> patch. Enabling the btcoex parameter makes the driver enable a whole
>> bunch of code starting timers, listening to some GPIOs, etc.
>>
>> On non-btcoex systems, some of those GPIOs might be floating or even
>> connected to different things, which could cause a lot of undefined
>> behavior.
>>
>> This is simply too big a risk, so there absolutely needs to be a
>> whitelist for systems that need this, otherwise it has to remain
>> disabled by default.
>
> So what information can we use to whitelist btcoex chips?
> Can we get btcoex support status at ath9k probing?

Sorry for bringing this up again.

Is DMI based match an acceptable approach for ath9k?

Kai-Heng

>
> Kai-Heng
>
>> - Felix
