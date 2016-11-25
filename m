Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41874 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751021AbcKYJVV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 04:21:21 -0500
Message-ID: <1480065675.2517.109.camel@coelho.fi> (sfid-20161125_102127_766956_D279492E)
From: Luca Coelho <luca@coelho.fi>
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Fri, 25 Nov 2016 11:21:15 +0200
In-Reply-To: <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
         <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] cfg80211: Add support to sched scan to report
 better BSSs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IMHO "report better BSSs" is vague in this context.  It would better to
use something more concrete like "add relative RSSI attribute to sched
scan".


On Thu, 2016-11-24 at 00:07 +0200, Jouni Malinen wrote:
> From: vamsi krishna <vamsin@qti.qualcomm.com>
> 
> Enhance sched scan to support option of finding a better BSS while in
> connected state. Firmware scans the medium and reports when it finds
a
> known BSS which has a significantly better RSSI than the current

"Significantly" is dependent on the value you use. :)

> connected BSS.
> 
> Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  include/net/cfg80211.h       | 17 +++++++++++++++++
>  include/uapi/linux/nl80211.h | 17 +++++++++++++++++
>  net/wireless/nl80211.c       | 32 ++++++++++++++++++++++++++++++--
>  3 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ef42749..c62c42a 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1626,6 +1626,20 @@ struct cfg80211_sched_scan_plan {
>   *	cycle.  The driver may ignore this parameter and start
>   *	immediately (or at any other time), if this feature is not
>   *	supported.
> + * @relative_rssi: Relative RSSI threshold to restrict scan result
reporting in
> + *	connected state to cases where a matching BSS is
determined to have a
> + *	significantly better RSSI than the current connected BSS.

What happens with this attribute if we're not connected? Also, I think
you should specify the attribute type (int?) and the unit here.


> + * @relative_rssi_5g_pref: The amount of RSSI preference that is given to a
> + *	5 GHz BSS over 2.4 GHz BSS while looking for better BSSs in connected
> + *	state.
> + *	If the current connected BSS is in the 2.4 GHz band, other BSSs in the
> + *	2.4 GHz band to be reported should have better RSSI by @relative_rssi
> + *	and other BSSs in the 5 GHz band to be reported should have better RSSI
> + *	by (@relative_rssi - @relative_rssi_5g_pref).
> + *	If the current connected BSS is in the 5 GHz band, other BSSs in the
> + *	2.4 GHz band to be reported should have better RSSI by
> + *	(@relative_rssi + @relative_rssi_5g_pref) and other BSSs in the 5 GHz
> + *	band to be reported should have better RSSI by by @relative_rssi.

Could there be cases where you want the opposite? Meaning,
relative_rssi_5g_pref being negative?

>   */
>  struct cfg80211_sched_scan_request {
>  	struct cfg80211_ssid *ssids;
> @@ -1645,6 +1659,9 @@ struct cfg80211_sched_scan_request {
>  	u8 mac_addr[ETH_ALEN] __aligned(2);
>  	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
>  
> +	int relative_rssi;
> +	int relative_rssi_5g_pref;

I'm not sure it was your intention, but for flexibility, it's good that
both these attributes are ints so that you can find relative values on
both sides (greater than and smaller than).

It doesn't apply to the "better BSS" case, but maybe people find a
different use for it in the future?


> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 984a35ac..34b16a4 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1981,6 +1981,16 @@ enum nl80211_commands {
>   *	%NL80211_ATTR_MAC has also been used in various commands/events for
>   *	specifying the BSSID.
>   *
> + * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI: Relative RSSI threshold by which
> + *	other BSSs has to be better than the current connected BSS so that they
> + *	get reported to user space. This will give an opportunity to userspace
> + *	to consider connecting to other matching BSSs which have better RSSI
> + *	than the current connected BSS.

The userspace can always do this, but the advantage here is that it
doesn't need to be woken up and check the results itself, since it
would only receive results that matter.


> + *
> + * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF: The amount of RSSI preference
> + *	to be given to 5 GHz APs over 2.4 GHz APs while searching for better
> + *	BSSs than the current connected BSS.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2387,6 +2397,9 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_BSSID,
>  
> +	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
> +	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -4698,6 +4711,9 @@ enum nl80211_feature_flags {
>   *	configuration (AP/mesh) with VHT rates.
>   * @NL80211_EXT_FEATURE_FILS_STA: This driver supports Fast Initial Link Setup
>   *	with user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
> + * @NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS: The driver supports sched_scan

Should be "RELATIVE_RSSI" instead of "BETTER_BSS".

[...]

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 8db5cb1..af018a5 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -405,6 +405,8 @@ enum nl80211_multicast_groups {
>  	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
>  	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
>  	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
> +	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] = { .type = NLA_U32 },
> +	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF] = { .type = NLA_U32 },

This should probably be NLA_S32 (if we want to allow negative values as
well).


[...]

> 
@@ -7156,6 +7166,14 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
>  		request->delay =
>  			nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_DELAY]);
>  
> +	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI])
> +		request->relative_rssi = nla_get_s32(
> +			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]);
> +
> +	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF])
> +		request->relative_rssi_5g_pref = nla_get_s32(
> +			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF]);

Good, I see you use s32 here. :)

[...]

> @@ -9649,7 +9667,8 @@ static int nl80211_send_wowlan_tcp(struct sk_buff *msg,
>  	return 0;
>  }
>  
> -static int nl80211_send_wowlan_nd(struct sk_buff *msg,
> +static int nl80211_send_wowlan_nd(struct wiphy *wiphy,
> +				  struct sk_buff *msg,
>  				  struct cfg80211_sched_scan_request *req)
>  {
>  	struct nlattr *nd, *freqs, *matches, *match, *scan_plans, *scan_plan;
> @@ -9670,6 +9689,15 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
>  	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_DELAY, req->delay))
>  		return -ENOBUFS;
>  
> +	if (wiphy_ext_feature_isset(
> +		    wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS) &&
> +	    (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
> +			 req->relative_rssi) ||
> +	     nla_put_u32(msg,
> +			 NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
> +			 req->relative_rssi_5g_pref)))
> +		return -ENOBUFS;
> +

Why did you add this to nl80211_send_wowlan_nd() function?


[...]

--
Luca.
