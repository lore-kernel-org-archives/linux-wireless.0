Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:49257 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750819AbaHTOqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 10:46:52 -0400
Message-ID: <1408546008.23250.23.camel@joe-AO725> (sfid-20140820_164716_806891_9F38CF99)
Subject: Re: [PATCH v3 04/11] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 20 Aug 2014 07:46:48 -0700
In-Reply-To: <1408527772-27224-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408527772-27224-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-20 at 12:42 +0300, Andy Shevchenko wrote:
> This allows user to print a given buffer as an escaped string. The rules are
> applied according to an optional mix of flags provided by additional format
> letters.

Thanks Andy.  Looks good to me.

Very trivial note:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1101,6 +1102,63 @@ char *ip4_addr_string_sa(char *buf, char *end, const struct sockaddr_in *sa,
>  }
>  
>  static noinline_for_stack
> +char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		     const char *fmt)
> +{
> +	bool found = true;
> +	int count = 1;
> +	unsigned int flags = 0;
> +	int len;
> +
> +	if (spec.field_width == 0)
> +		/* nothing to print */
> +		return buf;
> +
> +	if (ZERO_OR_NULL_PTR(addr))
> +		/* NULL pointer */
> +		return string(buf, end, NULL, spec);

As the code seems more readable than the comments,
it might be better to remove these comments or
maybe move the comment above the test.

	if (spec.field_width == 0)
		return buf;

	if (ZERO_OR_NULL_PTR(addr))
		return string(buf, end, NULL, spec);


