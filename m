Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3J1VaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 17:30:17 -0400
Date: Mon, 28 Oct 2013 14:30:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
Cc: opw-kernel@googlegroups.com, linux-wireless@vger.kernel.org
Subject: Re: [OPW kernel] [Patch v3 1/3] net: wireless: replace printk with
 pr_warn in adm8211.c
Message-ID: <20131028213015.GA31597@kroah.com> (sfid-20131028_223021_992450_72EE2742)
References: <20131026192053.GA10494@fireworks>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131026192053.GA10494@fireworks>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 26, 2013 at 10:20:53PM +0300, Georgiana Rodica Chelu wrote:
> WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
> to printk(KERN_WARNING ...
> 
> Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
> ---
>  drivers/net/wireless/adm8211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Like Sarah said, we can't take these as they are not against the staging
tree.

And even if they were:

> diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
> index f9a24e5..e36d54d 100644
> --- a/drivers/net/wireless/adm8211.c
> +++ b/drivers/net/wireless/adm8211.c
> @@ -151,7 +151,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
>  		else
>  			priv->rf_type = ADM8211_TYPE_AIROHA;
>  
> -		printk(KERN_WARNING "%s (adm8211): Unknown RFtype %d\n",
> +		pr_warn("%s (adm8211): Unknown RFtype %d\n",

You didn't read the message that sparse was telling you, why didn't you
convert this to netdev_warn() instead?

thanks,

greg k-h
