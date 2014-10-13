Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36952 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaJMIZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 04:25:19 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so6734137wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 01:25:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fves9z5o.fsf@kamboji.qca.qualcomm.com>
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
	<1412842950-14098-6-git-send-email-michal.kazior@tieto.com>
	<87fves9z5o.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 13 Oct 2014 10:25:17 +0200
Message-ID: <CA+BoTQ=HF0wCfBbC9YWFgVh2QhGzYU6uNo0hyAW4+R97bxwdHw@mail.gmail.com> (sfid-20141013_102525_382506_EA750E00)
Subject: Re: [PATCH 5/5] ath10k: replace power up/down with reset callback
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 October 2014 10:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The power up/down didn't make much sense any more
>> since hif_stop already stops the device
>> compeletely. The target lifecycle was never symmetric
>> so don't bother trying to make it look like it is
>> and expose a reset hif callback instead of power
>> up/down callbacks.
>>
>> This removes redundant reset calls and thus makes
>> device boot/stop/recovery a bit faster.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> About this I'm not that sure. The reason why I wanted to have power_up()
> and power_down() is the case when we need to control the target power
> via a gpio line, which I anticipate we will need soon. If you remove
> these how could we control the gpio line?
>
> Wouldn't it be the same that you just make hif_power_up() do the same as
> hif_reset() and hif_power_down() doesn't do anything (for now)? Or am I
> missing something?

Hmm.. I guess that's fine as well. I'll rework it to keep power_up
(which will basically do reset) and power_down (nop for now).


Michał
