Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19841 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbbHJKog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 06:44:36 -0400
Date: Mon, 10 Aug 2015 13:44:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, jude.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
Message-ID: <20150810104412.GL5180@mwanda> (sfid-20150810_124450_136207_D945E2FC)
References: <1439186304-3480-1-git-send-email-tony.cho@atmel.com>
 <1439186304-3480-6-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439186304-3480-6-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2015 at 02:58:24PM +0900, Tony Cho wrote:
> +static u32 add_handler_in_list(tstrWILC_WFIDrv *handler)

I am suspicous of code which uses u32 for something where the hardware
doesn't specify unsigned 32 bits.  Why not just return "int"?

> +{
> +	u32 id;

It looks like we have a case of u32 disease.  Prefer int over u32 unless
there is a reason for it.

> +
> +	if (!handler)
> +		return 0;

Don't add NULL checks unless it makes sense.  How are we supposed to
recover from this if handler is NULL?

> +
> +	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
> +		if (!wfidrv_list[id]) {
> +			wfidrv_list[id++] = handler;


Ugh...  I don't like the ++ here.  Just use a zero offset array or we
are going to have off by one bugs.

> +			break;
> +		}
> +	}
> +
> +	if (id > NUM_CONCURRENT_IFC)
> +		return 0;

Well, that didn't take long, it's three lines later and we already have
hit our first off by one bug.  This check can never be true.  Of course,
no one checks the return value either...

> +
> +	return id;
> +}

I guess I would be fine with this patch if you changed it to use a zero
offset array, ints instead of u32s and added some error handling.

regards,
dan carpenter

