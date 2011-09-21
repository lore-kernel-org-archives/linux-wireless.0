Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:05:17 -0400
Subject: Re: [RFC 2/5] mac80211: handle TDLS high-level commands and frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-3-git-send-email-arik@wizery.com> (sfid-20110915_122551_202876_5B22F090)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-3-git-send-email-arik@wizery.com>
	 (sfid-20110915_122551_202876_5B22F090)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 14:05:13 +0200
Message-ID: <1316606713.3940.29.camel@jlt3.sipsolutions.net> (sfid-20110921_140522_276367_A23209E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:

> +static void ieee80211_tdls_add_supp_rates(struct ieee80211_sub_if_data *sdata,
> +					  struct sk_buff *skb)

maybe it's time to refactor adding supported rates? This must be like
the 5th implementation of it ... mesh has exactly the same at least.

> +static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
> +{
> +	u8 *pos = (void *)skb_put(skb, 7);
> +
> +	*pos++ = WLAN_EID_EXT_CAPABILITY;
> +	*pos++ = 5; /* len */
> +	*pos++ = 0x0;
> +	*pos++ = 0x0;
> +	*pos++ = 0x0;
> +	*pos++ = 0x0;
> +	*pos++ = 0x20; /* TDLS enabled */

That might benefit from a constant in ieee80211.h

> +static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
> +{
> +	u16 capab;
> +	struct ieee80211_local *local = sdata->local;
> +
> +	/* We do not support any exotic capabilities yet */
> +
> +	capab = WLAN_CAPABILITY_ESS;

Should we really set the ESS bit for TDLS?

> +static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr,
> +				       u8 *peer, u8 *bssid)
> +{
> +	struct ieee80211_tdls_lnkie *lnkid;
> +
> +	lnkid = (void *)skb_put(skb, sizeof(struct ieee80211_tdls_lnkie));
> +
> +	lnkid->ie_type = WLAN_EID_LINK_ID;
> +	lnkid->ie_len = 18;

sizeof too?

> +	memcpy(tf->da, peer, ETH_ALEN);
> +	memcpy(tf->sa, sdata->vif.addr, ETH_ALEN);
> +	tf->ether_type = cpu_to_be16(ETH_P_TDLS);
> +	tf->payload_type = 2; /* RFTYPE_TDLS */

another constant?

> +	default:
> +		/* we don't support other actions for now */
> +		WARN_ON(1);
> +		return -EINVAL;

Wouldn't that warning be triggerable from userspace?

> +static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
> +			       u8 *peer, u8 action_code, u8 dialog_token,
> +			       u16 status_code, const u8 *extra_ies,
> +			       size_t extra_ies_len)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_tx_info *info;
> +	struct sk_buff *skb = NULL;
> +	bool send_direct;
> +	int ret;
> +
> +#ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
> +	printk(KERN_DEBUG "TDLS mgmt action %d peer %pM\n", action_code, peer);
> +#endif
> +
> +	/* make sure we are in managed mode, and associated */
> +	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
> +	    !sdata->u.mgd.associated) {
> +		return -EINVAL;
> +	}

braces here seem useless :)

Also accessing u.mgd.associated as a bool like this is fine, but
obviously racy. How do we deal with that? Do we even tear down links
when disassociating, and do we even need to beyond just killing the
station entries?

> +	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
> +			    max(sizeof(struct ieee80211_mgmt),
> +				sizeof(struct ieee80211_tdls_data)) +
> +			    50 + /* supported rates */
> +			    7 + /* ext capab */
> +			    sizeof(struct ieee80211_tdls_lnkie));

Where are the extra IEs used? They should be accounted for too.

> +fail:
> +	if (skb)
> +		dev_kfree_skb(skb);

I believe the if() is pointless.

> +	case NL80211_TDLS_DISABLE_LINK:
> +		rcu_read_lock();
> +		sta = sta_info_get(sdata, peer);
> +		if (sta) {
> +			sta->tdls_link_enabled = false;
> +			sta_info_destroy_addr(sdata, peer);
> +		}
> +		rcu_read_unlock();

You can't call destroy_addr within rcu section.

> +	case NL80211_TDLS_TEARDOWN:
> +	case NL80211_TDLS_SETUP:
> +	case NL80211_TDLS_DISCOVERY_REQ:
> +		/* We don't support in-driver setup/teardown/discovery */
> +		return -ENOTSUPP;
> +	case NL80211_TDLS_DISABLE:
> +	case NL80211_TDLS_ENABLE:
> +		/* TODO */
> +		return -ENOTSUPP;
> +	default:
> +		WARN_ON(1);
> +		return -EINVAL;

might want to use EOPNOTSUPP and not have a warning -- if nl80211 ever
gets extended with more actions you might run into the default case.

johannes

