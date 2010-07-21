Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35560 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0GUQhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 12:37:06 -0400
Subject: Re: [PATCH] zd1211rw: make CR_INTERRUPT cast explicit
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <1279724935-16581-1-git-send-email-linville@tuxdriver.com>
References: <1279724935-16581-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 12:36:58 -0400
Message-ID: <1279730218.9003.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-21 at 11:08 -0400, John W. Linville wrote:
> CHECK   drivers/net/wireless/zd1211rw/zd_usb.c
> drivers/net/wireless/zd1211rw/zd_usb.c:376:24: warning: implicit cast from nocast type
> 
> The value comparison is intentional, so forcing the cast seems warranted
> in order to silence the sparse warning.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
> index 818e148..acbf4d9 100644
> --- a/drivers/net/wireless/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zd1211rw/zd_usb.c
> @@ -373,7 +373,7 @@ static inline void handle_regs_int(struct urb *urb)
>  	spin_lock(&intr->lock);
>  
>  	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
> -	if (int_num == CR_INTERRUPT) {
> +	if (int_num == (u16 __force) CR_INTERRUPT) {

I think __force should be used sparingly, especially outside headers.  I
tried other ways to prevent the warning.  I tried declaring int_num as
zd_addr_t, but sparse keeps complaining about the same comparison.

I can rewrite "if" as "switch" to suppress the warning, but it makes the
code less readable.  I think it's a bug in sparse.  There should be no
casts when comparing values of the same type.

I understand the benefits of fixing sparse warnings, but this patch
works around a sparse bug and sets a bad example.

-- 
Regards,
Pavel Roskin
