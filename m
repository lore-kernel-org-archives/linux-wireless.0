Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18602 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbYGaBQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 21:16:51 -0400
Subject: Re: [PATCH 11/16] ath9k: Remove "OS_" prefixes in macros.
From: Pavel Roskin <proski@gnu.org>
To: lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Jouni.Malinen@Atheros.com,
	Sujith Manoharan <smanoharan@atheros.com>
In-Reply-To: <f716bd4495bedc5987c6fd1283a09843e3c9331e.1217309552.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
	 <f716bd4495bedc5987c6fd1283a09843e3c9331e.1217309552.git.lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 21:16:49 -0400
Message-Id: <1217467009.3616.9.camel@dv> (sfid-20080731_031654_189935_3FE5944A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 22:47 -0700, lrodriguez@atheros.com wrote:
> From: Sujith Manoharan <smanoharan@atheros.com>
> 
> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
> index 6fa1eb6..c3294c0 100644
> --- a/drivers/net/wireless/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath9k/ath9k.h
> @@ -622,17 +622,15 @@ struct hal_country_entry {
>  
>  #define SM(_v, _f)  (((_v) << _f##_S) & _f)
>  #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
> -#define OS_REG_RMW(_a, _r, _set, _clr)    \
> +#define REG_RMW(_a, _r, _set, _clr)    \
>  	REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))

I think these are pretty good candidates for inline functions.  I'm not
sure removing "OS_" is a useful intermediate step.  It's better to keep
such massive changes to the minimum to avoid potential conflicts with
other patches.

-- 
Regards,
Pavel Roskin
