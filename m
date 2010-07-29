Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp130.mail.ukl.yahoo.com ([77.238.184.61]:39765 "HELO
	smtp130.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754848Ab0G2RIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 13:08:18 -0400
Message-ID: <4C51B3EE.8000205@users.sourceforge.net>
Date: Thu, 29 Jul 2010 18:01:34 +0100
From: Hin-Tak Leung <htl10@users.sourceforge.net>
MIME-Version: 1.0
To: Kirill Zut <kirill.zut@promwad.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH 2.6.34] rtl8187: ad-hoc mode support
References: <201007291835.46159.kirill.zut@promwad.com>
In-Reply-To: <201007291835.46159.kirill.zut@promwad.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kirill Zut wrote:
> ---
> This patch makes ad-hoc mode available on RTL8187
> 
> Signed-off-by: Kirill Zut <kirill.zut@promwad.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

looks alright, but I remember some discussion about generic ad hoc support from 
the mac80211 is needed for all mac80211-based drivers to work. What's the status 
of that and how's it comming along?

Hin-Tak

> ---
> --- linux-2.6.x/drivers/net/wireless/rtl818x/rtl8187_dev.c.orig	2010-07-29 14:40:09.000000000 +0300
> +++ linux-2.6.x/drivers/net/wireless/rtl818x/rtl8187_dev.c	2010-07-29 14:59:39.000000000 +0300
> @@ -1032,6 +1032,7 @@ static int rtl8187_add_interface(struct 
>  
>  	switch (vif->type) {
>  	case NL80211_IFTYPE_STATION:
> +	case NL80211_IFTYPE_ADHOC:
>  		break;
>  	default:
>  		goto exit;
> @@ -1178,7 +1179,10 @@ static void rtl8187_bss_info_changed(str
>  			reg = 0;
>  
>  		if (is_valid_ether_addr(info->bssid)) {
> -			reg |= RTL818X_MSR_INFRA;
> +			if (vif->type == NL80211_IFTYPE_ADHOC)
> +				reg |= RTL818X_MSR_ADHOC;
> +			else
> +				reg |= RTL818X_MSR_INFRA;
>  			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
>  		} else {
>  			reg |= RTL818X_MSR_NO_LINK;
> @@ -1502,7 +1506,8 @@ static int __devinit rtl8187_probe(struc
>  	 * XXX: Once this driver supports anything that requires
>  	 *	beacons it must implement IEEE80211_TX_CTL_ASSIGN_SEQ.
>  	 */
> -	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> +	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
> +				      BIT(NL80211_IFTYPE_ADHOC);
>  
>  	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
>  		printk(KERN_INFO "rtl8187: inconsistency between id with OEM"
> 
