Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34940 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdBXIIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 03:08:20 -0500
Received: by mail-wr0-f176.google.com with SMTP id g10so6180175wrg.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 00:08:19 -0800 (PST)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221123758.5339-1-johannes@sipsolutions.net>
 <20170221123758.5339-2-johannes@sipsolutions.net>
Cc: Avraham Stern <avraham.stern@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <177c53b2-cd5f-97a9-26b0-b590071785cb@broadcom.com> (sfid-20170224_090825_958868_6C9757BC)
Date: Fri, 24 Feb 2017 09:08:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170221123758.5339-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21-2-2017 13:37, Johannes Berg wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Add API for setting the PMK to the driver. For FT support, allow
> setting also the PMK-R0 Name.
> 
> This can be used by drivers that support 4-Way handshake offload
> while IEEE802.1X authentication is managed by upper layers.
> 
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/linux/ieee80211.h    |  3 ++
>  include/net/cfg80211.h       | 27 ++++++++++++
>  include/uapi/linux/nl80211.h | 24 ++++++++++-
>  net/wireless/core.c          |  5 +++
>  net/wireless/nl80211.c       | 99 ++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/rdev-ops.h      | 25 +++++++++++
>  net/wireless/trace.h         | 60 +++++++++++++++++++++++++++
>  7 files changed, 241 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 2049e983a994..fb1f533e75b3 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -2356,8 +2356,11 @@ enum ieee80211_sa_query_action {
>  
>  #define WLAN_MAX_KEY_LEN		32
>  
> +#define WLAN_PMK_NAME_LEN		16
>  #define WLAN_PMKID_LEN			16
> +#define WLAN_PMK_LEN_EAP_LEAP		16
>  #define WLAN_PMK_LEN			32
> +#define WLAN_PMK_LEN_SUITE_B_192	48
>  
>  #define WLAN_OUI_WFA			0x506f9a
>  #define WLAN_OUI_TYPE_WFA_P2P		9
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 4ca968927d60..a68c6db6ac55 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2507,6 +2507,23 @@ struct cfg80211_nan_func {
>  };
>  
>  /**
> + * struct cfg80211_pmk_conf - PMK configuration
> + *
> + * @aa: authenticator address
> + * @pmk_len: PMK length in bytes.
> + * @pmk: the PMK material
> + * @pmk_r0_name: PMK-R0 Name. NULL if not applicable (i.e., the PMK
> + *	is not PMK-R0). When pmk_r0_name is not NULL, the pmk field
> + *	holds PMK-R0.
> + */
> +struct cfg80211_pmk_conf {
> +	const u8 *aa;
> +	u8 pmk_len;
> +	const u8 *pmk;
> +	const u8 *pmk_r0_name;
> +};
> +
> +/**
>   * struct cfg80211_ops - backend description for wireless configuration
>   *
>   * This struct is registered by fullmac card drivers and/or wireless stacks
> @@ -2823,6 +2840,11 @@ struct cfg80211_nan_func {
>   *	All other parameters must be ignored.
>   *
>   * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
> + *
> + * @set_pmk: configure the PMK to be used for offloaded 4-Way handshake.
> + *	(invoked with the wireless_dev mutex held)
> + * @del_pmk: delete the previously configured PMK for the given authenticator.
> + *	(invoked with the wireless_dev mutex held)
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -3111,6 +3133,11 @@ struct cfg80211_ops {
>  	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
>  					    struct net_device *dev,
>  					    const bool enabled);
> +
> +	int	(*set_pmk)(struct wiphy *wiphy, struct net_device *dev,
> +			   const struct cfg80211_pmk_conf *conf);
> +	int	(*del_pmk)(struct wiphy *wiphy, struct net_device *dev,
> +			   const u8 *aa);

Minor nit, but prefer clr_pmk to clear the pmk.

>  };
>  
>  /*
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index bb5e1904a107..89295fc2336b 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -901,6 +901,14 @@
>   *	does not result in a change for the current association. Currently,
>   *	only the %NL80211_ATTR_IE data is used and updated with this command.
>   *
> + * @NL80211_CMD_SET_PMK: For offloaded 4-Way handshake, set the PMK or PMK-R0
> + *	for the given authenticator address (specified with &NL80211_ATTR_MAC).
> + *	When &NL80211_ATTR_PMKR0_NAME is set, &NL80211_ATTR_PMK specifies the
> + *	PMK-R0, otherwise it specifies the PMK.
> + * @NL80211_CMD_DEL_PMK: For offloaded 4-Way handshake, delete the previously
> + *	configured PMK for the authenticator address identified by
> + *	&NL80211_ATTR_MAC.

Maybe better to indicate it is for 802.1X. Here also preference for
NL80211_CMD_CLR_PMK.

> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -1100,6 +1108,9 @@ enum nl80211_commands {
>  
>  	NL80211_CMD_UPDATE_CONNECT_PARAMS,
>  
> +	NL80211_CMD_SET_PMK,
> +	NL80211_CMD_DEL_PMK,
> +
>  	/* add new commands above here */
>  
>  	/* used to define NL80211_CMD_MAX below */
> @@ -2012,8 +2023,12 @@ enum nl80211_commands {
>   *	u32 attribute with an &enum nl80211_timeout_reason value. This is used,
>   *	e.g., with %NL80211_CMD_CONNECT event.
>   *
> - * @NL80211_ATTR_PMK: PSK for offloaded 4-Way Handshake. Relevant only
> - *	with %NL80211_CMD_CONNECT (for WPA/WPA2-PSK networks).
> + * @NL80211_ATTR_PMK: PMK for offloaded 4-Way Handshake. Relevant with
> + *	%NL80211_CMD_CONNECT (for WPA/WPA2-PSK networks) when PSK is used, or
> + *	with %NL80211_CMD_SET_PMK when 802.1X authentication is used.
> + *	When &NL80211_ATTR_PMKR0_NAME is specified, this attribute specifies
> + *	the PMK-R0.
> + * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
>   *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
> @@ -2427,6 +2442,7 @@ enum nl80211_attrs {
>  	NL80211_ATTR_TIMEOUT_REASON,
>  
>  	NL80211_ATTR_PMK,
> +	NL80211_ATTR_PMKR0_NAME,
>  
>  	/* add attributes here, update the policy in nl80211.c */
>  
> @@ -4767,6 +4783,9 @@ enum nl80211_feature_flags {
>   * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK: Device supports doing 4-way
>   *	handshake with PSK in station mode (PSK is passed as part of the connect
>   *	and associate commands).
> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X: Device supports doing 4-way
> + *	handshake with 802.1X in station mode (needs to pass EAP frames to
> + *	the host and accept the set_pmk/del_pmk commands).
>   *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
> @@ -4787,6 +4806,7 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
>  	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
>  	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK,
> +	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X,

So do we need this flag. Is the fact that the driver implements the
set_pmk and del_pmk (or clr_pmk) callbacks not sufficient provided they
are listed in the "supported commands" message of wiphy dump (not in
this patch). Which reminds me, is "supported commands" no longer
preferred because that list does not seem complete?

Regards,
Arend
