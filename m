Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:49593 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755129Ab3JXWqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 18:46:36 -0400
Message-ID: <1382654793.22433.91.camel@joe-AO722> (sfid-20131025_004639_608604_D0117567)
Subject: Re: [Patch v2 1/3] net: wireless: replace printk with netdev_warn
 in adm8211.c
From: Joe Perches <joe@perches.com>
To: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
Cc: opw-kernel@googlegroups.com, linux-wireless@vger.kernel.org
Date: Thu, 24 Oct 2013 15:46:33 -0700
In-Reply-To: <20131024213026.GA3569@fireworks>
References: <20131024213026.GA3569@fireworks>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-25 at 00:30 +0300, Georgiana Rodica Chelu wrote:
> WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
> to printk(KERN_WARNING ...

Hi Georgiana.

Please compile and test your patches before submitting them.

> diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c

> @@ -151,8 +151,9 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
>  		else
>  			priv->rf_type = ADM8211_TYPE_AIROHA;
>  
> -		printk(KERN_WARNING "%s (adm8211): Unknown RFtype %d\n",
> -		       pci_name(priv->pdev), (cr49 >> 3) & 0x7);
> +		netdev_warn(priv->pdev, "(adm8211): Unknown RFtype %d\n",
> +			    pci_name(priv->pdev), (cr49 >> 3) & 0x7);
> +
>  	}
>  
>  	priv->bbp_type = cr49 & 0x7;

netdev_warn 1st arg is a struct net_device *
priv->pdev is a struct pci_dev *


