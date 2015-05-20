Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:42462 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbbETO5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 10:57:48 -0400
Date: Wed, 20 May 2015 16:57:44 +0200
From: Henrik Eriksson <henrik.eriksson@axis.com>
To: "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: clear sdiodev->pdata if irq_of_parse_and_map
 fails
Message-ID: <20150520145744.GA26417@linux.se.axis.com> (sfid-20150520_165810_496039_A421CFCC)
References: <20150520140206.GA11272@linux.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20150520140206.GA11272@linux.se.axis.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please ignore this.  [PATCH 1/6] brcmfmac: allow device tree node
without 'interrupts' property posted earlier today deals with the same
thing, in a better way.

On Wed, May 20, 2015 at 16:02:15 +0200, Henrik Eriksson wrote:
> Clear the pdata pointer in sdiodev after freeing the memory.  In my case
> not doing so interferes with device initialization as request_irq of
> sdiodev->pdata->oob_irq_nr fails, but even if not, leaving a wild
> pointer is incorrect.
> 
> Signed-off-by: Henrik Eriksson <henriken@axis.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/of.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
> index c824570..71ead7b 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
> @@ -43,6 +43,7 @@ void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
>  	if (!irq) {
>  		brcmf_err("interrupt could not be mapped\n");
>  		devm_kfree(dev, sdiodev->pdata);
> +		sdiodev->pdata = NULL;
>  		return;
>  	}
>  	irqf = irqd_get_trigger_type(irq_get_irq_data(irq));
-- 
henrik eriksson
