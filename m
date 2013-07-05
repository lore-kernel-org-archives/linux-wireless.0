Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab3GENQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:16:01 -0400
Message-ID: <1373030156.8548.22.camel@jlt4.sipsolutions.net> (sfid-20130705_151613_888447_2251576C)
Subject: Re: [PATCHv5 03/18] mac80211: fix timing for 5 MHz and 10 MHz
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 05 Jul 2013 15:15:56 +0200
In-Reply-To: <1372352340-20663-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372352340-20663-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 18:58 +0200, Simon Wunderlich wrote:

>  * change divisor to shift to avoid unnecesary integer divisions

That didn't really do much ;-)

>  	d->perfect_tx_time = ieee80211_frame_duration(band, 1200,
> -			rate->bitrate, erp, 1);
> +			DIV_ROUND_UP(rate->bitrate, 1 << shift), erp, 1,

That's still the integer division, unless the compiler can do something
about it?

> +			DIV_ROUND_UP(rate->bitrate, 1 << shift), erp, 1,

ditto

> +		mr->bitrate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
> +					   (1 << shift) * 5);

That looks even weirder?

> +		/* IEEE 802.11-2012 18.3.2.4: all values above are:
> +		 *  * times 4 for 5 MHz
> +		 *  * times 2 for 10 MHz
> +		 */
> +		dur *= 1 << shift;

Isn't that just "dur <<= shift"?

I think "DIV_ROUND_UP(x, 1 << shift)" can probably be written more
efficiently? Unless the compiler will do something by itself?

Something like

DIV_ROUND_UP(x, 1<<shift) == (x + (1<<shift) -1) >> shift

I think?

OK, it looks like if "x" is *unsigned* then the compiler will do this,
but with *signed* values it can't actually know because for negative
values it's obviously not actually equivalent.

johannes

