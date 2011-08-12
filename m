Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1HLM2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 08:28:24 -0400
Subject: Re: [PATCH v2 1/8] mac80211: improve mpath debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1313117641-27351-1-git-send-email-thomas@cozybit.com> (sfid-20110812_045445_878175_972148C7)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1313117641-27351-1-git-send-email-thomas@cozybit.com>
	 (sfid-20110812_045445_878175_972148C7)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 14:28:21 +0200
Message-ID: <1313152101.4022.3.camel@jlt3.sipsolutions.net> (sfid-20110812_142827_987995_3A019B3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-11 at 19:53 -0700, Thomas Pedersen wrote:

> +#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
> +static inline void mpath_dbg(const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk(KERN_DEBUG "%pV", &vaf);
> +	va_end(args);
> +	return;
> +}
> +#else
> +static inline void mpath_dbg(const char *fmt, ...)
> +{
> +	return;
> +}
> +#endif

Oh, maybe that's too complicated after all... How about

#ifdef ...
#define ...
#else
static inline void mpath_dbg(const char *fmt, ...)
	__attribute__ ((format (printf, 1, 2)))
{
}
#endif

Definitely want the format attribute, that was my whole point :)

Bah, maybe it all doesn't matter, in which case maybe the first version
is better.

johannes

