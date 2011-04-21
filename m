Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4865 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab1DUQem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 12:34:42 -0400
Subject: Re: [PATCH v3 1/3] staging: brcm80211: replaced WL_NONE with
 no_printk
From: Joe Perches <joe@perches.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1303383725-1440-2-git-send-email-rvossen@broadcom.com>
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
	 <1303383725-1440-2-git-send-email-rvossen@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 09:34:40 -0700
Message-ID: <1303403680.24766.55.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 13:02 +0200, Roland Vossen wrote:
[]
> diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
> index 54af257..8705b40 100644
> --- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
> +++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
> @@ -20,8 +20,6 @@
>  /* wl_msg_level is a bit vector with defs in wlioctl.h */
>  extern u32 wl_msg_level;
>  
> -#define WL_NONE(fmt, args...) no_printk(fmt, ##args)
> -

I think you misunderstand the purpose of no_printk.
no_printk is used simply to validate format arguments
and not emit anything.

It's typically used for debugging like

#ifndef DEBUG
#define FOO_DBG(fmt, ...)	printk(fmt, ##__VA_ARGS__)
#else
#define FOO_DBG(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
#endif

What you've got here is effectively a comment.

More likely there was a mistake in the initial
conversion to of WL_NONE to no_printk.


