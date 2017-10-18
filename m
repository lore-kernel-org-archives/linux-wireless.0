Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:45743 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdJRTpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 15:45:10 -0400
Received: by mail-it0-f65.google.com with SMTP id n195so7688709itg.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Oct 2017 12:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87h8ux2ena.fsf@codeaurora.org>
References: <1508200182-104605-1-git-send-email-keescook@chromium.org>
 <87mv4pvowa.fsf@purkki.adurom.net> <CAGXu5j+fcARk=yWh9Bbkn0C-4PHd+pKSPGV+5qPx88H6prvUoA@mail.gmail.com>
 <87h8ux2ena.fsf@codeaurora.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Oct 2017 12:45:08 -0700
Message-ID: <CAGXu5jLFJt5m5j59fA81F6HPHYyy31BJFzsSvN9hoHc6CbmrCg@mail.gmail.com> (sfid-20171018_214524_351838_9D6C3009)
Subject: Re: [PATCH 00/58] networking: Convert timers to use timer_setup()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 17, 2017 at 10:44 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Kees Cook <keescook@chromium.org> writes:
>> Which split is preferred? I had been trying to separate wireless from
>> the rest of net (but missed some cases).
>
> So what we try to follow is that I apply all patches for
> drivers/net/wireless to my wireless-drivers trees, with exception of
> Johannes taking mac80211_hwsim.c patches to his mac80211 trees. And
> Johannes of course takes all patches for net/wireless and net/mac80211.
>
> So in general I prefer that I take all drivers/net/wireless patches and
> make it obvious for Dave that he can ignore those patches (not mix
> wireless-drivers and net patches into same set etc). But like I said,
> it's ok to push API changes like these via Dave's net trees as well if
> you want (and if Dave is ok with that). The chances of conflicts is low,
> and if there are be any those would be easy to fix either by me or Dave.

Okay, great. That'll help. I'll wait for the dust to settle and rebase
against -next, and then I'll see what's outstanding and double-check
where they need to be sent (and I'll queue new conversions up
accordingly too).

>>> For now I'll just drop all your timer_setup() related patches from my
>>> queue and I'll assume Dave will take those. Ok?
>>>
>>> [1] https://patchwork.kernel.org/project/linux-wireless/list/
>>
>> I guess I'll wait to see what Dave says.
>
> Ok, I don't drop the patches from my queue quite yet then.

Alright, thanks very much!

-Kees

-- 
Kees Cook
Pixel Security
