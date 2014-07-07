Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:51212 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112AbaGGQuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 12:50:16 -0400
Message-ID: <1404751810.27043.90.camel@joe-AO725> (sfid-20140707_185021_444283_D8896959)
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 07 Jul 2014 09:50:10 -0700
In-Reply-To: <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-07 at 18:21 +0300, Andy Shevchenko wrote:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
>  static noinline_for_stack
> +char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		     const char *fmt)
[]
> +	if (spec.field_width == 0)
> +		/* nothing to print */
> +		return buf;
[]
> +	len = spec.field_width < 0 ? 1 : spec.field_width;

If field_width is not specified, emit a single byte?

Perhaps better if -1 was accepted by string_escape_mem
as a strlen request or just ignored as a 0 length is
above.

fyi: hex_string emits nothing on printk("%ph", buf);


