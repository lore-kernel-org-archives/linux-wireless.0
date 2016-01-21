Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34164 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcAUIS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 03:18:28 -0500
Received: by mail-pa0-f68.google.com with SMTP id yy13so1406670pab.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 00:18:28 -0800 (PST)
Date: Thu, 21 Jan 2016 13:48:16 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 25/27] staging: wilc1000: fix coding style of kmalloc
 usage
Message-ID: <20160121081816.GA10063@sudip-pc> (sfid-20160121_091832_228835_FB542B11)
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
 <1453339230-1377-25-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453339230-1377-25-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2016 at 10:20:28AM +0900, Chaehyun Lim wrote:
> This patch fixes coding style of kmalloc usage found by checkpatch.
> CHECK: Prefer kmalloc(sizeof(*new_msg)...) over kmalloc(sizeof(struct message)...)
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index 7107715..c7a60f4 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -70,7 +70,7 @@ int wilc_mq_send(struct message_queue *mq,
>  	}
>  
>  	/* construct a new message */
> -	new_msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
> +	new_msg = kmalloc(sizeof(*new_msg), GFP_ATOMIC);

This checkpatch error was introduced by 1/27 patch of this series. Maybe
it will be better to fix it in that one.

regards
sudip
