Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61618 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab0ECTKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 15:10:41 -0400
Subject: Re: [PATCH] compat: backport usb_alloc_coherent() and
 usb_free_coherent()
From: Pavel Roskin <proski@gnu.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
In-Reply-To: <1272911773-18486-1-git-send-email-hauke@hauke-m.de>
References: <1272911773-18486-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain
Date: Mon, 03 May 2010 15:10:38 -0400
Message-Id: <1272913838.2607.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 20:36 +0200, Hauke Mehrtens wrote:
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.35.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
> index 9132ecb..62c54cf 100644
> --- a/include/linux/compat-2.6.35.h
> +++ b/include/linux/compat-2.6.35.h
> @@ -19,6 +19,8 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
>  {
>  	return sk->sk_sleep;
>  }
> +#define usb_alloc_coherent usb_buffer_alloc
> +#define usb_free_coherent usb_buffer_free

I believe macros with arguments are preferred.

It really matters in case of simple names that can be reasonably used as
variable names as well (e.g. "max").

In this case, it's more a matter of style and readability.
 
-- 
Regards,
Pavel Roskin
