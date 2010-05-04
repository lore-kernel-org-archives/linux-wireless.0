Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64419 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab0EDXaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 19:30:08 -0400
Received: by pwi5 with SMTP id 5so529924pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 16:30:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273012837-8325-1-git-send-email-hauke@hauke-m.de>
References: <1273012837-8325-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 4 May 2010 16:29:44 -0700
Message-ID: <n2t43e72e891005041629h21fe4a79ta2328d114ea7c1f3@mail.gmail.com>
Subject: Re: [PATCH] compat: backport orinoco updates
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 3:40 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.29.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
> index c3572a2..2709953 100644
> --- a/include/linux/compat-2.6.29.h
> +++ b/include/linux/compat-2.6.29.h
> @@ -61,6 +61,8 @@ extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
>
>  extern int eth_mac_addr(struct net_device *dev, void *p);
>
> +#define orinoco_if_add(priv, base_addr, irq, ops) orinoco_if_add(priv, base_addr, irq)
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */

Since we're going to have the netdevice ops available on older kernels
I'll skip this patch and first try by just backporting the netdevice
ops a bit differently. Thanks though.

  Luis
