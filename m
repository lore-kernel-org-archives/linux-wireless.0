Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab3JYBUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 21:20:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>,
	opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [OPW kernel] [Patch v2 2/3] net: wireless: replace printk with netdev_warn in adm8211.c
In-Reply-To: <20131024221712.GA4175@fireworks>
References: <20131024221712.GA4175@fireworks>
Date: Fri, 25 Oct 2013 11:48:06 +1030
Message-ID: <87hac687xt.fsf@rustcorp.com.au> (sfid-20131025_032024_499000_B3A47A95)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Georgiana Rodica Chelu <georgiana.chelu93@gmail.com> writes:
> WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
> to printk(KERN_WARNING ...
>
> Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>

I don't think this will compile.

Please test your patches,
Rusty.

> ---
>  drivers/net/wireless/adm8211.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
> index 0d0dcba..1910ea7 100644
> --- a/drivers/net/wireless/adm8211.c
> +++ b/drivers/net/wireless/adm8211.c
> @@ -170,13 +170,14 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
>  		else
>  			priv->bbp_type = ADM8211_TYPE_ADMTEK;
>  
> -		printk(KERN_WARNING "%s (adm8211): Unknown BBPtype: %d\n",
> -		       pci_name(priv->pdev), cr49 >> 3);
> +		netdev_warn(priv->pdev, "(adm8211): Unknown BBPtype: %d\n",
> +			    pci_name(priv->pdev), cr49 >> 3);
>  	}
>  
>  	if (priv->eeprom->country_code >= ARRAY_SIZE(cranges)) {
> -		printk(KERN_WARNING "%s (adm8211): Invalid country code (%d)\n",
> -		       pci_name(priv->pdev), priv->eeprom->country_code);
> +		netdev_warn(priv->eeprom, "(adm8211): Invalid country code ",
> +			    "(%d)\n", pci_name(priv->pdev),
> +			    priv->eeprom->country_code);
>  
>  		chan_range = cranges[2];
>  	} else
> @@ -210,8 +211,9 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
>  		else
>  			priv->specific_bbptype = ADM8211_BBP_ADM8011;
>  
> -		printk(KERN_WARNING "%s (adm8211): Unknown specific BBP: %d\n",
> -		       pci_name(priv->pdev), priv->eeprom->specific_bbptype);
> +		netdev_warn(priv->pdev, "(adm8211): Unknown specific BBP: %d",
> +			    "\n", pci_name(priv->pdev),
> +			    priv->eeprom->specific_bbptype);
>  	}
>  
>  	switch (priv->eeprom->specific_rftype) {
> @@ -231,8 +233,9 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
>  		else if (priv->pdev->revision == ADM8211_REV_AB)
>  			priv->transceiver_type = ADM8211_RFMD2948;
>  
> -		printk(KERN_WARNING "%s (adm8211): Unknown transceiver: %d\n",
> -		       pci_name(priv->pdev), priv->eeprom->specific_rftype);
> +		netdev_warn(priv->pdev, "(adm8211): Unknown transceiver: %d\n",
> +			    pci_name(priv->pdev),
> +			    priv->eeprom->specific_rftype);
>  
>  		break;
>  	}
> -- 
> 1.8.1.2
>
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
