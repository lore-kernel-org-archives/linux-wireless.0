Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34796 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3HWPA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 11:00:26 -0400
Date: Fri, 23 Aug 2013 10:52:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 08/10] net: libertas: inherit addr_assign_type
 along with dev_addr
Message-ID: <20130823145255.GB15114@tuxdriver.com> (sfid-20130823_170034_509464_B2EE3ADA)
References: <1377250513-3662-1-git-send-email-bjorn@mork.no>
 <1377250513-3662-9-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1377250513-3662-9-git-send-email-bjorn@mork.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 23, 2013 at 11:35:11AM +0200, Bjørn Mork wrote:
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>  drivers/net/wireless/libertas/mesh.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
> index efae07e..6fef746 100644
> --- a/drivers/net/wireless/libertas/mesh.c
> +++ b/drivers/net/wireless/libertas/mesh.c
> @@ -1017,7 +1017,7 @@ static int lbs_add_mesh(struct lbs_private *priv)
>  
>  	mesh_dev->netdev_ops = &mesh_netdev_ops;
>  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
> -	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
> +	eth_hw_addr_inherit(mesh_dev, priv->dev);
>  
>  	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
>  
> -- 
> 1.7.10.4
> 
> 
Acked-by: "John W. Linville" <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
