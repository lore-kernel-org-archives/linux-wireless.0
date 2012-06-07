Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25631 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2FGHYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 03:24:07 -0400
Message-ID: <4FD0570D.50303@qca.qualcomm.com> (sfid-20120607_092412_291924_ED6D72A5)
Date: Thu, 7 Jun 2012 10:23:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 05:43 AM, Thomas Pedersen wrote:
> Support configuring an RSSI threshold in dBm (s32) when scanning,
> below which a BSS won't be reported by the cfg80211 driver.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

[...]

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

NL80211_ATTR_SCAN_RSSI_THRESHOLD? Or is limit a better term? Or
something else?

My english sucks anyway...

> @@ -935,6 +936,7 @@ struct cfg80211_scan_request {
>  	struct net_device *dev;
>  	bool aborted;
>  	bool no_cck;
> +	s32 rssi;

rssi_threshold?

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

rssi_threshold?

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

Is this flag really needed? For me this looks like an optimisation more
than a functional change. If the driver supports this, that's great and
we can save some power. But if the driver does not support it does it
really make any difference for the user space? Would user space act
differently if this feature is not supported by the driver?

(Just asking to understand this better.)

Kalle
