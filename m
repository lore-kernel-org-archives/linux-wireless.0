Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaGBVyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 17:54:12 -0400
Date: Wed, 2 Jul 2014 14:54:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/6] lib / string_helpers: clean up test suite
Message-Id: <20140702145410.e1885ad85c25a6f4b6cef2c4@linux-foundation.org> (sfid-20140702_235439_654540_F757DBE6)
In-Reply-To: <1404307229-19186-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1404307229-19186-2-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed,  2 Jul 2014 16:20:24 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> This patch prepares test suite for a following update. It introduces
> test_string_check_buf() helper which checks the result and dumps an error.
> 
> ...
>
> --- a/lib/test-string_helpers.c
> +++ b/lib/test-string_helpers.c
> @@ -10,6 +10,26 @@
>  #include <linux/string.h>
>  #include <linux/string_helpers.h>
>  
> +static __init bool test_string_check_buf(const char *name, unsigned int flags,
> +					 char *in, size_t p,
> +					 char *out_real, size_t q_real,
> +					 char *out_test, size_t q_test)
> +{
> +	if (q_real == q_test && !memcmp(out_test, out_real, q_test))
> +		return true;
> +
> +	pr_err("Test '%s' failed: flags = %u\n", name, flags);
> +
> +	print_hex_dump(KERN_WARNING, "Input: ", DUMP_PREFIX_NONE, 16, 1,
> +		       in, p, true);
> +	print_hex_dump(KERN_WARNING, "Expected: ", DUMP_PREFIX_NONE, 16, 1,
> +		       out_test, q_test, true);
> +	print_hex_dump(KERN_WARNING, "Got: ", DUMP_PREFIX_NONE, 16, 1,
> +		       out_real, q_real, true);

Seems strange to mix KERN_ERR and KERN_WARNING.  The code's always been
that way, but maybe it can be improved.


