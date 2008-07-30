Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41830 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbYG3RbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 13:31:23 -0400
Message-ID: <4890A564.3030309@lwfinger.net> (sfid-20080730_193148_385881_9582869E)
Date: Wed, 30 Jul 2008 12:31:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Michael Buesch <mb@bu3sch.de>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211
 with a mutex
References: <48900654.7030100@lwfinger.net> <200807301308.01631.herton@mandriva.com.br> <200807301816.37570.mb@bu3sch.de> <200807301413.53059.herton@mandriva.com.br>
In-Reply-To: <200807301413.53059.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> 
> Ah ok, only protect the section, like this?
> 
> diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
> index 3afb49f..a4e42dc 100644
> --- a/drivers/net/wireless/rtl8187.h
> +++ b/drivers/net/wireless/rtl8187.h
> @@ -92,6 +92,10 @@ struct rtl8187_priv {
>  	const struct rtl818x_rf_ops *rf;
>  	struct ieee80211_vif *vif;
>  	int mode;
> +	/* The mutex protects the TX loopback state.
> +	 * Avoid concurrent channel changes with loopback enabled.
> +	 */
> +	struct mutex loopback_mutex;
>  
>  	/* rtl8187 specific */
>  	struct ieee80211_channel channels[14];
> diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
> index d3067b1..cfa048b 100644
> --- a/drivers/net/wireless/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl8187_dev.c
> @@ -835,6 +835,7 @@ static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
>  	struct rtl8187_priv *priv = dev->priv;
>  	u32 reg;
>  
> +	mutex_lock(&priv->loopback_mutex);
>  	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
>  	/* Enable TX loopback on MAC level to avoid TX during channel
>  	 * changes, as this has be seen to causes problems and the
> @@ -846,6 +847,7 @@ static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
>  	priv->rf->set_chan(dev, conf);
>  	msleep(10);
>  	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
> +	mutex_unlock(&priv->loopback_mutex);
>  
>  	if (!priv->is_rtl8187b) {
>  		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
> @@ -1154,6 +1156,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
>  		printk(KERN_ERR "rtl8187: Cannot register device\n");
>  		goto err_free_dev;
>  	}
> +	mutex_init(&priv->loopback_mutex);
>  
>  	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
>  	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
> 
> 

This scheme would probably work; however, I still think we should protect all 
the configuration data. That way we won't have the case where some of the data 
come from one call and the rest from a different one. In any event, most of the 
time that we are locked comes from the 2 msleeps that have to be within the lock 
anyway.

Larry
