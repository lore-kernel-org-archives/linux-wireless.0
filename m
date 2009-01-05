Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35257 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZAEW1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:27:54 -0500
Message-ID: <49628964.806@gmail.com> (sfid-20090105_232758_595939_0411947F)
Date: Mon, 05 Jan 2009 23:27:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Dave <kilroyd@googlemail.com>
CC: Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com>
In-Reply-To: <49626E4D.3010705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2009 09:32 PM, Dave wrote:
> --- a/drivers/net/wireless/orinoco/orinoco.c
> +++ b/drivers/net/wireless/orinoco/orinoco.c
> @@ -1616,9 +1616,15 @@ static void orinoco_rx_isr_tasklet(unsigned long
> data)
> 
>         /* extract desc and skb from queue */
>         list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
> +               unsigned long flags;
> +
>                 desc = rx_data->desc;
>                 skb = rx_data->skb;
> +
> +               local_irq_save(flags);
>                 list_del(&rx_data->list);
> +               local_irq_restore(flags);
> +

Hi,

another processor still can see inconsistent state, spinlock should be taken.
Or, am I missing something?

regards,
--js
