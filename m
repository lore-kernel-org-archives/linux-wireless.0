Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbdJEHXm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 03:23:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxm@marvell.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: Use put_unaligned_le32
References: <1507141686-5178-1-git-send-email-himanshujha199640@gmail.com>
Date: Thu, 05 Oct 2017 10:23:37 +0300
In-Reply-To: <1507141686-5178-1-git-send-email-himanshujha199640@gmail.com>
        (Himanshu Jha's message of "Wed, 4 Oct 2017 23:58:06 +0530")
Message-ID: <874lre5a86.fsf@codeaurora.org> (sfid-20171005_092437_773563_982D8A18)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> writes:

> Use put_unaligned_le32 rather than using byte ordering function and
> memcpy which makes code clear.
> Also, add the header file where it is declared.
>
> Done using Coccinelle and semantic patch used is :
>
> @ rule1 @
> identifier tmp; expression ptr,x; type T;
> @@
>
> - tmp = cpu_to_le32(x);
>
>   <+... when != tmp
> - memcpy(ptr, (T)&tmp, ...);
> + put_unaligned_le32(x,ptr);
>   ...+>
>
> @ depends on rule1 @
> type j; identifier tmp;
> @@
>
> - j tmp;
>   ...when != tmp
>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 0edc5d6..e28e119 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -17,6 +17,7 @@
>   * this warranty disclaimer.
>   */
>  
> +#include <linux/unaligned/access_ok.h>

I don't think this is correct. Should it be asm/unaligned.h?

-- 
Kalle Valo
