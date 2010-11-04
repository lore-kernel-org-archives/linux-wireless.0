Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50359 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0KDVct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 17:32:49 -0400
Received: by gwj21 with SMTP id 21so1812348gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 14:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201011042038.35919.IvDoorn@gmail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011042037.47939.IvDoorn@gmail.com>
	<201011042038.16312.IvDoorn@gmail.com>
	<201011042038.35919.IvDoorn@gmail.com>
Date: Thu, 4 Nov 2010 21:32:48 +0000
Message-ID: <AANLkTi=1eHFOX5S6H_ZETWoXz_8nm5Xd+hExrRWX7go8@mail.gmail.com>
Subject: Re: [PATCH 05/13] rt2x00: Add unlikely to skb allocation failure check
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 7:38 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> From: Helmut Schaa <helmut.schaa@googlemail.com>
>
> The skb allocation should really only fail under high memory pressure
> or other uncommon situations. Hence, mark the allocation failure check
> as unlikely.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 5ba79b9..a5c7a4f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -491,7 +491,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
>         * received frame and reuse the existing buffer.
>         */
>        skb = rt2x00queue_alloc_rxskb(entry);
> -       if (!skb)
> +       if (unlikely(!skb))
>                goto submit_entry;
>
>        /*
> --
err, wait a sec, I've been looking for this mail for some time, but:

http://mail.linux.ie/pipermail/ilug/2004-December/075654.html

"Note tests for NULL (!something) don't need an unlikely as gcc does
 that by default itself."

But there's more, according to http://gcc.gnu.org/news/profiledriven.html:
(static program profile) gcc expect pointers to be non-null

(therefore all !skb tests should be unlikely branches by default, or?)

Best regards,
    Chr
