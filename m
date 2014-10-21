Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63824 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaJUIXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:23:32 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so9270382wiv.14
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 01:23:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lho9ygy1.fsf@kamboji.qca.qualcomm.com>
References: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
	<1413807758-30249-4-git-send-email-michal.kazior@tieto.com>
	<87lho9ygy1.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 21 Oct 2014 10:23:31 +0200
Message-ID: <CA+BoTQn9Rc4fLUV8JS5_ZrrckyNz8YPevgmc+FpxtGJ1xhtX2w@mail.gmail.com> (sfid-20141021_102337_168229_D584CEEC)
Subject: Re: [PATCH v2 3/3] ath10k: speed up hw recovery
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2014 10:17, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> In some cases hw recovery was taking an absurdly
>> long time due to ath10k waiting for things that
>> would never really complete.
>>
>> Instead of waiting for inevitable timeouts poke
>> all completions and wakequeues and check if it's
>> still worth waiting.
>>
>> Reading/writing ar->state requires conf_mutex.
>> Since waiters might be holding it introduce a new
>> flag CRASH_FLUSH so it's possible to tell waiters
>> to abort whatever they were waiting for.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> While applying to ath-next-test there was a conflict in core.h. Please
> check my resolution:
>
> https://github.com/kvalo/ath/commit/6cccda0185c7df96f439dc3f87961e81843de3ee

I think it was `enum ath10k_cal_mode {` vs `enum ath10k_scan_state {`
because my patch was based without your cal patches.

Anyway - looks good, thanks!


Michał
