Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2942 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbXKATur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 15:50:47 -0400
Date: Thu, 1 Nov 2007 15:49:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Message-ID: <20071101194909.GF14943@tuxdriver.com> (sfid-20071101_195051_292028_CB68C155)
References: <20071101191716.GA3201@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101191716.GA3201@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 01, 2007 at 03:17:16PM -0400, Luis R. Rodriguez wrote:

> So I started reviewing the probes on each driver and came up with this
> patch because Documenation/pci.txt has:
> 
> "The device driver needs to call pci_request_region() to verify
> no other device is already using the same address resource.
> Conversely, drivers should call pci_release_region() AFTER
> calling pci_disable_device(). The idea is to prevent two devices 
> colliding on the same address range"

No idea off the top of my head if this relates to the problem or not...

> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -602,10 +602,10 @@ err_free:
>  	ieee80211_free_hw(hw);
>  err_map:
>  	pci_iounmap(pdev, mem);
> -err_reg:
> -	pci_release_region(pdev, 0);
>  err_dis:
>  	pci_disable_device(pdev);
> +err_reg:
> +	pci_release_region(pdev, 0);
>  err:
>  	return ret;
>  }

If you do this, don't you need to change any "goto err_reg" to "goto
err_dis" as well?

> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -11756,10 +11756,10 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	priv->workqueue = NULL;
>        out_iounmap:
>  	iounmap(priv->hw_base);
> -      out_pci_release_regions:
> -	pci_release_regions(pdev);
>        out_pci_disable_device:
>  	pci_disable_device(pdev);
> +      out_pci_release_regions:
> +	pci_release_regions(pdev);
>  	pci_set_drvdata(pdev, NULL);
>        out_free_ieee80211:
>  	free_ieee80211(priv->net_dev);

Same as last comment, but for out_pci_release_regions and
out_pci_disable_device.

John
-- 
John W. Linville
linville@tuxdriver.com
