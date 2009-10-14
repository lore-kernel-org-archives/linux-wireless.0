Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50897 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZJNUQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 16:16:52 -0400
Date: Wed, 14 Oct 2009 16:08:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: no  cookies in cfg80211_send_ABCD()
Message-ID: <20091014200837.GA11962@tuxdriver.com>
References: <200910140906.16111.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910140906.16111.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't appear to be any different (other than the subject)
than the previous version?

John

On Wed, Oct 14, 2009 at 09:06:16AM +0200, Holger Schurig wrote:
> Get rid of cookies in cfg80211_send_XXX() functions.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> --- linux-wl.orig/include/net/cfg80211.h
> +++ linux-wl/include/net/cfg80211.h
> @@ -1809,30 +1809,45 @@
>   * @dev: network device
>   * @buf: deauthentication frame (header + body)
>   * @len: length of the frame data
> - * @cookie: cookie from ->deauth if called within that callback,
> - *	%NULL otherwise
>   *
>   * This function is called whenever deauthentication has been processed in
>   * station mode. This includes both received deauthentication frames and
>   * locally generated ones. This function may sleep.
>   */
> -void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len,
> -			  void *cookie);
> +void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
> +
> +/**
> + * __cfg80211_send_deauth - notification of processed deauthentication
> + * @dev: network device
> + * @buf: deauthentication frame (header + body)
> + * @len: length of the frame data
> + *
> + * Like cfg80211_send_deauth(), but doesn't take the wdev lock.
> + */
> +void __cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
>  
>  /**
>   * cfg80211_send_disassoc - notification of processed disassociation
>   * @dev: network device
>   * @buf: disassociation response frame (header + body)
>   * @len: length of the frame data
> - * @cookie: cookie from ->disassoc if called within that callback,
> - *	%NULL otherwise
>   *
>   * This function is called whenever disassociation has been processed in
>   * station mode. This includes both received disassociation frames and locally
>   * generated ones. This function may sleep.
>   */
> -void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len,
> -			    void *cookie);
> +void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
> +
> +/**
> + * __cfg80211_send_disassoc - notification of processed disassociation
> + * @dev: network device
> + * @buf: disassociation response frame (header + body)
> + * @len: length of the frame data
> + *
> + * Like cfg80211_send_disassoc(), but doesn't take the wdev lock.
> + */
> +void __cfg80211_send_disassoc(struct net_device *dev, const u8 *buf,
> +	size_t len);
>  
>  /**
>   * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
> --- linux-wl.orig/net/wireless/mlme.c
> +++ linux-wl/net/wireless/mlme.c
> @@ -121,7 +121,7 @@
>  }
>  EXPORT_SYMBOL(cfg80211_send_rx_assoc);
>  
> -static void __cfg80211_send_deauth(struct net_device *dev,
> +void __cfg80211_send_deauth(struct net_device *dev,
>  				   const u8 *buf, size_t len)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> @@ -177,27 +177,19 @@
>  					  false, NULL);
>  	}
>  }
> +EXPORT_SYMBOL(__cfg80211_send_deauth);
>  
> -
> -void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len,
> -			  void *cookie)
> +void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
>  
> -	BUG_ON(cookie && wdev != cookie);
> -
> -	if (cookie) {
> -		/* called within callback */
> -		__cfg80211_send_deauth(dev, buf, len);
> -	} else {
> -		wdev_lock(wdev);
> -		__cfg80211_send_deauth(dev, buf, len);
> -		wdev_unlock(wdev);
> -	}
> +	wdev_lock(wdev);
> +	__cfg80211_send_deauth(dev, buf, len);
> +	wdev_unlock(wdev);
>  }
>  EXPORT_SYMBOL(cfg80211_send_deauth);
>  
> -static void __cfg80211_send_disassoc(struct net_device *dev,
> +void __cfg80211_send_disassoc(struct net_device *dev,
>  				     const u8 *buf, size_t len)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> @@ -238,22 +230,15 @@
>  	from_ap = memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0;
>  	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
>  }
> +EXPORT_SYMBOL(__cfg80211_send_disassoc);
>  
> -void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len,
> -			    void *cookie)
> +void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
>  
> -	BUG_ON(cookie && wdev != cookie);
> -
> -	if (cookie) {
> -		/* called within callback */
> -		__cfg80211_send_disassoc(dev, buf, len);
> -	} else {
> -		wdev_lock(wdev);
> -		__cfg80211_send_disassoc(dev, buf, len);
> -		wdev_unlock(wdev);
> -	}
> +	wdev_lock(wdev);
> +	__cfg80211_send_disassoc(dev, buf, len);
> +	wdev_unlock(wdev);
>  }
>  EXPORT_SYMBOL(cfg80211_send_disassoc);
>  
> --- linux-wl.orig/net/mac80211/mlme.c
> +++ linux-wl/net/mac80211/mlme.c
> @@ -458,9 +458,15 @@
>  	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
>  
>  	if (stype == IEEE80211_STYPE_DEAUTH)
> -		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len, cookie);
> +		if (cookie)
> +			__cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
> +		else
> +			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
>  	else
> -		cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len, cookie);
> +		if (cookie)
> +			__cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
> +		else
> +			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
>  	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
>  }
>  
> @@ -1959,12 +1965,10 @@
>  			/* no action */
>  			break;
>  		case RX_MGMT_CFG80211_DEAUTH:
> -			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len,
> -					     NULL);
> +			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
>  			break;
>  		case RX_MGMT_CFG80211_DISASSOC:
> -			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len,
> -					       NULL);
> +			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
>  			break;
>  		default:
>  			WARN(1, "unexpected: %d", rma);
> @@ -2019,7 +2023,7 @@
>  		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, skb->len);
>  		break;
>  	case RX_MGMT_CFG80211_DEAUTH:
> -		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len, NULL);
> +		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
>  		break;
>  	default:
>  		WARN(1, "unexpected: %d", rma);
> 
> -- 
> http://www.holgerschurig.de
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
