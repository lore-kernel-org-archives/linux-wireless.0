Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:30799 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbXCZXyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 19:54:00 -0400
Date: Mon, 26 Mar 2007 16:52:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
Message-Id: <20070326165254.97753ad8.randy.dunlap@oracle.com>
In-Reply-To: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Mar 2007 04:38:25 -0700 mohamed wrote:

> Add basic support for IEEE 802.11n discovery and association.
> 
> This patch adds support to discover IEEE 802.11n AP and enable 
> association to 802.11n Network. It parses beacon to discover 802.11n 
> IE and include HT capability information element in Association Request
> Frame. 
> It also call low level driver with the HT capability available during 
> association. 
> 
> Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
> 
> diff -Nupr wireless-dev/include/net/mac80211.h
> wireless-dev-new/include/net/mac80211.h
> --- wireless-dev/include/net/mac80211.h	2007-03-27 00:36:28.000000000
> -0700
> +++ wireless-dev-new/include/net/mac80211.h	2007-03-27
> 00:59:40.000000000 -0700

I'm seeing an email/patch problem here.  The lines above should be
3 lines only, not 6 that I'm seeing.  Maybe it's my mail client,
but it usually works for me, so possibly yours is splitting lines
when it should not.

> @@ -526,6 +526,9 @@ struct ieee80211_hw {
>  	 * per-packet RC4 key with each TX frame when doing hwcrypto */
>  #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
>  
> +	/* The device capable of supporting 11n */
> +#define IEEE80211_HW_SUPPORT_HT_MODE (1<<15)
> +
>  	u32 flags;			/* hardware flags defined above */
>  
>  	/* Set to the size of a needed device specific skb headroom for TX
> skbs. */
> @@ -720,6 +723,17 @@ struct ieee80211_ops {
>  	/* Get the current TSF timer value from firmware/hardware. Currently,
>  	 * this is only used for IBSS mode debugging and, as such, is not a
>  	 * required function. */
> +
> +	/* Configure ht parameters 

Line above ends with space.  :(

What is "ht"?

> +	*/
> +	int (*conf_ht)(struct ieee80211_hw *hw, 
> +		       struct ieee80211_ht_capability *ht_cap_param,
> +		       struct ieee80211_ht_additional_info *ht_extra_param);
> +
> +	/* Get ht capabilities from the device */
> +	int (*get_ht_capab)(struct ieee80211_hw *hw,
> +			    struct ieee80211_ht_capability *ht_cap_param);
> +
>  	u64 (*get_tsf)(struct ieee80211_hw *hw);
>  
>  	/* Reset the TSF timer and allow firmware/hardware to synchronize with
> diff -Nupr wireless-dev/net/mac80211/ieee80211_sta.c
> wireless-dev-new/net/mac80211/ieee80211_sta.c
> --- wireless-dev/net/mac80211/ieee80211_sta.c	2007-03-27
> 00:36:28.000000000 -0700
> +++ wireless-dev-new/net/mac80211/ieee80211_sta.c	2007-03-27
> 01:26:06.000000000 -0700
> @@ -230,7 +242,55 @@ static int ecw2cw(int ecw)
>  	return cw - 1;
>  }
>  
> +/* call low level driver with 11n params as it was recieved

                                                      received
> +   from the AP
> +*/   

Line above ends with spaces.

Kernel long comment style is:

/*
 * call low-level driver with 11n params as they were received
 * from the AP
 */

> +static void ieee80211_sta_ht_params(struct net_device *dev, 
> +			struct sta_info *sta,
> +			struct ieee80211_ht_additional_info *ht_extra_param,
> +			struct ieee80211_ht_capability *ht_cap_param)
> +{
> +	int rc;
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +
> +	if (local->ops->conf_ht) {
> +		rc = local->ops->conf_ht(local_to_hw(local), ht_cap_param, 
> +					 ht_extra_param);
> +
> +		if (rc)
> +			sta->flags &= ~WLAN_STA_HT;
> +	} else 
> +		sta->flags &= ~WLAN_STA_HT;
> +
> +	return;
> +}
> +
> +/* Get 11n capabilties from low level driver */
> +static void ieee80211_fill_ht_ie(struct net_device *dev,
> +				 struct ieee80211_ht_capability *ht_capab)
> +{
> +	int rc;
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +
> +	if (!local->ops->get_ht_capab){
> +		memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> +		return;
> +	}
> +
> +	rc = local->ops->get_ht_capab(local_to_hw(local), ht_capab);
> +	if (!rc) {
> +		memset(ht_capab, 0, sizeof(struct ieee80211_ht_capability));
> +		return;
> +	}
>  
> +	ht_capab->capabilitiesInfo = (__le16) cpu_to_le16(
> +					ht_capab->capabilitiesInfo);
> +	ht_capab->extended_ht_capability_info = (__le16) cpu_to_le16(
> +					ht_capab->extended_ht_capability_info);
> +	ht_capab->tx_BF_capability_info = (__le32) cpu_to_le32(
> +					ht_capab->tx_BF_capability_info);
> +}
> + 
>  static void ieee80211_sta_wmm_params(struct net_device *dev,
>  				     struct ieee80211_if_sta *ifsta,
>  				     u8 *wmm_param, size_t wmm_param_len)
> @@ -584,6 +648,15 @@ static void ieee80211_send_assoc(struct 
>  		*pos++ = 0;
>  	}
>  
> +	/* if low level driver support 11n fill in 11n IE */

                               supports 11n,

> +	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
> +		pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
> +		*pos++ = WLAN_EID_HT_CAPABILITY;
> +		*pos++ = sizeof(struct ieee80211_ht_capability);
> +		ieee80211_fill_ht_ie(dev, 
> +				     (struct ieee80211_ht_capability *)pos);
> +	}
> +		
>  	kfree(ifsta->assocreq_ies);
>  	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
>  	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_ATOMIC);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
