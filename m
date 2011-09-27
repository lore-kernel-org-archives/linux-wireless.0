Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32938 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1I0Tru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 15:47:50 -0400
Date: Tue, 27 Sep 2011 15:47:39 -0400
From: Pavel Roskin <proski@gnu.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2.1] wireless: at76c50x: use native hex_pack_byte()
 method
Message-ID: <20110927154739.2cd368d5@mj> (sfid-20110927_214754_134178_1C278D87)
In-Reply-To: <3feae30d537a79c064495cc834f585192a1e636d.1317124866.git.andriy.shevchenko@linux.intel.com>
References: <71d8213731be21f26a82255a4fffdbe1b6dd4a44.1316774801.git.andriy.shevchenko@linux.intel.com>
	<3feae30d537a79c064495cc834f585192a1e636d.1317124866.git.andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Sep 2011 15:01:49 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/wireless/at76c50x-usb.c |   18 +++++++-----------
>  1 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/at76c50x-usb.c

...

> b/drivers/net/wireless/at76c50x-usb.c index 2986014..2dde5f6 100644
> -		*obuf++ = BIN2HEX(*ibuf >> 4);
> -		*obuf++ = BIN2HEX(*ibuf & 0xf);
> +		obuf = pack_hex_byte(obuf, *ibuf++);
>  		*obuf++ = '-';
> -		ibuf++;
>  	}
> -	*(--obuf) = '\0';
> +
> +	if (*obuf == '-')
> +		obuf--;

This will access uninitialized data and fail to strip the final "-" in
most cases.  The check for len being 0 was there for a reason.  Please
actually test your code.

NACK

By the way, I don't think it's necessary to copy linux-kernel and
netdev about a change affecting just a wireless driver.

-- 
Regards,
Pavel Roskin
