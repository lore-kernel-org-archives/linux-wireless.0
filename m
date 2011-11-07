Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37791 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1KGWxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 17:53:03 -0500
Message-ID: <4EB86149.4000700@candelatech.com> (sfid-20111107_235308_556977_F517EC2C)
Date: Mon, 07 Nov 2011 14:52:57 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 1/2] wireless:  Support ht-capabilities over-rides.
References: <1320701702-13968-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1320701702-13968-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 01:35 PM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> This allows users to disable features such as HT, HT40,
> and to modify the MCS, AMPDU, and AMSDU settings for
> drivers that support it.
>
> The MCS, AMPDU, and AMSDU features that may be disabled are
> are reported in the phy-info netlink message as a mask.
>
> Attemping to disable features that are not supported will
> take no affect, but will not return errors.  This is to aid
> backwards compatibility in user-space apps that may not be
> clever enough to deal with parsing the the capabilities mask.
>
> This patch only enables the infrastructure.  An additional
> patch will enable the feature in mac80211.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
>
> * Removed DISABLE_HT40 variable..instead just modify ht-cap
>    flags to disable ht-40.
>
> * Mask out un-supported values.  Will not return error, but will
>    force driver to keep the mod-mask up to date if someone wants to
>    override additional features.
>
> :100644 100644 8049bf7... 5b86a3b... M	include/linux/nl80211.h
> :100644 100644 92cf1c2... cc7e995... M	include/net/cfg80211.h
> :100644 100644 b9ec306... dd6feda... M	net/wireless/core.h
> :100644 100644 21fc970... e0d3a50... M	net/wireless/mlme.c
> :100644 100644 48260c2... 80e5144... M	net/wireless/nl80211.c
> :100644 100644 6e86d5a... d144e2d... M	net/wireless/sme.c
>   include/linux/nl80211.h |    8 ++++++++
>   include/net/cfg80211.h  |   28 ++++++++++++++++++++++++++++
>   net/wireless/core.h     |    8 ++++++--
>   net/wireless/mlme.c     |   37 ++++++++++++++++++++++++++++++++++---
>   net/wireless/nl80211.c  |   44 +++++++++++++++++++++++++++++++++++++++++++-
>   net/wireless/sme.c      |    4 +++-
>   6 files changed, 122 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 8049bf7..5b86a3b 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1109,6 +1109,11 @@ enum nl80211_commands {
>    *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
>    *	used for asking the driver to perform a TDLS operation.
>    *
> + * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
> + *      this feature.
> + * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the HT_CAPs
> + *      to pay attention to.
> + *
>    * @NL80211_ATTR_MAX: highest attribute number currently defined
>    * @__NL80211_ATTR_AFTER_LAST: internal use
>    */
> @@ -1337,6 +1342,9 @@ enum nl80211_attrs {
>   	NL80211_ATTR_TDLS_SUPPORT,
>   	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
>
> +	NL80211_ATTR_DISABLE_HT,
> +	NL80211_ATTR_HT_CAPABILITY_MASK,
> +
>   	/* add attributes here, update the policy in nl80211.c */
>
>   	__NL80211_ATTR_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 92cf1c2..cc7e995 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1036,6 +1036,15 @@ struct cfg80211_auth_request {
>   };
>
>   /**
> + * enum cfg80211_assoc_req_flags - Over-ride default behaviour in association.
> + *
> + * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
> + */
> +enum cfg80211_assoc_req_flags {
> +	ASSOC_REQ_DISABLE_HT		= BIT(0),
> +};
> +
> +/**
>    * struct cfg80211_assoc_request - (Re)Association request data
>    *
>    * This structure provides information needed to complete IEEE 802.11
> @@ -1046,6 +1055,10 @@ struct cfg80211_auth_request {
>    * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
>    * @crypto: crypto settings
>    * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
> + * @flags:  See&enum cfg80211_assoc_req_flags
> + * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
> + *   will be used in ht_capa.  Un-supported values will be ignored.
> + * @ht_capa_mask:  The bits of ht_capa which are to be used.
>    */
>   struct cfg80211_assoc_request {
>   	struct cfg80211_bss *bss;
> @@ -1053,6 +1066,9 @@ struct cfg80211_assoc_request {
>   	size_t ie_len;
>   	struct cfg80211_crypto_settings crypto;
>   	bool use_mfp;
> +	u32 flags;
> +	struct ieee80211_ht_cap ht_capa;
> +	struct ieee80211_ht_cap ht_capa_mask;
>   };
>
>   /**
> @@ -1151,6 +1167,10 @@ struct cfg80211_ibss_params {
>    * @key_len: length of WEP key for shared key authentication
>    * @key_idx: index of WEP key for shared key authentication
>    * @key: WEP key for shared key authentication
> + * @flags:  See&enum cfg80211_assoc_req_flags
> + * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
> + *   will be used in ht_capa.  Un-supported values will be ignored.
> + * @ht_capa_mask:  The bits of ht_capa which are to be used.
>    */
>   struct cfg80211_connect_params {
>   	struct ieee80211_channel *channel;
> @@ -1164,6 +1184,9 @@ struct cfg80211_connect_params {
>   	struct cfg80211_crypto_settings crypto;
>   	const u8 *key;
>   	u8 key_len, key_idx;
> +	u32 flags;
> +	struct ieee80211_ht_cap ht_capa;
> +	struct ieee80211_ht_cap ht_capa_mask;
>   };
>
>   /**
> @@ -1903,6 +1926,9 @@ struct wiphy_wowlan_support {
>    *	may request, if implemented.
>    *
>    * @wowlan: WoWLAN support information
> + *
> + * @ht_capa_mod_msk:  Specify what ht_cap values can be over-ridden.
> + *	If null, then none can be over-ridden.
>    */
>   struct wiphy {
>   	/* assign these fields before you register the wiphy */
> @@ -1983,6 +2009,8 @@ struct wiphy {
>   	/* dir in debugfs: ieee80211/<wiphyname>  */
>   	struct dentry *debugfsdir;
>
> +	struct ieee80211_ht_cap *ht_capa_mod_mask;

Gah, this needs to be const..  I'll send a new patch with
this change shortly.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

