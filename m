Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout3.wanadoo.co.uk ([80.12.242.59]:42126 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab3CHPMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 10:12:44 -0500
Date: Fri, 8 Mar 2013 16:12:42 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Message-ID: <8215941.3511362755562919.JavaMail.www@wwinf3723> (sfid-20130308_161248_252772_91EF008B)
In-Reply-To: <7009019.981362755325047.JavaMail.www@wwinf3702>
Subject: RE: ath6kl build error.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fact, it is !
In drivers/include_local/linux/compat-2.6.34.h .

I see this:

#define sdio_set_host_pm_flags(a, b) 0

That's causing my compiler problem.


Regards

Nick




> Message Received: Mar 08 2013, 03:08 PM
> From: nick@nhthomas.freeserve.co.uk
> To: nick@nhthomas.freeserve.co.uk
> Cc:
> Subject: RE: ath6kl build error.
>
> The problem appears to be that sdio_set_host_pm_flags is already defined somewhere else.

Regards

Nick
> Message Received: Mar 08 2013, 11:25 AM
> From: nick@nhthomas.freeserve.co.uk
> To: linux-wireless@vger.kernel.org
> Cc:
> Subject: ath6kl build error.
>
>
> Hi,
>
> I'm getting a build error when building ath6kl modules.
>
> include/linux/mmc/sdio_func.h:162:12: error: expected identifier or '(' before numeric constant
>
> the line it's complaining about is like this:
>
> extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
>
>
> A bit of googling has shown that others have seen the same problem too.
> But, I've not seen a fix for it.
>
> Any ideas appreciated.
>
>
> Regards
>
> Nick Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>


