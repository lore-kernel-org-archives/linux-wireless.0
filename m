Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab1JNPAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:00:49 -0400
Subject: Re: [PATCH] libertas: fix changing interface type when interface is
 down
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Fri, 14 Oct 2011 10:00:35 -0500
In-Reply-To: <20111014110526.74BCC9D401E@zog.reactivated.net>
References: <20111014110526.74BCC9D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1318604437.2196.3.camel@dcbw.foobar.com> (sfid-20111014_170052_875797_AFEC9852)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-14 at 12:05 +0100, Daniel Drake wrote:
> The recent changes to only power the device when the interface up
> introduced a bug: changing interface type, legal when the interface
> is down, performs device I/O.
> 
> Fix this functionality by validating and recording the interface
> type when the change is requested, but only applying the change
> if/when the interface is brought up.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c  |   20 ++++++--------------
>  drivers/net/wireless/libertas/decl.h |    2 ++
>  drivers/net/wireless/libertas/main.c |   32 ++++++++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 610bfce..ff63782 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -1666,28 +1666,20 @@ static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
>  	if (dev == priv->mesh_dev)
>  		return -EOPNOTSUPP;
>  
> -	lbs_deb_enter(LBS_DEB_CFG80211);
> -
>  	switch (type) {
>  	case NL80211_IFTYPE_MONITOR:
> -		ret = lbs_set_monitor_mode(priv, 1);
> -		break;
>  	case NL80211_IFTYPE_STATION:
> -		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
> -			ret = lbs_set_monitor_mode(priv, 0);
> -		if (!ret)
> -			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 1);
> -		break;
>  	case NL80211_IFTYPE_ADHOC:
> -		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
> -			ret = lbs_set_monitor_mode(priv, 0);
> -		if (!ret)
> -			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 2);
>  		break;
>  	default:
> -		ret = -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  	}
>  
> +	lbs_deb_enter(LBS_DEB_CFG80211);
> +
> +	if (priv->iface_running)
> +		ret = lbs_set_iface_type(priv, type);
> +
>  	if (!ret)
>  		priv->wdev->iftype = type;
>  
> diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
> index 9304e6f..bc951ab 100644
> --- a/drivers/net/wireless/libertas/decl.h
> +++ b/drivers/net/wireless/libertas/decl.h
> @@ -9,6 +9,7 @@
>  
>  #include <linux/netdevice.h>
>  #include <linux/firmware.h>
> +#include <linux/nl80211.h>
>  
>  /* Should be terminated by a NULL entry */
>  struct lbs_fw_table {
> @@ -45,6 +46,7 @@ void lbs_host_to_card_done(struct lbs_private *priv);
>  
>  int lbs_start_iface(struct lbs_private *priv);
>  int lbs_stop_iface(struct lbs_private *priv);
> +int lbs_set_iface_type(struct lbs_private *priv, enum nl80211_iftype type);
>  
>  int lbs_rtap_supported(struct lbs_private *priv);
>  
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 6a32623..f78afd7 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -99,6 +99,32 @@ u8 lbs_data_rate_to_fw_index(u32 rate)
>  	return 0;
>  }
>  
> +int lbs_set_iface_type(struct lbs_private *priv, enum nl80211_iftype type)
> +{
> +	int ret = 0;
> +
> +	switch (type) {
> +	case NL80211_IFTYPE_MONITOR:
> +		ret = lbs_set_monitor_mode(priv, 1);
> +		break;
> +	case NL80211_IFTYPE_STATION:
> +		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
> +			ret = lbs_set_monitor_mode(priv, 0);
> +		if (!ret)
> +			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 1);
> +		break;
> +	case NL80211_IFTYPE_ADHOC:
> +		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
> +			ret = lbs_set_monitor_mode(priv, 0);
> +		if (!ret)
> +			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 2);
> +		break;
> +	default:
> +		ret = -ENOTSUPP;
> +	}
> +	return ret;
> +}
> +
>  int lbs_start_iface(struct lbs_private *priv)
>  {
>  	struct cmd_ds_802_11_mac_address cmd;
> @@ -120,6 +146,12 @@ int lbs_start_iface(struct lbs_private *priv)
>  		goto err;
>  	}
>  
> +	ret = lbs_set_iface_type(priv, priv->wdev->iftype);
> +	if (ret) {
> +		lbs_deb_net("set iface type failed\n");
> +		goto err;
> +	}
> +
>  	lbs_update_channel(priv);
>  
>  	priv->iface_running = true;


