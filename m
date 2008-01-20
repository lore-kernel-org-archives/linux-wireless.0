Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:47311 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYATTEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 14:04:04 -0500
Received: by py-out-1112.google.com with SMTP id u52so2493888pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 11:04:03 -0800 (PST)
Message-ID: <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com> (sfid-20080120_190410_516717_0B012CF5)
Date: Sun, 20 Jan 2008 14:04:02 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
Subject: Re: [PATCH] WEXT: Correct the size of the buffer to be copied to user-space in standard GET WE ioctls.
Cc: linux-wireless@vger.kernel.org, "Jean Tourrilhes" <jt@hpl.hp.com>
In-Reply-To: <4793935F.2000102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4793935F.2000102@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Jean.

  Luis

On Jan 20, 2008 1:30 PM, Volodymyr G. Lukiianyk <volodymyrgl@gmail.com> wrote:
> For the most of standard WE GET ioctls the size of the buffer to store driver's
> response is calculated on base of the call's descriptor (.token_size and
> .max_tokens fields) without taking into consideration the size of the buffer
> provided by application in struct iwreq. But when the response is being copied to
> userspace, its size is calculated from the length provided by application. This
> can lead to kernel internal data leak into userspace, and oopses when the buffer
> is located near the end of the available memory. To prevent these situations the
> size used during copying is set to the same one used during allocation.
>
>
> Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
> ---
>
> I've actually seen those oopses on the system with 32MB of memory, when 1k
> object at address c1fffc00 was returned by the SLAB while handling request for
> allocating 568 bytes buffer (struct iw_range). Later, copy_to_user() (instructed
> to copy 1136 bytes, since iwlist uses 2x buffer) crashed trying to access
> c2000000, which is beyond the bounds of available 32MB.
>
> The patch attached is against the Linus's tree.
>
>
> diff --git a/net/wireless/wext.c b/net/wireless/wext.c
> index 47e80cc..c6ce59b 100644
> --- a/net/wireless/wext.c
> +++ b/net/wireless/wext.c
> @@ -866,8 +866,7 @@ static int ioctl_standard_call(struct net_device *  dev,
>                         }
>
>                         err = copy_to_user(iwr->u.data.pointer, extra,
> -                                          iwr->u.data.length *
> -                                          descr->token_size);
> +                                          extra_size);
>                         if (err)
>                                 ret =  -EFAULT;
>                 }
>
>
