Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:43074 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbHQTlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:41:13 -0400
Message-ID: <55D238D4.20800@broadcom.com> (sfid-20150817_214129_266022_3864BB91)
Date: Mon, 17 Aug 2015 21:41:08 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFwaGHDq2wgQmVhbW9udGU=?= <raphael.beamonte@gmail.com>,
	"Johnny Kim" <johnny.kim@atmel.com>
CC: Rachel Kim <rachel.kim@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	"Chris Park" <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-kernel@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv2 5/5] staging: wilc1000: replace MALLOC_WILC_BUFFER()
 macro to avoid possible memory leak
References: <cover.1439838526.git.raphael.beamonte@gmail.com> <339fc87526f51233b262315b2297f68e3b00c7b6.1439838526.git.raphael.beamonte@gmail.com>
In-Reply-To: <339fc87526f51233b262315b2297f68e3b00c7b6.1439838526.git.raphael.beamonte@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/17/2015 09:28 PM, Raphaël Beamonte wrote:
> The MACRO_WILC_BUFFER() macro was using a return statement, and didn't

Probable MACRO_WILC_BUFFER should be MALLOC_WILC_BUFFER here.

> take care of possible memory leaks and subsequent bugs when it was failing
> after succeeding some allocations. This patch corrects this behavior.
>
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
> ---
>   drivers/staging/wilc1000/wilc_exported_buf.c | 37 ++++++++++++++++++++--------
>   1 file changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
> index c9a5943..0f3bdad 100644
> --- a/drivers/staging/wilc1000/wilc_exported_buf.c
> +++ b/drivers/staging/wilc1000/wilc_exported_buf.c
> @@ -8,13 +8,6 @@
>   #define LINUX_TX_SIZE	(64 * 1024)
>   #define WILC1000_FW_SIZE (4 * 1024)
>
> -#define MALLOC_WILC_BUFFER(name, size)	\
> -	exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
> -	if (!exported_ ## name) {   \
> -		printk("fail to alloc: %s memory\n", exported_ ## name);  \
> -		return -ENOBUFS;	\
> -	}
> -
>   /*
>    * Add necessary buffer pointers
>    */
> @@ -45,11 +38,35 @@ static int __init wilc_module_init(void)
>   	/*
>   	 * alloc necessary memory
>   	 */
> -	MALLOC_WILC_BUFFER(g_tx_buf, LINUX_TX_SIZE)
> -	MALLOC_WILC_BUFFER(g_rx_buf, LINUX_RX_SIZE)
> -	MALLOC_WILC_BUFFER(g_fw_buf, WILC1000_FW_SIZE)
> +	exported_g_tx_buf = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
> +	if (!exported_g_tx_buf) {
> +		pr_err("fail to alloc tx buf");

There is really no need to print an error message here. kmalloc will 
blurb enough info when it fails.

So these buffers are globals? So does this driver support multiple 
devices, ie. how are these used when two wilc1000 supported devices are 
present.

Regards,
Arend

> +		return -ENOMEM;
> +	}
> +
> +	exported_g_rx_buf = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
> +	if (!exported_g_rx_buf) {
> +		pr_err("fail to alloc rx buf");
> +		goto free_g_tx_buf;
> +	}
> +
> +	exported_g_fw_buf = kmalloc(WILC1000_FW_SIZE, GFP_KERNEL);
> +	if (!exported_g_fw_buf) {
> +		pr_err("fail to alloc fw buf");
> +		goto free_g_rx_buf;
> +	}
>
>   	return 0;
> +
> +free_g_rx_buf:
> +	kfree(exported_g_rx_buf);
> +	exported_g_rx_buf = NULL;
> +
> +free_g_tx_buf:
> +	kfree(exported_g_tx_buf);
> +	exported_g_tx_buf = NULL;
> +
> +	return -ENOMEM;
>   }
>
>   static void __exit wilc_module_deinit(void)
>

