Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39004 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbeBJOFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 09:05:10 -0500
Subject: Re: [PATCH] ath9k: turn on btcoex_enable as default
To: Kai Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180208052801.15670-1-kai.heng.feng@canonical.com>
 <56d650e6-d26f-087c-4e86-2e5d4e859414@nbd.name>
 <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com>
 <87k1vmeip8.fsf@kamboji.qca.qualcomm.com>
 <E500FA42-23F1-433F-9BFB-78A2FD1946AF@canonical.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <7170e2d5-a59d-8260-fa8e-f02f583b773f@nbd.name> (sfid-20180210_150530_895024_EBB90921)
Date: Sat, 10 Feb 2018 15:05:05 +0100
MIME-Version: 1.0
In-Reply-To: <E500FA42-23F1-433F-9BFB-78A2FD1946AF@canonical.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-10 14:56, Kai Heng Feng wrote:
> 
>> On 9 Feb 2018, at 3:16 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Sure, but we have to make sure that we don't create regressions on
>> existing systems. For example, did you test this with any system which
>> don't support btcoex? (just asking, haven't tested this myself)
> 
> No not really, but I will definitely test it.
> The only module I have that uses ath9k is Dell’s DW1707.
> How do I check if it support btcoex or not?
I just reviewed the code again, and I am sure that we cannot merge this
patch. Enabling the btcoex parameter makes the driver enable a whole
bunch of code starting timers, listening to some GPIOs, etc.

On non-btcoex systems, some of those GPIOs might be floating or even
connected to different things, which could cause a lot of undefined
behavior.

This is simply too big a risk, so there absolutely needs to be a
whitelist for systems that need this, otherwise it has to remain
disabled by default.

- Felix
