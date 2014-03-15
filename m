Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:58787 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756560AbaCOWXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 18:23:54 -0400
Message-ID: <1394922230.5689.2.camel@joe-AO722> (sfid-20140315_232357_564715_300EFA39)
Subject: Re: [PATCH v5 01/11] rsi: Adding RS9113 header files.
From: Joe Perches <joe@perches.com>
To: Fariya Fatima <fariyaf@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 15 Mar 2014 15:23:50 -0700
In-Reply-To: <1394921832-4056-2-git-send-email-fariyaf@gmail.com>
References: <1394921832-4056-1-git-send-email-fariyaf@gmail.com>
	 <1394921832-4056-2-git-send-email-fariyaf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
[]
> +static inline void rsi_dbg(u32 zone, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	if (zone & rsi_zone_enabled)
> +		pr_info("%pV", &vaf);
> +	va_end(args);
> +}

I believe debugging messages should be emitted at KERN_DEBUG.

Also, it seems that every use uses "%s: ", __func__.

I think it'd be better to remove all those uses from the
calling sites and use:

%pS:, __builtin_return_address(0)


