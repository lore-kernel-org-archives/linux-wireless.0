Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab2FGPt3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 11:49:29 -0400
Message-ID: <1339084251.2434.2.camel@dcbw.foobar.com> (sfid-20120607_174955_688075_CDD16465)
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
From: Dan Williams <dcbw@redhat.com>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ath6kl-devel@qualcomm.com
Date: Thu, 07 Jun 2012 10:50:51 -0500
In-Reply-To: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 19:43 -0700, Thomas Pedersen wrote:
> Support configuring an RSSI threshold in dBm (s32) when scanning,
> below which a BSS won't be reported by the cfg80211 driver.

What's the point of this?  Shouldn't the driver report all available
APs, even if the signal is small, and then userspace (or whatever is
handling scan results) just ignores ones it doesn't care about?

Dan

> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> ---
>  include/linux/nl80211.h |    6 ++++++
>  include/net/cfg80211.h  |    7 +++++++
>  net/wireless/nl80211.c  |   17 +++++++++++++++++
>  3 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index a6959f7..dc051a8 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1222,6 +1222,10 @@ enum nl80211_commands {
>   * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
>   *      or 0 to disable background scan.
>   *
> + * @NL80211_ATTR_SCAN_RSSI: rssi threshold (in s32 dBm) below which a BSS is
> + *	not reported in scan results. Will be disabled if 0 or not specified.
> + *	Supported in %NL80211_CMD_START_SCHED_SCAN and %NL80211_TRIGGER_SCAN.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -1473,6 +1477,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_BG_SCAN_PERIOD,
>  
> +	NL80211_ATTR_SCAN_RSSI,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 0289d4c..39d293b 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -920,6 +920,7 @@ struct cfg80211_ssid {
>   * @dev: the interface
>   * @aborted: (internal) scan request was notified as aborted
>   * @no_cck: used to send probe requests at non CCK rate in 2GHz band
> + * @rssi: don't report scan results below this threshold
>   */
>  struct cfg80211_scan_request {
>  	struct cfg80211_ssid *ssids;
> @@ -935,6 +936,7 @@ struct cfg80211_scan_request {
>  	struct net_device *dev;
>  	bool aborted;
>  	bool no_cck;
> +	s32 rssi;
>  
>  	/* keep last */
>  	struct ieee80211_channel *channels[0];
> @@ -966,6 +968,7 @@ struct cfg80211_match_set {
>   * @wiphy: the wiphy this was for
>   * @dev: the interface
>   * @channels: channels to scan
> + * @rssi: don't report scan results below this threshold
>   */
>  struct cfg80211_sched_scan_request {
>  	struct cfg80211_ssid *ssids;
> @@ -976,6 +979,7 @@ struct cfg80211_sched_scan_request {
>  	size_t ie_len;
>  	struct cfg80211_match_set *match_sets;
>  	int n_match_sets;
> +	s32 rssi;
>  
>  	/* internal */
>  	struct wiphy *wiphy;
> @@ -1794,6 +1798,8 @@ struct cfg80211_ops {
>   *	responds to probe-requests in hardware.
>   * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
>   * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
> + * @WIPHY_FLAG_SUPPORTS_RSSI_SCAN: Device supports filtering scan results by
> + *	 RSSI (in dBm).
>   */
>  enum wiphy_flags {
>  	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
> @@ -1817,6 +1823,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
>  	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
>  	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
> +	WIPHY_FLAG_SUPPORTS_RSSI_SCAN		= BIT(22),
>  };
>  
>  /**
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 206465d..6886ca1 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -206,6 +206,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>  	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
>  	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
>  	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
> +	[NL80211_ATTR_SCAN_RSSI] = { .type = NLA_U32 },
>  };
>  
>  /* policy for the key attributes */
> @@ -3846,6 +3847,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
>  	if (!rdev->ops->scan)
>  		return -EOPNOTSUPP;
>  
> +	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_RSSI_SCAN) &&
> +	    info->attrs[NL80211_ATTR_SCAN_RSSI])
> +		return -EOPNOTSUPP;
> +
>  	if (rdev->scan_req)
>  		return -EBUSY;
>  
> @@ -3991,6 +3996,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
>  	request->no_cck =
>  		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
>  
> +	if (info->attrs[NL80211_ATTR_SCAN_RSSI])
> +		request->rssi =
> +			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_RSSI]);
> +
>  	request->dev = dev;
>  	request->wiphy = &rdev->wiphy;
>  
> @@ -4027,6 +4036,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
>  	    !rdev->ops->sched_scan_start)
>  		return -EOPNOTSUPP;
>  
> +	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_RSSI_SCAN) &&
> +	    info->attrs[NL80211_ATTR_SCAN_RSSI])
> +		return -EOPNOTSUPP;
> +
>  	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
>  		return -EINVAL;
>  
> @@ -4212,6 +4225,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
>  		       request->ie_len);
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_SCAN_RSSI])
> +		request->rssi =
> +			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_RSSI]);
> +
>  	request->dev = dev;
>  	request->wiphy = &rdev->wiphy;
>  	request->interval = interval;


