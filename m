Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55710 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759879Ab3CHSjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 13:39:51 -0500
Received: by mail-ob0-f182.google.com with SMTP id va7so1544435obc.27
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 10:39:51 -0800 (PST)
Message-ID: <513A3075.5040100@lwfinger.net> (sfid-20130308_193956_137352_2E4F11D8)
Date: Fri, 08 Mar 2013 12:39:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: nick@nhthomas.freeserve.co.uk
CC: linux-wireless@vger.kernel.org
Subject: Re: ath6kl build error.
References: <19954030.22961362741929700.JavaMail.www@wwinf3707>
In-Reply-To: <19954030.22961362741929700.JavaMail.www@wwinf3707>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2013 05:25 AM, nick@nhthomas.freeserve.co.uk wrote:
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

The complete gcc error output would be helpful.

What kernel are you using? A quick check of 3.9-rc1 shows that "struct 
sdio_func" is defined in include/linux/mmc/sdio_func.h, which is included from 
both drivers/net/wireless/ath/ath6kl/init.c and 
drivers/net/wireless/ath/ath6kl/sdio.c. The symbol "mmc_pm_flag_t" is defined in 
include/linux/mmc/pm.h, which is included in include/linux/mmc/sdio_func.h. It 
seems unlikely that either "extern" or "int" is undefined, thus the error is 
hard to understand.

Larry


