Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout4.wanadoo.co.uk ([80.12.242.68]:38861 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3CJONu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 10:13:50 -0400
Date: Sun, 10 Mar 2013 15:13:49 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Message-ID: <32193647.103921362924829149.JavaMail.www@wwinf3714> (sfid-20130310_151354_899141_042A5249)
In-Reply-To: <87a9qdm6ti.fsf@kamboji.qca.qualcomm.com>
Subject: Re: ath6kl build error.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My compilation problem comes down to this:

In drivers/include_local/linux/compat-2.6.34.h .

I see this:

#define sdio_set_host_pm_flags(a, b) 0

That's causing my compiler problem.

I'm going to have to locally patch the tree to fix this.



Regards

Nick




> Message Received: Mar 09 2013, 06:22 AM
> From: "Kalle Valo"
> To: "Larry Finger"
> Cc: nick@nhthomas.freeserve.co.uk, linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
> Subject: Re: ath6kl build error.
>
> Larry Finger writes:
>
> > On 03/08/2013 05:25 AM, nick@nhthomas.freeserve.co.uk wrote:
> >>
> >> I'm getting a build error when building ath6kl modules.
> >>
> >> include/linux/mmc/sdio_func.h:162:12: error: expected identifier or '(' before numeric constant
> >>
> >> the line it's complaining about is like this:
> >>
> >> extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
> >>
> >>
> >> A bit of googling has shown that others have seen the same problem too.
> >> But, I've not seen a fix for it.
> >>
> >> Any ideas appreciated.
> >
> > The complete gcc error output would be helpful.
> >
> > What kernel are you using?
>
> I think he's using compat-driver and compiling against some old vendor
> kernel.
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

