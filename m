Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbZEZTTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 15:19:38 -0400
Subject: Re: [PATCH -next] iwmc3200wifi: fix printk format
From: Samuel Ortiz <samuel@sortiz.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <4A1C4060.5070202@oracle.com>
References: <4A1C4060.5070202@oracle.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 21:21:47 +0200
Message-Id: <1243365707.2737.0.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 12:17 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format for size_t variable:
> 
> drivers/net/wireless/iwmc3200wifi/fw.c:75: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Thanks Randy.

Cheers,
Samuel.

> Cc: ilw@linux.intel.com
> ---
>  drivers/net/wireless/iwmc3200wifi/fw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20090526.orig/drivers/net/wireless/iwmc3200wifi/fw.c
> +++ linux-next-20090526/drivers/net/wireless/iwmc3200wifi/fw.c
> @@ -72,7 +72,7 @@ static int iwm_fw_op_offset(struct iwm_p
>  	}
>  
>  	if (fw->size < IWM_HDR_LEN) {
> -		IWM_ERR(iwm, "FW is too small (%d)\n", fw->size);
> +		IWM_ERR(iwm, "FW is too small (%zu)\n", fw->size);
>  		return -EINVAL;
>  	}
>  
> 

