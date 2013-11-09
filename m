Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:41604 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab3KICUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 21:20:51 -0500
Received: by mail-qe0-f50.google.com with SMTP id 1so2767090qee.9
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 18:20:50 -0800 (PST)
Message-ID: <527D9C01.5070306@lwfinger.net> (sfid-20131109_032055_264314_19B80DE2)
Date: Fri, 08 Nov 2013 20:20:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>, Frans Leerink <f.leerink@xs4all.nl>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] prism54: set netdev type to "wlan"
References: <2774683.Pvb2zYysB7@md8338-opensuse-12-3.site> <1383939584.29096.10.camel@dcbw.foobar.com>
In-Reply-To: <1383939584.29096.10.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2013 01:39 PM, Dan Williams wrote:
> Userspace uses the netdev devtype for stuff like device naming and type
> detection.  Be nice and set it.  Remove the pointless #if/#endif around
> SET_NETDEV_DEV too.
>
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Should this be sent to Stable?

Larry

> ---
> diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
> index 5970ff6..d498b02 100644
> --- a/drivers/net/wireless/prism54/islpci_dev.c
> +++ b/drivers/net/wireless/prism54/islpci_dev.c
> @@ -807,27 +807,30 @@ static const struct net_device_ops islpci_netdev_ops = {
>   	.ndo_start_xmit		= islpci_eth_transmit,
>   	.ndo_tx_timeout		= islpci_eth_tx_timeout,
>   	.ndo_set_mac_address 	= prism54_set_mac_address,
>   	.ndo_change_mtu		= eth_change_mtu,
>   	.ndo_validate_addr	= eth_validate_addr,
>   };
>
> +static struct device_type wlan_type = {
> +	.name	= "wlan",
> +};
> +
>   struct net_device *
>   islpci_setup(struct pci_dev *pdev)
>   {
>   	islpci_private *priv;
>   	struct net_device *ndev = alloc_etherdev(sizeof (islpci_private));
>
>   	if (!ndev)
>   		return ndev;
>
>   	pci_set_drvdata(pdev, ndev);
> -#if defined(SET_NETDEV_DEV)
>   	SET_NETDEV_DEV(ndev, &pdev->dev);
> -#endif
> +	SET_NETDEV_DEVTYPE(ndev, &wlan_type);
>
>   	/* setup the structure members */
>   	ndev->base_addr = pci_resource_start(pdev, 0);
>   	ndev->irq = pdev->irq;
>
>   	/* initialize the function pointers */
>   	ndev->netdev_ops = &islpci_netdev_ops;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

