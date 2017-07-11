Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932598AbdGKREx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 13:04:53 -0400
Date: Tue, 11 Jul 2017 19:04:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rui Teng <rui.teng@linux.vnet.ibm.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/wilc1000: fix sparse warning: right
 shift by bigger than source value
Message-ID: <20170711170449.GA30362@kroah.com> (sfid-20170711_190516_898963_31C63418)
References: <20170710085731.28397-1-rui.teng@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170710085731.28397-1-rui.teng@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 10, 2017 at 04:57:31PM +0800, Rui Teng wrote:
> This patch sets memory to zero directly to avoid unnecessary shift and
> bitwise operations on bool type, which can fix a sparse warning and also
> improve performance.

It does?  How did you measure the performance impact?  What was now
faster?

thanks,

greg k-h


> 
> Signed-off-by: Rui Teng <rui.teng@linux.vnet.ibm.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 2568dfc15181..036c5c19a016 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2416,10 +2416,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
>  		goto ERRORHANDLER;
>  
>  	pu8CurrByte = wid.val;
> -	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
> +	memset(pu8CurrByte, 0, 4);
> +	*pu8CurrByte = (strHostIfSetMulti->enabled & 0xFF);
> +	pu8CurrByte += 4;

Are you sure enabled isn't larger than 8 bits?

thanks,

greg k-h
