Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38171 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAXLWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 06:22:12 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so1807643wid.5
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 03:22:11 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87twzgmo2o.fsf@home.hong.me>
References: <1422094745-12718-1-git-send-email-hong@topbug.net>
	<87k30ciiir.fsf@kamboji.qca.qualcomm.com>
	<CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com>
	<87twzgmo2o.fsf@home.hong.me>
Date: Sat, 24 Jan 2015 12:22:11 +0100
Message-ID: <CA+icZUUrgMGDEEZd0H2f2qnsvr_bzSbo2oL16V1rCDhOU5-98g@mail.gmail.com> (sfid-20150124_122215_961542_09CCEC0C)
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Hong Xu <hong@topbug.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2015 at 12:10 PM, Hong Xu <hong@topbug.net> wrote:
>
> Sedat Dilek <sedat.dilek@gmail.com> writes:
>
>> On Sat, Jan 24, 2015 at 11:23 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Hong Xu <hong@topbug.net> writes:
>>>
>>>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>>>> whether the module parameter "blink" is on. This name is easy to
>>>> conflict with other variables, thus they are renamed.
>>>
>>> Please state clearly that this fixes a compiler error found by kbuild.
>>> Also it's very much recommended to add the actual compiler error to the
>>> commit log:
>>>
>>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>>> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>>
>>
>> Some more things...
>>
>> If you post a vN (referring to your v3) of a patch, please add a
>> history of changes.
>>
>> 2nd, use the Fixes tag [2] in this case with a reference to the
>> culprit commit [1].
>>
>> Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")
>>
>> Last but not least, honour credits like Reported-by/Tested-by (plus
>> some infos like broken in Linux-next $VERSION).
>>
> Thanks for your comments, I should have been more careful with the
> guideline. I guess we shouldn't credit kbuild for reporting in this case?
>

Learning by doing :-).

Yesterday, I looked trough some Git trees offline and I saw a commit
with kbuild-test-bot as "author", so... :-).
Not sure, if this is good, but I would prefer to put a note in the
commit-body (some call it changelog, I refer to terms in email
context)... "...found by kbuild test bot" with appropriate lines of
warning.
( See example in [1]. )

- Sedat -

[1] http://www.spinics.net/lists/linux-usb/msg110760.html
