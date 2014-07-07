Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:50140 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750917AbaGGQ0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 12:26:09 -0400
Message-ID: <1404750357.27043.78.camel@joe-AO725> (sfid-20140707_182628_749417_C858245C)
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
Date: Mon, 07 Jul 2014 09:25:57 -0700
In-Reply-To: <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[trivial notes]

On Mon, 2014-07-07 at 18:21 +0300, Andy Shevchenko wrote:
> This allows user to print a given buffer as esaped string. The rules applied

as an escaped

> accordingly to the mix of the flags provided by additional format letters.

rules are applied according to an optional mix of flags

> For example, if the given buffer:
> 
> 	1b 62 20 5c 43 07 22 90 0d 5d
> 
> The result strings could be:

would be

> 	%*pE            "\eb \C\a"\220\r]"

Maybe say something about ssid's here.
or maybe add an %*pES just for the ssid type.

> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
[]
> @@ -70,6 +70,34 @@ DMA addresses types dma_addr_t:
>  	For printing a dma_addr_t type which can vary based on build options,
>  	regardless of the width of the CPU data path. Passed by reference.
>  
> +Raw buffer as an escaped string:
> +
> +	%*pE[achnops]
> +
> +	For printing raw buffer as an escaped string. For the following buffer
> +
> +		1b 62 20 5c 43 07 22 90 0d 5d
> +
> +	few examples show how the conversion could be done (the result string
> +	without embraced quotes):

'embraced' is a bit of an awkward word choice.  Maybe surrounding.

> +
> +		%*pE		"\eb \C\a"\220\r]"

Oh, the initial commit log comments above are really for this block

> +		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
> +		%*pEa		"\e\142\040\\\103\a\042\220\r\135"
> +
> +	The converion rules are defined by combination of the following flags

conversion

> +	(see string_escape_mem() kernel documentation for the details):
> +		a - ESCAPE_ANY
> +		c - ESCAPE_SPECIAL
> +		h - ESCAPE_HEX
> +		n - ESCAPE_NULL
> +		o - ESCAPE_OCTAL
> +		p - ESCAPE_NP
> +		s - ESCAPE_SPACE
> +	By default ESCAPE_ANY_NP is used.
> +
> +	If field width is ommited the 1 byte only will be escaped.

omitted


