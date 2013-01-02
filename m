Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43903 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752624Ab3ABRwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 12:52:38 -0500
Message-ID: <1357149158.17061.45.camel@joe-AO722> (sfid-20130102_185246_736121_7787F076)
Subject: Re: [PATCH 08/18] brcmfmac: define pr_fmt in one place
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Wed, 02 Jan 2013 09:52:38 -0800
In-Reply-To: <1357136572-18273-9-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
	 <1357136572-18273-9-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 15:22 +0100, Arend van Spriel wrote:
> Several source files (but not all) define the pr_fmt() macro in exactly
> the same way. Instead this commit defines it in a header file so driver
> logging is consistent.

The commit message doesn't describe the change to brcm_err

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
[]
> @@ -34,19 +34,12 @@
>  #define BRCMF_SCAN_VAL	0x4000
>  #define BRCMF_CONN_VAL	0x8000
>  
> -/* Macro for error messages. net_ratelimit() is used when driver
> - * debugging is not selected. When debugging the driver error
> - * messages are as important as other tracing or even more so.
> - */
> -#ifdef CONFIG_BRCMDBG
> +/* set default print format */
> +#undef pr_fmt
> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> +
> +/* error messages are always logged */
>  #define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
> -#else
> -#define brcmf_err(fmt, ...)						\
> -	do {								\
> -		if (net_ratelimit())					\
> -			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
> -	} while (0)
> -#endif


