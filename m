Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbYDQSTy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 14:19:54 -0400
Subject: Re: [PATCH] libertas: Fix ethtool statistics
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <1208448814.9212.270.camel@pmac.infradead.org>
References: <1208448814.9212.270.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 14:02:43 -0400
Message-Id: <1208455363.20193.3.camel@localhost.localdomain> (sfid-20080417_192000_223345_5C85B3F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-04-17 at 17:13 +0100, David Woodhouse wrote:
> We removed CMD_MESH_ACCESS from the big case statements and provided
> lbs_mesh_access() instead.... but we missed one user. Fix it.
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index 21e6f98..9460300 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -106,8 +106,8 @@ done:
>          return ret;
>  }
>  
> -static void lbs_ethtool_get_stats(struct net_device * dev,
> -				struct ethtool_stats * stats, u64 * data)
> +static void lbs_ethtool_get_stats(struct net_device *dev,
> +				  struct ethtool_stats *stats, u64 *data)
>  {
>  	struct lbs_private *priv = dev->priv;
>  	struct cmd_ds_mesh_access mesh_access;
> @@ -116,9 +116,7 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
>  	lbs_deb_enter(LBS_DEB_ETHTOOL);
>  
>  	/* Get Mesh Statistics */
> -	ret = lbs_prepare_and_send_command(priv,
> -			CMD_MESH_ACCESS, CMD_ACT_MESH_GET_STATS,
> -			CMD_OPTION_WAITFORRSP, 0, &mesh_access);
> +	ret = lbs_mesh_access(priv, CMD_ACT_MESH_GET_STATS, &mesh_access);
>  
>  	if (ret)
>  		return;
> 

