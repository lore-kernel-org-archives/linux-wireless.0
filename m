Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1IZIYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 04:24:52 -0400
Subject: Re: [patch] wl3501_cs: min_t() cast truncates high bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20110926063040.GE11832@elgon.mountain> (sfid-20110926_101711_920668_B3BB1CCE)
References: <20110926063040.GE11832@elgon.mountain>
	 (sfid-20110926_101711_920668_B3BB1CCE)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 10:24:37 +0200
Message-ID: <1317025477.4117.21.camel@jlt3.sipsolutions.net> (sfid-20110926_102457_082675_283691D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 09:30 +0300, Dan Carpenter wrote:
> wrqu->encoding.length comes from the network administrator.  It's
> size u16.  We want to limit "tocopy" to the smallest value of either
> "len_keys", "wrqu->encoding.length" or 100.  But because .length
> gets cast from u16 to u8 we might use a random, smaller value than
> the was desired.  It's probably not very serious, but we may as well
> fix it.

Nice catch.

> Btw, this is from code auditing and not from testing.  I don't know
> if this affects anyone in real life.

FWIW, it doesn't, the max key length that makes sense is 32 anyway, and
since this is on an output path I doubt the min_t() will ever have done
anything but returned "tocopy" :-)

johannes

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
> index 6bc7c92..98fbf54 100644
> --- a/drivers/net/wireless/wl3501_cs.c
> +++ b/drivers/net/wireless/wl3501_cs.c
> @@ -1781,7 +1781,7 @@ static int wl3501_get_encode(struct net_device *dev,
>  				  keys, len_keys);
>  	if (rc)
>  		goto out;
> -	tocopy = min_t(u8, len_keys, wrqu->encoding.length);
> +	tocopy = min_t(u16, len_keys, wrqu->encoding.length);
>  	tocopy = min_t(u8, tocopy, 100);
>  	wrqu->encoding.length = tocopy;
>  	memcpy(extra, keys, tocopy);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


