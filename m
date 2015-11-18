Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33123 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbbKRGTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:19:40 -0500
Date: Wed, 18 Nov 2015 11:49:28 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Bogicevic Sasa <brutallesale@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:wilc1000 Fix comparison to NULL messages
Message-ID: <20151118061927.GA6229@sudip-pc> (sfid-20151118_071955_703232_EF255281)
References: <1447790488-17742-1-git-send-email-brutallesale@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447790488-17742-1-git-send-email-brutallesale@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2015 at 09:01:28PM +0100, Bogicevic Sasa wrote:
> This fixes all "Comparison to NULL could be written like..."
> messages from checkpatch.pl
> 
> Signed-off-by: Bogicevic Sasa <brutallesale@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index fd7240c..a31ac55 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -434,7 +434,7 @@ s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>  
>  		/* Get DTIM Period */
>  		pu8TimElm = get_tim_elm(pu8msa, u16RxLen + FCS_LEN, u8index);
> -		if (pu8TimElm != NULL)
> +		if (!pu8TimElm)

You are now checking for -  if (pu8TimElm == NULL)	
It should actually be: if (pu8TimElm)

regards
sudip
