Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [206.117.179.246] ([206.117.179.246]:43373 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753858Ab2LEOlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:41:50 -0500
Message-ID: <1354718489.8320.1.camel@joe-AO722> (sfid-20121205_154154_044078_6DF91DBC)
Subject: Re: [PATCH 05/11] brcmfmac: error messages should not be suppressed
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 06:41:29 -0800
In-Reply-To: <1354717564-7183-6-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
	 <1354717564-7183-6-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 15:25 +0100, Arend van Spriel wrote:
> The call to brcmf_dbg(ERROR, ...) only resulted in a log message
> when compiled with -DDEBUG. Error messages are valuable for resolving
> issues so this patch replaces it with brcmf_err(...) so they always
> end up in the log.

Seems like a good idea but you also
removed the net_ratelimit() which doesn't.

> @@ -33,22 +32,15 @@
>  #define BRCMF_FIL_VAL	0x1000
>  #define BRCMF_USB_VAL	0x2000
>  
> +/* error messages are always logged */
> +#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
> +
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
> +#define brcmf_dbg(level, fmt, ...)				\
> +do {								\
> +	if (brcmf_msg_level & BRCMF_##level##_VAL)		\
> +		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
>  } while (0)


