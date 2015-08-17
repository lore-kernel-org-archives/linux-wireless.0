Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40302 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbHQJIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 05:08:55 -0400
Date: Mon, 17 Aug 2015 12:08:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] staging: wilc1000: code style: fix macro with
 multiple statements
Message-ID: <20150817090828.GB5558@mwanda> (sfid-20150817_110916_466886_3D93ABF0)
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
 <641be2615e97db253a306c766a48c2afccf338d7.1439702894.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <641be2615e97db253a306c766a48c2afccf338d7.1439702894.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 16, 2015 at 01:30:12AM -0400, Raphaël Beamonte wrote:
>  #define MALLOC_WILC_BUFFER(name, size)	\
> -	exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
> -	if (!exported_ ## name) {   \
> -		printk("fail to alloc: %s memory\n", exported_ ## name);  \
> -		return -ENOBUFS;	\
> -	}
> +	do { \
> +		exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
> +		if (!exported_ ## name) {   \
> +			printk("fail to alloc: %s memory\n", exported_ ## name);  \
> +			return -ENOBUFS;	\
> +		}
> +	} while (0)

Pull it in one indent level...  But actually this macro has a return in
the middle of it, so it just introduces bugs all over the place like
eating cookies in bed.  We should just delete it instead.

regards,
dan carpenter

