Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55294 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZESAeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 20:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com>
Date: Tue, 19 May 2009 03:34:37 +0300
Message-ID: <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com>
Subject: Re: [PATCH] ath5k: prevent infinite loop
From: Nick Kossifidis <mickflemm@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com, me@bobcopeland.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/19 Steven Rostedt <rostedt@goodmis.org>:
>
> After updating my laptop with the latest kernel (had 2.6.26 before that),
> my laptop load went to 100%. The daemon phy0 was at 99.9% of the CPU.
> Luckily I compiled with a preempt kernel otherwise this would have
> been a lock up.
>
> Using ftrace to dig into the problem I found that that the ath5k driver
> was in an infinite loop. The code in ath5k_get_linear_pcdac_min has:
>
>        pwr_i = pwrR[0];
>        do {
>                pwr_i--;
>                tmp = (s8) ath5k_get_interpolated_value(pwr_i,
>                                                pwrR[0], pwrR[1],
>                                                stepR[0], stepR[1]);
>        } while (tmp > 1);
>
>
> But ath5k_get_interpolated returns stepR[0] if pwrR[0] == pwrR[1] or
> stepR[0] == stepR[1]. The pwr_i is ignored and we enter an infinite loop
> because tmp never changes between iterations. Using ftrace, I was able to
> determine that is exactly what happened in the case of my laptop.
>
> This patch tries to keep the same result that would happen when this case
> occurs. That is, the pwr_i becomes a minimal number. I used the minimum
> number that a signed short may be to initialize the min pwrL and pwrR.
> Then if the case that the code would cause an infinite loop, we bypass it.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>

This is already fixed on wireless-testing ;-)
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
