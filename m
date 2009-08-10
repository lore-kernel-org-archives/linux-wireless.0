Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:51044 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZHJWtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 18:49:53 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1213475wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 15:49:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249735096-27071-7-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
	<1249735096-27071-7-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 10 Aug 2009 15:49:34 -0700
Message-ID: <43e72e890908101549h344a6c14vd4e09a019c727346@mail.gmail.com>
Subject: Re: [PATCH 7/7] [compat-2.6] Remove unsed code.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 8, 2009 at 5:38 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

So actually I have this here for when we get around to backport the
usb stuff to older kernels, the usb poison stuff, if I remember
correctly. I just never finished that. I'd prefer to drop it if we're
sure we won't need it to make ar9170 compile against older kernels.

  Luis

> ---
>  compat/compat-2.6.28.c |   40 ----------------------------------------
>  compat/compat-2.6.28.h |    3 ---
>  2 files changed, 0 insertions(+), 43 deletions(-)
>
> diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
> index 33871a2..965be80 100644
> --- a/compat/compat-2.6.28.c
> +++ b/compat/compat-2.6.28.c
> @@ -167,46 +167,6 @@ struct urb *usb_get_from_anchor(struct usb_anchor *anchor)
>
>  EXPORT_SYMBOL_GPL(usb_get_from_anchor);
>
> -/**
> - * usb_scuttle_anchored_urbs - unanchor all an anchor's urbs
> - * @anchor: the anchor whose urbs you want to unanchor
> - *
> - * use this to get rid of all an anchor's urbs
> - */
> -void usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
> -{
> -       struct urb *victim;
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&anchor->lock, flags);
> -       while (!list_empty(&anchor->urb_list)) {
> -               victim = list_entry(anchor->urb_list.prev, struct urb,
> -                                   anchor_list);
> -               usb_get_urb(victim);
> -               spin_unlock_irqrestore(&anchor->lock, flags);
> -               /* this may free the URB */
> -               usb_unanchor_urb(victim);
> -               usb_put_urb(victim);
> -               spin_lock_irqsave(&anchor->lock, flags);
> -       }
> -       spin_unlock_irqrestore(&anchor->lock, flags);
> -}
> -
> -EXPORT_SYMBOL_GPL(usb_scuttle_anchored_urbs);
> -
> -/**
> - * usb_anchor_empty - is an anchor empty
> - * @anchor: the anchor you want to query
> - *
> - * returns 1 if the anchor has no urbs associated with it
> - */
> -int usb_anchor_empty(struct usb_anchor *anchor)
> -{
> -       return list_empty(&anchor->urb_list);
> -}
> -
> -EXPORT_SYMBOL_GPL(usb_anchor_empty);
> -
>
>  void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
>  {
> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
> index e25259f..0a305d2 100644
> --- a/compat/compat-2.6.28.h
> +++ b/compat/compat-2.6.28.h
> @@ -47,9 +47,6 @@ extern void usb_poison_anchored_urbs(struct usb_anchor *anchor);
>  #endif
>
>  extern struct urb *usb_get_from_anchor(struct usb_anchor *anchor);
> -extern void usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
> -extern int usb_anchor_empty(struct usb_anchor *anchor);
> -
>
>  void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
>
> --
> 1.6.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
