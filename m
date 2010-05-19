Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62396 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0ESG5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 02:57:12 -0400
Received: by fxm10 with SMTP id 10so1942860fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 23:57:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005190847.59068.helmut.schaa@googlemail.com>
References: <201005190847.59068.helmut.schaa@googlemail.com>
Date: Wed, 19 May 2010 08:57:10 +0200
Message-ID: <AANLkTikUBorBjZ03BR6m1X0vfVlLtunRQz1BD3mO0xAz@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: don't use to_pci_dev in rt2x00pci_uninitialize
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 8:47 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Don't use to_pci_dev in rt2x00pci_uninitialize to get the allocated irq
> as it won't work for platform devices (SoC). Instead, use the irq field
> that's already used everywhere else.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index a016f7c..f71eee6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -206,7 +206,7 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
>        /*
>         * Free irq line.
>         */
> -       free_irq(to_pci_dev(rt2x00dev->dev)->irq, rt2x00dev);
> +       free_irq(rt2x00dev->irq, rt2x00dev);
>
>        /*
>         * Free DMA
> --
> 1.6.4.2
>
>
