Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2778 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2JaBVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 21:21:22 -0400
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 30 Oct 2012 18:23:37 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
Message-ID: <20121031012225.GY3354@lenteja.do-not-panic.com> (sfid-20121031_022149_289845_0F35031E)
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1351511906-19989-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1351511906-19989-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 29, 2012 at 01:58:25PM +0200, Vladimir Kondratiev wrote:
> Card wil6210 by Wilocity supports operation on the 60GHz band
> 
> See
> http://wireless.kernel.org/en/users/Drivers/wil6210

Can you update that page to reflect the latest information?
Its out of date now.

> diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> new file mode 100644
> index 0000000..d2b14fb
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> +static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	{ /* print various info */
> +		struct net_device *ndev = wil_to_ndev(wil);
> +		const char *pdev_name = pci_name(pdev);
> +		const char *wiphydev_name = dev_name(wil_to_dev(wil));
> +		const char *ndev_name = netdev_name(ndev);
> +		const char *ifc_name = ndev->name;
> +		struct pci_driver *drv = pci_dev_driver(pdev);
> +		const char *drv_name = drv ? drv->name : "(no drv)";
> +		pr_info("Driver  : <%s>\n", drv_name ?: "(null)");
> +		pr_info("PCI dev : <%s>\n", pdev_name ?: "(null)");
> +		pr_info("Net dev : <%s>\n", ndev_name ?: "(null)");
> +		pr_info("Net ifc : <%s>\n", ifc_name ?: "(null)");
> +		pr_info("Wiphy   : <%s>\n", wiphydev_name ?: "(null)");
> +
> +	}

Die nasty code, die! Bleed!

> diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
> new file mode 100644
> index 0000000..463c68e
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wil6210/txrx.c
> +void tx_complete(struct wil6210_priv *wil, int ringid)
> +{

...

> +	{
> +		u32 swhead = vring->swhead;
> +		u32 swtail = vring->swtail;
> +		int used = (vring->size + swhead - swtail) % vring->size;
> +		int avail = vring->size - used - 1;
> +		if (avail > vring->size/4)
> +			netif_tx_wake_all_queues(wil_to_ndev(wil));
> +	}
> +}

Die!

> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
> new file mode 100644
> index 0000000..529b790
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
> @@ -0,0 +1,299 @@

...

> +#define WIL6210_DRV_VERSION "0.4" /* Driver version */

Again, death to this. I don't care what other drivers do, this
is silly practice.

You also still use generic routine names, please clean those
up. Few examples: tx_complete() rx_handle(), iftype_nl2wmi(),
and I'm sure there are plenty others, please prefix
these for the driver.


> diff --git a/drivers/net/wireless/ath/wil6210/wil6210_rgf.h b/drivers/net/wireless/ath/wil6210/wil6210_rgf.h

Any reason why this small file is required? Why not just stuff it into
one of the other header files?

You didn't also address my comments regarding WIL6210_ISR_COR #ifdef code.

The second patch no longer applies as a new driver was merged.

Apart from all this, looks good.

  Luis
