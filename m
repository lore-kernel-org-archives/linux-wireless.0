Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:57924 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751226AbaGBNf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 09:35:56 -0400
Message-ID: <1404308150.14624.73.camel@joe-AO725> (sfid-20140702_153632_053779_5986F38F)
Subject: Re: [PATCH 5/6] staging: rtl8192e: re-use string_escape_mem()
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 02 Jul 2014 06:35:50 -0700
In-Reply-To: <1404307229-19186-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-6-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-02 at 16:20 +0300, Andy Shevchenko wrote:
> Let's use kernel's library function to escape a buffer.
[]
> diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
[]
> @@ -2956,7 +2957,6 @@ extern inline int rtllib_get_scans(struct rtllib_device *ieee)
>  static inline const char *escape_essid(const char *essid, u8 essid_len)
>  {
>  	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
> -	const char *s = essid;
>  	char *d = escaped;
>  
>  	if (rtllib_is_empty_essid(essid, essid_len)) {
> @@ -2965,15 +2965,8 @@ static inline const char *escape_essid(const char *essid, u8 essid_len)
>  	}
>  
>  	essid_len = min(essid_len, (u8)IW_ESSID_MAX_SIZE);
> -	while (essid_len--) {
> -		if (*s == '\0') {
> -			*d++ = '\\';
> -			*d++ = '0';
> -			s++;
> -		} else {
> -			*d++ = *s++;
> -		}
> -	}
> +	d += string_escape_mem(essid, essid_len, escaped, sizeof(escaped) - 1,
> +			       ESCAPE_NULL, NULL);

I'd've probably used

	d += string_escape_mem(essid, essid_len, d, ...
or
	d = escaped + string_escap_mem(essid, essid_len, escaped, ...

so there's some relation between the thing being added to

>  	*d = '\0';

or maybe not used d at all with

	escaped[1 + string_escape_mem(etc...)] = 0;

>  	return escaped;
>  }

Unrelated but this isn't a thread safe or multiple instance
safe function.

It seems it's used only in debugging message output though.

