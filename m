Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51686 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbAXNYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 08:24:24 -0500
Received: by mail-we0-f170.google.com with SMTP id x3so2045353wes.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 05:24:22 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <873870iaj7.fsf@kamboji.qca.qualcomm.com>
References: <1422099243-20321-1-git-send-email-hong@topbug.net>
	<CA+icZUWtwQoBxWu+LSgva4sKgx1dLgAvxNXWxu2QN0s1zm-tWQ@mail.gmail.com>
	<873870iaj7.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 24 Jan 2015 14:24:22 +0100
Message-ID: <CA+icZUXJfWY-seK9Hpown_bQW9-ngX7PBPnU-f2B16+qarJ=tg@mail.gmail.com> (sfid-20150124_142427_103594_F926F43B)
Subject: Re: [PATCH v4] ath9k and ath9k_htc: rename variable "led_blink"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2015 at 2:16 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> writes:
>
>> On Sat, Jan 24, 2015 at 12:34 PM, Hong Xu <hong@topbug.net> wrote:
>>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>>> whether the module parameter "blink" is on. This name is easy to
>>> conflict with other variables, and has caused a compiler error found
>>> by kbuild test bot. The compiler error is as following:
>>>
>>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>>
>>> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
>>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>>> Signed-off-by: Hong Xu <hong@topbug.net>
>>> ---
>>> Compared to previous versions, the commit message is improved to fit
>>> the contribution guideline (again).
>>> ---
>>
>> This looks good.
>
> Indeed.
>
>> I have one thing for followers of (linux-wireless) mailing-lists in
>> general. If your patch is against a special Git tree, please add a
>> "subject-prefix" and/or put a note in the commit-body. For example:
>> "This patch is against wireless-drivers-next or linux-next
>> (next-2015-01-23)." This is very helpful.
>
> I don't think that's necessary as by default driver patches go to
> wireless-drivers-next. But if the patch should go to an -rc release for
> whatever (good) reasons it's best to mark the patch like "[PATCH 3.19]"
> or similar, that way I can easily see that it should go to 3.19. Larry
> does that and it's really helpful.
>

OK, that is helpful for rc-fixes (and I used that).

But how to distinguish when this is not a rc-fix but for
wireless-drivers-next (to fix a breakage like here)... Label with
"[PATCH 3.20]"?

For you as a daily reader/follower this might be clear, but not for me
and maybe others.

Please, also look at netdev ML (patches for net.git/net-next.git).

- Sedat -
