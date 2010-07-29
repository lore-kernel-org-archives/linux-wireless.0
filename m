Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36107 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0G2SPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 14:15:48 -0400
Date: Thu, 29 Jul 2010 14:04:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kirill Zut <kirill.zut@promwad.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH 2.6.34] rtl8187: ad-hoc mode support
Message-ID: <20100729180426.GC2424@tuxdriver.com>
References: <201007291835.46159.kirill.zut@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201007291835.46159.kirill.zut@promwad.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't you need something to make it beacon?

On Thu, Jul 29, 2010 at 06:35:45PM +0300, Kirill Zut wrote:
> ---
> This patch makes ad-hoc mode available on RTL8187
> 
> Signed-off-by: Kirill Zut <kirill.zut@promwad.com>
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

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
