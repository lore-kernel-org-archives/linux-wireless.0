Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:38456 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYG3SVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 14:21:05 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: Fix lockups due to concurrent access to config routine
Date: Wed, 30 Jul 2008 15:21:11 -0300
Cc: John Linville <linville@tuxdriver.com>,
	"Hin-Tak Leung" <hintak_leung@yahoo.co.uk>,
	wireless <linux-wireless@vger.kernel.org>
References: <489091C6.9070805@lwfinger.net>
In-Reply-To: <489091C6.9070805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301521.12233.herton@mandriva.com.br> (sfid-20080730_202109_775297_36A593A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 30 July 2008 13:07:34 Larry Finger escreveu:
> Some users of the RTL8187B have experienced difficulties since commit
> 8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
> management wext hooks. This difficulty has not made much sense until
> it was realized that it was possible for mac80211 to make a call to the
> config routine while that routine was already being executed. This patch
> protects the critical section with a mutex.
> 
> The problem was found by Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
> who also suggested this type of fix.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---

Hi,

the patch has some extra/missing spaces that makes it not apply, but fixing
manually it applies here. I thought at first it was not up-todate wireless
testing here.

> 
> John,
> 
> This is 2.6.27 material as it fixes a bug.
> 
> Larry
> ---
> 
> 
> Index: wireless-testing/drivers/net/wireless/rtl8187.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl8187.h
> +++ wireless-testing/drivers/net/wireless/rtl8187.h
> @@ -94,6 +94,10 @@ struct rtl8187_priv {
>   	const struct rtl818x_rf_ops *rf;
>   	struct ieee80211_vif *vif;
>   	int mode;
> +	/* The mutex protects the TX loopback state.
> +	 * Any attempt to set channels concurrently locks the device.
> +	 */
> +	struct mutex conf_mutex;
> 
>   	/* rtl8187 specific */
>   	struct ieee80211_channel channels[14];
> Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
> @@ -864,6 +864,7 @@ static int rtl8187_config(struct ieee802
>   	struct rtl8187_priv *priv = dev->priv;
>   	u32 reg;
> 
> +	mutex_lock(&priv->conf_mutex);
>   	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
>   	/* Enable TX loopback on MAC level to avoid TX during channel
>   	 * changes, as this has be seen to causes problems and the
> @@ -896,6 +897,7 @@ static int rtl8187_config(struct ieee802
>   	rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
>   	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
>   	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL_TIME, 100);
> +	mutex_unlock(&priv->conf_mutex);
>   	return 0;
>   }
> 
> @@ -1187,6 +1189,7 @@ static int __devinit rtl8187_probe(struc
>   		printk(KERN_ERR "rtl8187: Cannot register device\n");
>   		goto err_free_dev;
>   	}
> +	mutex_init(&priv->conf_mutex);
> 
>   	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
>   	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
> 

--
[]'s
Herton
