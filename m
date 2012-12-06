Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [206.117.179.246] ([206.117.179.246]:48730 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932245Ab2LFGdT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 01:33:19 -0500
Message-ID: <1354775578.8320.26.camel@joe-AO722> (sfid-20121206_073323_422348_A9761D32)
Subject: Re: [PATCH V2 05/11] brcmfmac: error messages should not be
 suppressed
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 22:32:58 -0800
In-Reply-To: <1354742910-8822-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-6-git-send-email-arend@broadcom.com>
	 <1354742910-8822-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 22:28 +0100, Arend van Spriel wrote:
> The call to brcmf_dbg(ERROR, ...) only resulted in a log message
> when compiled with -DDEBUG. Error messages are valuable for resolving
> issues so this patch replaces it with brcmf_err(...) so they always
> end up in the log.
[]
> Reviewed-by: Joe Perches <joe@perches.com>

Don't add signatures unless the person actually gives one.
I didn't.

[]

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
[]
> @@ -35,20 +34,11 @@
>  
>  #if defined(DEBUG)
>  
> -#define brcmf_dbg(level, fmt, ...)					\
> -do {									\
> -	if (BRCMF_ERROR_VAL == BRCMF_##level##_VAL) {			\
> -		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
> -			if (net_ratelimit())				\
> -				pr_debug("%s: " fmt,			\
> -					 __func__, ##__VA_ARGS__);	\
> -		}							\
> -	} else {							\
> -		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
> -			pr_debug("%s: " fmt,				\
> -				 __func__, ##__VA_ARGS__);		\
> -		}							\
> -	}								\
> +#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)

You still lost the net_ratelimit() for the DEBUG case.

This brcmf_err macro should probably be in dhd.h,
not in a debug header and not guarded by DEBUG at all.


