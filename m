Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbcBPCWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 21:22:41 -0500
Date: Mon, 15 Feb 2016 18:22:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin King <colin.king@canonical.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: remove wilc1000_spi_ops as it is not
 used
Message-ID: <20160216022240.GA31825@kroah.com> (sfid-20160216_032258_101011_BC89D018)
References: <1455549507-25553-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1455549507-25553-1-git-send-email-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 15, 2016 at 03:18:27PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> building with gcc 6 I hit a build failure:
> 
>   CC      drivers/staging/wilc1000/wilc_spi.o
> drivers/staging/wilc1000/wilc_spi.c:123:34: error: storage size of
>  ‘wilc1000_spi_ops’ isn’t known
>  static const struct wilc1000_ops wilc1000_spi_ops;
>                                   ^~~~~~~~~~~~~~~~
> drivers/staging/wilc1000/wilc_spi.c:123:34: warning: ‘wilc1000_spi_ops’
>   defined but not used [-Wunused-const-variable]
> 
> Since wilc1000_spi_ops is not used, remove it and the driver builds.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/wilc1000/wilc_spi.c | 2 --
>  1 file changed, 2 deletions(-)

Doesn't apply to my tree at all, are you sure you are using linux-next
for this?

thanks,

greg k-h
