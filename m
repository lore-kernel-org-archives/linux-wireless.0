Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55965 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1KVFfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 00:35:02 -0500
Received: by wwe5 with SMTP id 5so11826276wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 21:35:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111121213322.GA2209@slate>
References: <20111121213322.GA2209@slate>
Date: Tue, 22 Nov 2011 11:05:00 +0530
Message-ID: <CAD2nsn1pLNvHi20nnm_SFVpHLgKymxPh93V20qjQ2y1t3=K2Xw@mail.gmail.com> (sfid-20111122_063507_519352_1C3AB946)
Subject: Re: Panic/likely regression ath9k, frequent
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Cedric Sodhi <manday@gmx.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2011 at 3:03 AM, Cedric Sodhi <manday@gmx.net> wrote:
> 03:00.0 0280: 168c:002b (rev 01)
>
> AR9285
>
> 3.2.something from a not-network-related repo. Everything network
> related should be equivalent to mainline.
>
> So far I could not obtain any details, because I've no idea how to make
> ramoops succeed requesting memory and unfortunally my last attempt at
> using vmcore failed because somehow I lost dbg symbols. The backtrace
> that I get from the vmcore looks little promising though, even without
> symbols:
>
> (gdb) bt
> #0  0xffffffff8119ff42 in ?? ()
> #1  0x0000000000000000 in ?? ()
>
> Even less promising looks the size of the vmcore, which I assume to be
> the size of the actual RAM in use at the point of the panic:
>
> -r--------  1 root   root   4014652552 Nov 21 20:19 vmcore
>
> Compared to the output in normal operation, which is when the panics
> occur. At the asbolute most, 2 Gigabytes including caches.
>
> I'm afraid, that if my interpretion of the size of vmcore is correct,
> ath eats up all RAM and thereby cause the panic, milliseconds before the
> crash.
>
> Why I think it's ath9k? This panic occurs, though not clearly
> reproducibly, with moderate load on the wifi, that is listening to
> online radio. And a few times I could witness a panic log on the console
> (mostly everything freezes right in X) and ath was clearly involved.

i am going to try this in my wireless-testing tree/ latest compat
wireless. please let me know if i had to do something specific(running
traffic in noisy environment, put the device in monitor mode) to
trigger the panic. any info to recreate will be helpful. i will also
try that online radio(i am not aware if it). i will be trying it in my
x86 platform.

>
> As I said, I'm trying to obtain anything more definite, but it could be
> hard, unless I get ramoops to work, which currently refuses to accept
> any memory address to write the dump to.
>
> Of course, I readily provide any info I can from the vmcore and will try
> to get a bt with proper symbols asap.
>
> Until then, this appears to be a regression somewhere since 3.1.1 (or
> possibly 3.1.0). It's hard to tell though, since it's not readily
> reproducible but I have never had the panic in neither of those
> versions.
>
> Cedric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
