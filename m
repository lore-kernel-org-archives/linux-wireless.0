Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:58391 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbAXNQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 08:16:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: sedat.dilek@gmail.com
Cc: Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4] ath9k and ath9k_htc: rename variable "led_blink"
References: <1422099243-20321-1-git-send-email-hong@topbug.net>
	<CA+icZUWtwQoBxWu+LSgva4sKgx1dLgAvxNXWxu2QN0s1zm-tWQ@mail.gmail.com>
Date: Sat, 24 Jan 2015 15:16:28 +0200
In-Reply-To: <CA+icZUWtwQoBxWu+LSgva4sKgx1dLgAvxNXWxu2QN0s1zm-tWQ@mail.gmail.com>
	(Sedat Dilek's message of "Sat, 24 Jan 2015 12:51:19 +0100")
Message-ID: <873870iaj7.fsf@kamboji.qca.qualcomm.com> (sfid-20150124_141640_561718_373DCA24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Sat, Jan 24, 2015 at 12:34 PM, Hong Xu <hong@topbug.net> wrote:
>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>> whether the module parameter "blink" is on. This name is easy to
>> conflict with other variables, and has caused a compiler error found
>> by kbuild test bot. The compiler error is as following:
>>
>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>
>> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Signed-off-by: Hong Xu <hong@topbug.net>
>> ---
>> Compared to previous versions, the commit message is improved to fit
>> the contribution guideline (again).
>> ---
>
> This looks good.

Indeed.

> I have one thing for followers of (linux-wireless) mailing-lists in
> general. If your patch is against a special Git tree, please add a
> "subject-prefix" and/or put a note in the commit-body. For example:
> "This patch is against wireless-drivers-next or linux-next
> (next-2015-01-23)." This is very helpful.

I don't think that's necessary as by default driver patches go to
wireless-drivers-next. But if the patch should go to an -rc release for
whatever (good) reasons it's best to mark the patch like "[PATCH 3.19]"
or similar, that way I can easily see that it should go to 3.19. Larry
does that and it's really helpful.

-- 
Kalle Valo
