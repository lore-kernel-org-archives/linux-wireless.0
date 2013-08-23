Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34792 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3HWPAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 11:00:21 -0400
Date: Fri, 23 Aug 2013 10:53:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 06/10] net: airo: inherit addr_assign_type along
 with dev_addr
Message-ID: <20130823145306.GC15114@tuxdriver.com> (sfid-20130823_170029_632534_05A50A37)
References: <1377250513-3662-1-git-send-email-bjorn@mork.no>
 <1377250513-3662-7-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1377250513-3662-7-git-send-email-bjorn@mork.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 23, 2013 at 11:35:09AM +0200, Bjørn Mork wrote:
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/net/wireless/airo.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index d0adbaf..7fe1964 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -2693,7 +2693,7 @@ static struct net_device *init_wifidev(struct airo_info *ai,
>  	dev->base_addr = ethdev->base_addr;
>  	dev->wireless_data = ethdev->wireless_data;
>  	SET_NETDEV_DEV(dev, ethdev->dev.parent);
> -	memcpy(dev->dev_addr, ethdev->dev_addr, dev->addr_len);
> +	eth_hw_addr_inherit(dev, ethdev);
>  	err = register_netdev(dev);
>  	if (err<0) {
>  		free_netdev(dev);
> -- 
> 1.7.10.4

Acked-by: "John W. Linville" <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
