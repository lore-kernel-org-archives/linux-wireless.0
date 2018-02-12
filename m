Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41581 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932500AbeBLEQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Feb 2018 23:16:01 -0500
Received: from mail-pl0-f69.google.com ([209.85.160.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1el5X5-0006WF-Td
        for linux-wireless@vger.kernel.org; Mon, 12 Feb 2018 04:16:00 +0000
Received: by mail-pl0-f69.google.com with SMTP id z11so2204679plo.21
        for <linux-wireless@vger.kernel.org>; Sun, 11 Feb 2018 20:15:59 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] ath9k: turn on btcoex_enable as default
From: Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <7170e2d5-a59d-8260-fa8e-f02f583b773f@nbd.name>
Date: Mon, 12 Feb 2018 12:15:53 +0800
Cc: Kalle Valo <kvalo@codeaurora.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <6A0F65EF-A7C4-469F-8FAF-CBE314676237@canonical.com> (sfid-20180212_051625_216856_CA54C605)
References: <20180208052801.15670-1-kai.heng.feng@canonical.com>
 <56d650e6-d26f-087c-4e86-2e5d4e859414@nbd.name>
 <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com>
 <87k1vmeip8.fsf@kamboji.qca.qualcomm.com>
 <E500FA42-23F1-433F-9BFB-78A2FD1946AF@canonical.com>
 <7170e2d5-a59d-8260-fa8e-f02f583b773f@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On 10 Feb 2018, at 10:05 PM, Felix Fietkau <nbd@nbd.name> wrote:
> 
> On 2018-02-10 14:56, Kai Heng Feng wrote:
>> 
>>> On 9 Feb 2018, at 3:16 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Sure, but we have to make sure that we don't create regressions on
>>> existing systems. For example, did you test this with any system which
>>> don't support btcoex? (just asking, haven't tested this myself)
>> 
>> No not really, but I will definitely test it.
>> The only module I have that uses ath9k is Dell’s DW1707.
>> How do I check if it support btcoex or not?
> I just reviewed the code again, and I am sure that we cannot merge this
> patch. Enabling the btcoex parameter makes the driver enable a whole
> bunch of code starting timers, listening to some GPIOs, etc.
> 
> On non-btcoex systems, some of those GPIOs might be floating or even
> connected to different things, which could cause a lot of undefined
> behavior.
> 
> This is simply too big a risk, so there absolutely needs to be a
> whitelist for systems that need this, otherwise it has to remain
> disabled by default.

So what information can we use to whitelist btcoex chips?
Can we get btcoex support status at ath9k probing?

Kai-Heng

> 
> - Felix
