Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42371 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752149AbdA1VLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 16:11:05 -0500
Subject: Re: [PATCH v4 1/3] rt2x00: add copy of clk for soc devices
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
 <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <52ba40db-0f58-e982-2fd0-31d62343203d@nbd.name> (sfid-20170128_221107_933926_08151916)
Date: Sat, 28 Jan 2017 20:39:15 +0100
MIME-Version: 1.0
In-Reply-To: <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-20 14:28, Stanislaw Gruszka wrote:
> Since clk_get() is not trivial add copy of clk pointer to rt2x00dev
> for System On Chip devices and initialize it on probe routine.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h    | 4 ++++
>  drivers/net/wireless/ralink/rt2x00/rt2x00soc.c | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index bea7ac3..b59e721 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -39,6 +39,7 @@
>  #include <linux/hrtimer.h>
>  #include <linux/average.h>
>  #include <linux/usb.h>
> +#include <linux/clk.h>
>  
>  #include <net/mac80211.h>
>  
> @@ -1011,6 +1012,9 @@ struct rt2x00_dev {
>  	unsigned int extra_tx_headroom;
>  
>  	struct usb_anchor *anchor;
> +
> +	/* Clock for System On Chip devices. */
> +	struct clk *clk;
>  };
>  
>  struct rt2x00_bar_list_entry {
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
> index 69a0cda..362f9d3 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
> @@ -92,6 +92,7 @@ int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops)
>  	rt2x00dev->hw = hw;
>  	rt2x00dev->irq = platform_get_irq(pdev, 0);
>  	rt2x00dev->name = pdev->dev.driver->name;
> +	rt2x00dev->clk = clk_get(&pdev->dev);
This looks broken, clk_get takes two parameters, not just one.

- Felix
