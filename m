Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14799 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751795AbdIVHXS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Sep 2017 03:23:18 -0400
Date: Fri, 22 Sep 2017 09:23:16 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Colin King <colin.king@canonical.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: iwlegacy: make const array static to shink
 object code size Content-Type: text/plain; charset="utf-8" Content-Transfer-Encoding:
 8bit
In-Reply-To: <20170921225630.21916-1-colin.king@canonical.com>
Message-ID: <alpine.DEB.2.20.1709220921350.2024@hadrien> (sfid-20170922_092335_594816_137CFEA3)
References: <20170921225630.21916-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 21 Sep 2017, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
>
> Don't populate const array ac_to_fifo on the stack in an inlined
> function, instead make it static.  Makes the object code smaller
> by over 800 bytes:
>
>    text	   data	    bss	    dec	    hex	filename
>  159029	  33154	   1216	 193399	  2f377	4965-mac.o
>
>    text	   data	    bss	    dec	    hex	filename
>  158122	  33250	   1216	 192588	  2f04c	4965-mac.o
>
> (gcc version 7.2.0 x86_64)

Gcc 7 must be much more aggressive about inlining than gcc 4.  Here is the
change that I got on this file:

     text          data     bss     dec     hex filename
-   76346          1494     152   77992   130a8 drivers/net/wireless/intel/iwlegacy/4965-mac.o
+   76298          1494     152   77944   13078 drivers/net/wireless/intel/iwlegacy/4965-mac.o
decrease of 48

julia

>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> index de9b6522c43f..65eba2c24292 100644
> --- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> @@ -1480,7 +1480,7 @@ il4965_get_ac_from_tid(u16 tid)
>  static inline int
>  il4965_get_fifo_from_tid(u16 tid)
>  {
> -	const u8 ac_to_fifo[] = {
> +	static const u8 ac_to_fifo[] = {
>  		IL_TX_FIFO_VO,
>  		IL_TX_FIFO_VI,
>  		IL_TX_FIFO_BE,
> --
> 2.14.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
