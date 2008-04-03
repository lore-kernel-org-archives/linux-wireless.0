Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759832AbYDCDfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 23:35:34 -0400
Subject: Re: [PATCH] libertas: remove lbs_get_fwversion()
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804021804.35559.hs4233@mail.mn-solutions.de>
References: <200804021804.35559.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 23:33:41 -0400
Message-Id: <1207193621.9435.10.camel@localhost.localdomain> (sfid-20080403_043536_440056_9FB504AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-02 at 18:04 +0200, Holger Schurig wrote:
> It was used only at one place anyway.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/ethtool.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/ethtool.c	2008-04-02 15:56:13.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/ethtool.c	2008-04-02 16:00:35.000000000 +0200
> @@ -24,13 +24,14 @@ static void lbs_ethtool_get_drvinfo(stru
>  					 struct ethtool_drvinfo *info)
>  {
>  	struct lbs_private *priv = (struct lbs_private *) dev->priv;
> -	char fwver[32];
> -
> -	lbs_get_fwversion(priv, fwver, sizeof(fwver) - 1);
>  
> +	snprintf(info->fw_version, 32, "%u.%u.%u.p%u",
> +		priv->fwrelease >> 24 & 0xff,
> +		priv->fwrelease >> 16 & 0xff,
> +		priv->fwrelease >>  8 & 0xff,
> +		priv->fwrelease       & 0xff);
>  	strcpy(info->driver, "libertas");
>  	strcpy(info->version, lbs_driver_version);
> -	strcpy(info->fw_version, fwver);
>  }
>  
>  /* All 8388 parts have 16KiB EEPROM size at the time of writing.
> Index: wireless-testing/drivers/net/wireless/libertas/decl.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-04-02 15:59:57.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-04-02 16:00:01.000000000 +0200
> @@ -37,9 +37,6 @@ void lbs_notify_command_response(struct 
>  int lbs_set_radio_control(struct lbs_private *priv);
>  u32 lbs_fw_index_to_data_rate(u8 index);
>  u8 lbs_data_rate_to_fw_index(u32 rate);
> -void lbs_get_fwversion(struct lbs_private *priv,
> -	char *fwversion,
> -	int maxlen);
>  
>  /** The proc fs interface */
>  int lbs_process_command_response(struct lbs_private *priv, u8 *data, u32 len);
> Index: wireless-testing/drivers/net/wireless/libertas/wext.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-04-02 15:56:20.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-04-02 16:00:25.000000000 +0200
> @@ -2060,23 +2060,6 @@ static int lbs_set_wap(struct net_device
>  	return ret;
>  }
>  
> -void lbs_get_fwversion(struct lbs_private *priv, char *fwversion, int maxlen)
> -{
> -	char fwver[32];
> -
> -	mutex_lock(&priv->lock);
> -
> -	sprintf(fwver, "%u.%u.%u.p%u",
> -		priv->fwrelease >> 24 & 0xff,
> -		priv->fwrelease >> 16 & 0xff,
> -		priv->fwrelease >>  8 & 0xff,
> -		priv->fwrelease       & 0xff);
> -
> -	mutex_unlock(&priv->lock);
> -	snprintf(fwversion, maxlen, fwver);
> -}
> -
> -
>  /*
>   * iwconfig settable callbacks
>   */

