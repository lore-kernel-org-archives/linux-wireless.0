Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbYKCCG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 21:06:28 -0500
Message-ID: <490E5CA4.4010707@cn.fujitsu.com> (sfid-20081103_030648_466211_32CD80F7)
Date: Mon, 03 Nov 2008 10:06:28 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	NETDEV <netdev@vger.kernel.org>
Subject: Re: [PATCH] netdevice zd1201: Convert directly reference of netdev->priv
 to netdev_priv()
References: <20081031182207.GD4310@tuxdriver.com> <1225478896-28987-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1225478896-28987-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville said the following on 2008-11-1 2:48:
> We have some reasons to kill netdev->priv:
> 1. netdev->priv is equal to netdev_priv().
> 2. netdev_priv() wraps the calculation of netdev->priv's offset, obviously
>    netdev_priv() is more flexible than netdev->priv.
> But we cann't kill netdev->priv, because so many drivers reference to it
> directly.
> 
> OK, becasue Dave S. Miller said, "every direct netdev->priv usage is a bug",
> and I want to kill netdev->priv later, I decided to convert all the direct
> reference of netdev->priv first.
> 
> (Original patch posted by Wang Chen <wangchen@cn.fujitsu.com> w/ above
> changelog but using dev->ml_priv.  That doesn't seem appropriate
> to me for this driver, so I've revamped it to use netdev_priv()
> instead. -- JWL)
> 
> Cc: Wang Chen <wangchen@cn.fujitsu.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/zd1201.c |  115 ++++++++++++++++++++---------------------
>  1 files changed, 56 insertions(+), 59 deletions(-)
> 
snip...
> @@ -1731,6 +1731,7 @@ static int zd1201_probe(struct usb_interface *interface,
>  			const struct usb_device_id *id)
>  {
>  	struct zd1201 *zd;
> +	struct net_device *dev;
>  	struct usb_device *usb;
>  	int err;
>  	short porttype;
> @@ -1738,9 +1739,12 @@ static int zd1201_probe(struct usb_interface *interface,
>  
>  	usb = interface_to_usbdev(interface);
>  
> -	zd = kzalloc(sizeof(struct zd1201), GFP_KERNEL);
> -	if (!zd)
> +	dev = alloc_etherdev(sizeof(*zd));
> +	if (!dev)
>  		return -ENOMEM;
> +	zd = netdev_priv(dev);
> +	zd->dev = dev;
> +

It's ok to me.

Reviewed-by: Wang Chen <wangchen@cn.fujitsu.com>

