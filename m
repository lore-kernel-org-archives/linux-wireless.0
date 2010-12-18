Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56809 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0LRK6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 05:58:14 -0500
Received: by fxm18 with SMTP id 18so1545295fxm.2
        for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 02:58:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1012180014390.26257@math.ut.ee>
References: <alpine.SOC.1.00.1012180014390.26257@math.ut.ee>
Date: Sat, 18 Dec 2010 10:58:13 +0000
Message-ID: <AANLkTikmtWhSXn6-rFH6ABhSh3soO8jDfomAg9SGe3xX@mail.gmail.com>
Subject: Re: [PATCH] orinoco_cs: fix too early irq request
From: Dave Kilroy <kilroyd@googlemail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Meelis. An equivalent patch has already been merged in Linus'
v2.6.37-rc6 (229bd792b), and wireless-next.

Does that version also work for you?



On Fri, Dec 17, 2010 at 10:18 PM, Meelis Roos <mroos@linux.ee> wrote:
> orinoco_cs requests its irq too early. This results in irq coming in
> right afrer request_irq and before initializing other data structures,
> resulting in NULL pointer dereference on module load.
>
> Fix it by moving request_irq after other initialization tasks.
>
> Tested to work with Orinoco Gold PCMCIA card.
>
> Signed-off-by: Meelis Roos <mroos@linux.ee>
>
> diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
> index 71b3d68..47fc408 100644
> --- a/drivers/net/wireless/orinoco/orinoco_cs.c
> +++ b/drivers/net/wireless/orinoco/orinoco_cs.c
> @@ -151,10 +151,6 @@ orinoco_cs_config(struct pcmcia_device *link)
>                goto failed;
>        }
>
> -       ret = pcmcia_request_irq(link, orinoco_interrupt);
> -       if (ret)
> -               goto failed;
> -
>        /* We initialize the hermes structure before completing PCMCIA
>         * configuration just in case the interrupt handler gets
>         * called. */
> @@ -182,6 +178,10 @@ orinoco_cs_config(struct pcmcia_device *link)
>                goto failed;
>        }
>
> +       ret = pcmcia_request_irq(link, orinoco_interrupt);
> +       if (ret)
> +               goto failed;
> +
>        return 0;
>
>  failed:
>
> --
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
