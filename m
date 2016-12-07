Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35108 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932243AbcLGUMD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 15:12:03 -0500
Received: by mail-qt0-f171.google.com with SMTP id c47so390891699qtc.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 12:12:03 -0800 (PST)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
 <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5fd9ac43-bcd9-096a-53d9-81528ba5d071@broadcom.com> (sfid-20161207_211207_459402_20705928)
Date: Wed, 7 Dec 2016 21:11:59 +0100
MIME-Version: 1.0
In-Reply-To: <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-12-2016 22:59, Jouni Malinen wrote:
> From: vamsi krishna <vamsin@qti.qualcomm.com>
> 
> Enhance sched scan to support option of finding a better BSS while in
> connected state. Firmware scans the medium and reports when it finds a
> known BSS which has better RSSI than the current connected BSS. New
> attributes to specify the relative RSSI (compared to the current BSS)
> are added to the sched scan to implement this.
> 
> Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  include/net/cfg80211.h       | 19 +++++++++++++++++++
>  include/uapi/linux/nl80211.h | 18 ++++++++++++++++++
>  net/wireless/nl80211.c       | 29 +++++++++++++++++++++++++++--
>  3 files changed, 64 insertions(+), 2 deletions(-)
> 
> v2: address comments from Luca, Arend, and Johannes
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ef42749..dcdd0c4 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1626,6 +1626,22 @@ struct cfg80211_sched_scan_plan {
>   *	cycle.  The driver may ignore this parameter and start
>   *	immediately (or at any other time), if this feature is not
>   *	supported.
> + * @relative_rssi: Relative RSSI threshold in dB to restrict scan result
> + *	reporting in connected state to cases where a matching BSS is determined
> + *	to have better RSSI than the current connected BSS. The relative RSSI
> + *	threshold values are ignored in disconnected state.
> + * @relative_rssi_5g_pref: The amount of RSSI preference in dB that is given to
> + *	a 5 GHz BSS over 2.4 GHz BSS while looking for better BSSs in connected
> + *	state. A negative value can be passed if 2.4 GHz band should be given
> + *	priority to 5 GHz band.
> + *	If the current connected BSS is in the 2.4 GHz band, other BSSs in the
> + *	2.4 GHz band to be reported should have better RSSI by @relative_rssi
> + *	and other BSSs in the 5 GHz band to be reported should have better RSSI
> + *	by (@relative_rssi - @relative_rssi_5g_pref).
> + *	If the current connected BSS is in the 5 GHz band, other BSSs in the
> + *	2.4 GHz band to be reported should have better RSSI by
> + *	(@relative_rssi + @relative_rssi_5g_pref) and other BSSs in the 5 GHz
> + *	band to be reported should have better RSSI by by @relative_rssi.

The choice of these attributes makes the implicit assumption that the
BSS-es in 5G are preferred. The relative_rssi_5g_pref is actually more a
bonus or penalty is negative value is used. I guess for speed junkies
that want their 11ac card maxed out that is true, but if you need to
cross a couple of concrete floors you might want to stick with 2.4G.

I introduced a similar attribute to be provided in the
NL80211_CMD_CONNECT (see [1]).

Regards,
Arend

[1] http://lxr.free-electrons.com/source/include/uapi/linux/nl80211.h#L1815

>   */
>  struct cfg80211_sched_scan_request {
>  	struct cfg80211_ssid *ssids;
> @@ -1645,6 +1661,9 @@ struct cfg80211_sched_scan_request {
>  	u8 mac_addr[ETH_ALEN] __aligned(2);
>  	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
>  
> +	s8 relative_rssi;
> +	s8 relative_rssi_5g_pref;
> +
>  	/* internal */
>  	struct wiphy *wiphy;
>  	struct net_device *dev;
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 6b76e3b..fc29bdb 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1980,6 +1980,17 @@ enum nl80211_commands {
>   * @NL80211_ATTR_BSSID: The BSSID of the AP. Note that %NL80211_ATTR_MAC is also
>   *	used in various commands/events for specifying the BSSID.
>   *
> + * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI: Relative RSSI threshold by which
> + *	other BSSs has to be better than the current connected BSS so that they
> + *	get reported to user space. This will give an opportunity to userspace
> + *	to consider connecting to other matching BSSs which have better RSSI
> + *	than the current connected BSS by using an offloaded operation to avoid
> + *	unnecessary wakeups.
> + *
> + * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF: The amount of RSSI preference
> + *	to be given to 5 GHz APs over 2.4 GHz APs while searching for better
> + *	BSSs than the current connected BSS.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2386,6 +2397,9 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_BSSID,
>  
> +	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
> +	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -4697,6 +4711,9 @@ enum nl80211_feature_flags {
>   *	configuration (AP/mesh) with VHT rates.
>   * @NL80211_EXT_FEATURE_FILS_STA: This driver supports Fast Initial Link Setup
>   *	with user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
> + * @NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI: The driver supports sched_scan
> + *	for reporting BSSs with better RSSI than the current connected BSS
> + *	(%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI).
>   *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
> @@ -4712,6 +4729,7 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_BEACON_RATE_HT,
>  	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
>  	NL80211_EXT_FEATURE_FILS_STA,
> +	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
>  
>  	/* add new features before the definition below */
>  	NUM_NL80211_EXT_FEATURES,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 7762231..549f239 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -405,6 +405,8 @@ enum nl80211_multicast_groups {
>  	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
>  	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
>  	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
> +	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] = { .type = NLA_S8 },
> +	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF] = { .type = NLA_S8 },
>  };
>  
>  /* policy for the key attributes */
> @@ -6950,6 +6952,12 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
>  	if (!n_plans || n_plans > wiphy->max_sched_scan_plans)
>  		return ERR_PTR(-EINVAL);
>  
> +	if (!wiphy_ext_feature_isset(
> +		    wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI) &&
> +	    (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] ||
> +	     attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF]))
> +		return ERR_PTR(-EINVAL);
> +
>  	request = kzalloc(sizeof(*request)
>  			+ sizeof(*request->ssids) * n_ssids
>  			+ sizeof(*request->match_sets) * n_match_sets
> @@ -7156,6 +7164,14 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
>  		request->delay =
>  			nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_DELAY]);
>  
> +	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI])
> +		request->relative_rssi = nla_get_s8(
> +			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]);
> +
> +	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF])
> +		request->relative_rssi_5g_pref = nla_get_s8(
> +			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF]);
> +
>  	err = nl80211_parse_sched_scan_plans(wiphy, n_plans, request, attrs);
>  	if (err)
>  		goto out_free;
> @@ -9649,7 +9665,8 @@ static int nl80211_send_wowlan_tcp(struct sk_buff *msg,
>  	return 0;
>  }
>  
> -static int nl80211_send_wowlan_nd(struct sk_buff *msg,
> +static int nl80211_send_wowlan_nd(struct wiphy *wiphy,
> +				  struct sk_buff *msg,
>  				  struct cfg80211_sched_scan_request *req)
>  {
>  	struct nlattr *nd, *freqs, *matches, *match, *scan_plans, *scan_plan;
> @@ -9670,6 +9687,14 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
>  	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_DELAY, req->delay))
>  		return -ENOBUFS;
>  
> +	if (wiphy_ext_feature_isset(
> +		    wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI) &&
> +	    (nla_put_s8(msg, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
> +			req->relative_rssi) ||
> +	     nla_put_s8(msg, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
> +			req->relative_rssi_5g_pref)))
> +		return -ENOBUFS;
> +
>  	freqs = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
>  	if (!freqs)
>  		return -ENOBUFS;
> @@ -9783,7 +9808,7 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
>  			goto nla_put_failure;
>  
>  		if (nl80211_send_wowlan_nd(
> -			    msg,
> +			    &rdev->wiphy, msg,
>  			    rdev->wiphy.wowlan_config->nd_config))
>  			goto nla_put_failure;
>  
> 
