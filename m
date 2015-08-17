Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46600 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbHQRbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 13:31:46 -0400
Date: Mon, 17 Aug 2015 20:31:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: wilc1000: replace MALLOC_WILC_BUFFER()
 macro to avoid possible memory leak
Message-ID: <20150817173152.GC5610@mwanda> (sfid-20150817_193200_373979_4CD9D857)
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com>
 <cover.1439827537.git.raphael.beamonte@gmail.com>
 <c8b8d96496a5502d6f02ff53f319f16bc612ff30.1439827537.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <c8b8d96496a5502d6f02ff53f319f16bc612ff30.1439827537.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 12:08:35PM -0400, Raphaël Beamonte wrote:
> The MACRO_WILC_BUFFER() macro was using a return statement, and didn't
> take care of possible memory leaks and subsequent bugs when it was failing
> after succeeding some allocations. This patch corrects this behavior.
> 
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_exported_buf.c | 39 +++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
> index bf392fb..c3aff9a 100644
> --- a/drivers/staging/wilc1000/wilc_exported_buf.c
> +++ b/drivers/staging/wilc1000/wilc_exported_buf.c
> @@ -8,13 +8,6 @@
>  #define LINUX_TX_SIZE	(64 * 1024)
>  #define WILC1000_FW_SIZE (4 * 1024)
>  
> -#define MALLOC_WILC_BUFFER(name, size)	\
> -	exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
> -	if (!exported_ ## name) {   \
> -		printk("fail to alloc: %s memory\n", exported_ ## name);  \
> -		return -ENOBUFS;	\
> -	}
> -
>  /*
>   * Add necessary buffer pointers
>   */
> @@ -40,17 +33,43 @@ void *get_fw_buffer(void)
>  }
>  EXPORT_SYMBOL(get_fw_buffer);
>  
> +static inline int kmalloc_wilc_buffer(void *buf, int size)
> +{
> +	buf = kmalloc(size, GFP_KERNEL);
> +	if (!buf) {
> +		printk("fail to alloc memory\n");
> +		return -ENOBUFS;
> +	}
> +	return 0;
> +}
> +
>  static int __init wilc_module_init(void)
>  {
>  	printk("wilc_module_init\n");
>  	/*
>  	 * alloc necessary memory
>  	 */
> -	MALLOC_WILC_BUFFER(g_tx_buf, LINUX_TX_SIZE)
> -	MALLOC_WILC_BUFFER(g_rx_buf, LINUX_RX_SIZE)
> -	MALLOC_WILC_BUFFER(g_fw_buf, WILC1000_FW_SIZE)
> +	if (kmalloc_wilc_buffer(exported_g_tx_buf, LINUX_TX_SIZE))
> +		goto error_g_tx_buf;

Don't do it this way.  Just do:

	exported_g_tx_buf = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
	if (!exported_g_tx_buf)
		return -ENOMEM;

	exported_g_rx_buf = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
	if (!exported_g_rx_buf)
		goto free_tx_buf;

1) Avoid abstraction where possible.
2) The error code should be -ENOMEM
3) This is not a universal rule, but I feel it's better to return
   directly instead of using a do-nothing-goto.  Some people think
   using gotos everywhere forces you to think about error handling so
   it is worth making the code slightly less readable.  Based on my
   static analysis results, I do not believe that it makes people think
   about error handling.
4) Name the label after the where the label is (what it does on the next
   line) instead of basing it on the goto location.
5) Preserve the error codes.  Use ret = kmalloc_wilc_buffer(); if (ret).

regards,
dan carpenter

