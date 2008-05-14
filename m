Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYENPax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 11:30:53 -0400
Subject: Re: [PATCH] wireless: Create 'device' symlink in sysfs
From: Dan Williams <dcbw@redhat.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <20080514124516.A06B.40F06B3A@sm.sony.co.jp>
References: <20080514124516.A06B.40F06B3A@sm.sony.co.jp>
Content-Type: text/plain
Date: Wed, 14 May 2008 11:26:33 -0400
Message-Id: <1210778793.28532.0.camel@localhost.localdomain> (sfid-20080514_173059_779067_648F434C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 14:16 +0900, Masakazu Mokuno wrote:
> Some network interfaces of the wireless drivers lack the 'device'
> symlink in sysfs.
> This patch lets the drivers create the links.
> 
> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

Libertas parts:

Acked-by: Dan Williams <dcbw@redhat.com>

but in general, this is a Good Thing, since it would allow HAL to match
the device up with it's parent.

> ---
>  drivers/net/wireless/airo.c          |    1 +
>  drivers/net/wireless/ipw2200.c       |    1 +
>  drivers/net/wireless/libertas/main.c |    1 +
>  3 files changed, 3 insertions(+)
> 
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -2668,6 +2668,7 @@ static struct net_device *init_wifidev(s
>  	dev->irq = ethdev->irq;
>  	dev->base_addr = ethdev->base_addr;
>  	dev->wireless_data = ethdev->wireless_data;
> +	SET_NETDEV_DEV(dev, ethdev->dev.parent);
>  	memcpy(dev->dev_addr, ethdev->dev_addr, dev->addr_len);
>  	err = register_netdev(dev);
>  	if (err<0) {
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -11584,6 +11584,7 @@ static int ipw_prom_alloc(struct ipw_pri
>  	priv->prom_net_dev->hard_start_xmit = ipw_prom_hard_start_xmit;
>  
>  	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
> +	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
>  
>  	rc = register_netdev(priv->prom_net_dev);
>  	if (rc) {
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -1566,6 +1566,7 @@ static int lbs_add_rtap(struct lbs_priva
>  	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
>  	rtap_dev->set_multicast_list = lbs_set_multicast_list;
>  	rtap_dev->priv = priv;
> +	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
>  
>  	ret = register_netdev(rtap_dev);
>  	if (ret) {
> 

