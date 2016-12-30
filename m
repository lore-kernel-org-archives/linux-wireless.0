Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0063.outbound.protection.outlook.com ([104.47.42.63]:34944
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752030AbcL3ULM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 15:11:12 -0500
Subject: Re: [PATCH] cfg80211: Random local address for Public Action frame
 exchange
To: <jouni@qca.qualcomm.com>, Johannes Berg <johannes@sipsolutions.net>
References: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <vamsin@qti.qualcomm.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <cf228384-c98e-737e-3ba6-6c18e988210c@quantenna.com> (sfid-20161230_211119_267138_41704C5A)
Date: Fri, 30 Dec 2016 22:55:48 +0300
MIME-Version: 1.0
In-Reply-To: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2016 11:39 PM, Jouni Malinen wrote:
> From: vamsi krishna <vamsin-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
>
> Add support to use random local address (Address 2 = SA in transmit and
> the same address in receive functionality) for Public Action frames in
> order to improve privacy of WLAN clients. Applications fill the random
> source address in the frame buffer along with setting the
> NL80211_ATTR_RANDOM_SA flag when using the NL80211_CMD_FRAME command.
> This can be used only with the drivers that indicate support for random
> local address by setting the new NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA
> and/or NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED in ext_features.
>
> The driver needs to configure receive behavior to accept frames to the
> specified random address during the time the frame exchange is pending
> and such frames need to be acknowledged similarly to frames sent to the
> local permanent address when this random address functionality is not
> used.

A (probably) silly question: how wireless drivers are supposed to use SA 
in a frame? I think drivers are not concerned about source address, they 
simply pass whatever there is already set by userspace in 
cfg80211_mgmt_tx_params::buf into air on Tx.
And on Rx, they filter frames based on receiver address/BSSID, pass it 
to upper layers and do not care what address is in DA (it is handled by 
upper layers).

What can we use random_sa flag introduced in this patch for then?


>
> Signed-off-by: vamsi krishna <vamsin-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
> Signed-off-by: Jouni Malinen <jouni-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>
> ---
>  include/net/cfg80211.h       |  6 ++++++
>  include/uapi/linux/nl80211.h | 16 ++++++++++++++++
>  net/wireless/mlme.c          |  5 ++++-
>  net/wireless/nl80211.c       | 14 ++++++++++++++
>  4 files changed, 40 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ca2ac1c..c442e4c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2303,6 +2303,11 @@ struct cfg80211_update_ft_ies_params {
>   * @dont_wait_for_ack: tells the low level not to wait for an ack
>   * @n_csa_offsets: length of csa_offsets array
>   * @csa_offsets: array of all the csa offsets in the frame
> + * @random_sa: indicates whether the source address is randomized. When this is
> + *	true, the driver needs to transmit the management frame using the
> + *	address specified in the SA field (Address 2) in the buffer and the
> + *	driver needs to receive and acknowledge the response frame to this
> + *	address instead of its permanent MAC address.
>   */
>  struct cfg80211_mgmt_tx_params {
>  	struct ieee80211_channel *chan;
> @@ -2314,6 +2319,7 @@ struct cfg80211_mgmt_tx_params {
>  	bool dont_wait_for_ack;
>  	int n_csa_offsets;
>  	const u16 *csa_offsets;
> +	bool random_sa;
>  };
>
>  /**
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index d74e10b..cffc117 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -567,6 +567,9 @@
>   *	%NL80211_ATTR_CSA_C_OFFSETS_TX is an array of offsets to CSA
>   *	counters which will be updated to the current value. This attribute
>   *	is used during CSA period.
> + *	When sending a Public Action frame, %NL80211_ATTR_MGMT_TX_RANDOM_SA can
> + *	be used to indicate that random local address (SA) is used for the
> + *	exchange.
>   * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
>   *	command may be used with the corresponding cookie to cancel the wait
>   *	time if it is known that it is no longer necessary.
> @@ -1915,6 +1918,11 @@ enum nl80211_commands {
>   *	%NL80211_ATTR_IFTYPE, %NL80211_ATTR_EXT_CAPA,
>   *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended capabilities per
>   *	interface type.
> + * @NL80211_ATTR_MGMT_TX_RANDOM_SA: A flag attribute indicating whether the
> + *	source address is randomized in frames sent using %NL80211_CMD_FRAME.
> + *	If this flag is not set, the source address field is verified to match
> + *	local MAC address. Random SA can be used only with Public Action frames
> + *	(e.g., GAS/ANQP).
>   *
>   * @NL80211_ATTR_MU_MIMO_GROUP_DATA: array of 24 bytes that defines a MU-MIMO
>   *	groupID for monitor mode.
> @@ -2386,6 +2394,8 @@ enum nl80211_attrs {
>
>  	NL80211_ATTR_BSSID,
>
> +	NL80211_ATTR_MGMT_TX_RANDOM_SA,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -4697,6 +4707,10 @@ enum nl80211_feature_flags {
>   *	configuration (AP/mesh) with VHT rates.
>   * @NL80211_EXT_FEATURE_FILS_STA: This driver supports Fast Initial Link Setup
>   *	with user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
> + * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA: This driver supports randomized SA
> + *	in @NL80211_CMD_FRAME while not associated.
> + * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED: This driver supports
> + *	randomized SA in @NL80211_CMD_FRAME while associated.
>   *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
> @@ -4712,6 +4726,8 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_BEACON_RATE_HT,
>  	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
>  	NL80211_EXT_FEATURE_FILS_STA,
> +	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA,
> +	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED,
>
>  	/* add new features before the definition below */
>  	NUM_NL80211_EXT_FEATURES,
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 4646cf5..9568a72 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -657,7 +657,10 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
>  			return err;
>  	}
>
> -	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev)))
> +	if (!(params->random_sa &&
> +	      (ieee80211_is_action(mgmt->frame_control) &&
> +	       mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)) &&
> +	    !ether_addr_equal(mgmt->sa, wdev_address(wdev)))
>  		return -EINVAL;
>
>  	/* Transmit the Action frame as requested by user space */
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 2369265..efced76 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -405,6 +405,7 @@ enum nl80211_multicast_groups {
>  	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
>  	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
>  	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
> +	[NL80211_ATTR_MGMT_TX_RANDOM_SA] = { .type = NLA_FLAG },
>  };
>
>  /* policy for the key attributes */
> @@ -9209,6 +9210,19 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
>  		}
>  	}
>
> +	params.random_sa = nla_get_flag(
> +		info->attrs[NL80211_ATTR_MGMT_TX_RANDOM_SA]);
> +	if (params.random_sa &&
> +	    ((!wdev->current_bss &&
> +	      !wiphy_ext_feature_isset(
> +		      &rdev->wiphy,
> +		      NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA)) ||
> +	     (wdev->current_bss &&
> +	      !wiphy_ext_feature_isset(
> +		      &rdev->wiphy,
> +		      NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED))))
> +		return -EINVAL;
> +
>  	if (!params.dont_wait_for_ack) {
>  		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  		if (!msg)
>
