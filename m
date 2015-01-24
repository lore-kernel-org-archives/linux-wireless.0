Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:63036 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbbAXKdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:33:49 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so1597725wes.7
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 02:33:48 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87k30ciiir.fsf@kamboji.qca.qualcomm.com>
References: <1422094745-12718-1-git-send-email-hong@topbug.net>
	<87k30ciiir.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 24 Jan 2015 11:33:48 +0100
Message-ID: <CA+icZUVq-bhryv=Aj7JuCzFU6kTQEh+jiwBR_bnJzNnjJ2Kg-A@mail.gmail.com> (sfid-20150124_113353_075771_E25DCF81)
Subject: Re: [PATCH] ath9k and ath9k_htc: rename variable "led_blink"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hong Xu <hong@topbug.net>,
	wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2015 at 11:23 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hong Xu <hong@topbug.net> writes:
>
>> ath9k and ath9k_htc use the variable name "led_blink" to indicate
>> whether the module parameter "blink" is on. This name is easy to
>> conflict with other variables, thus they are renamed.
>
> Please state clearly that this fixes a compiler error found by kbuild.
> Also it's very much recommended to add the actual compiler error to the
> commit log:
>
> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>

Some more things...

If you post a vN (referring to your v3) of a patch, please add a
history of changes.

2nd, use the Fixes tag [2] in this case with a reference to the
culprit commit [1].

Fixes: 3a939a671225 ("ath9k_htc: Add a module parameter to disable blink")

Last but not least, honour credits like Reported-by/Tested-by (plus
some infos like broken in Linux-next $VERSION).

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=3a939a671225909c19b09bfcb6e4761109e913d9
[2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches#n159
