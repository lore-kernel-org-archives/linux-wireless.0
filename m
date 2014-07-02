Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:54318 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751297AbaGBNng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 09:43:36 -0400
Message-ID: <1404308611.14624.78.camel@joe-AO725> (sfid-20140702_154352_269313_A2C5D5DC)
Subject: Re: [PATCH 3/6] lib80211: re-use string_escape_mem_any_np()
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 02 Jul 2014 06:43:31 -0700
In-Reply-To: <1404307229-19186-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-4-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-02 at 16:20 +0300, Andy Shevchenko wrote:
> In kernel we have function to escape a given string. Let's use it instead of
> custom approach.
> 
> This fixes a bug. The current implementation wrongly prints octal numbers: only
> two first digits are used in case when 3 are required and the rest of the
> string ends up cut off.
[]
> diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
[]
> @@ -48,31 +49,10 @@ static void lib80211_crypt_deinit_handler(unsigned long data);
>  
>  const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
>  {
> -	const char *s = ssid;
>  	char *d = buf;
>  
>  	ssid_len = min_t(u8, ssid_len, IEEE80211_MAX_SSID_LEN);
> -	while (ssid_len--) {
> -		if (isprint(*s)) {
> -			*d++ = *s++;
> -			continue;
> -		}
> -
> -		*d++ = '\\';
> -		if (*s == '\0')
> -			*d++ = '0';
> -		else if (*s == '\n')
> -			*d++ = 'n';
> -		else if (*s == '\r')
> -			*d++ = 'r';
> -		else if (*s == '\t')
> -			*d++ = 't';
> -		else if (*s == '\\')
> -			*d++ = '\\';
> -		else
> -			d += snprintf(d, 3, "%03o", *s);
> -		s++;
> -	}
> +	d += string_escape_mem_any_np(ssid, ssid_len, buf, ~0UL, NULL);
>  	*d = '\0';
>  	return buf;
>  }

This code looks like it was adapted from the old print_mac
ethernet code that was eventually replaced by a vsprintf
pointer extension %pM

So a better way to do this might be to add and use yet
another vsprintf %p<foo> extension for ssids.


