Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3FKLxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:53:24 -0400
Message-ID: <1370951598.8356.21.camel@jlt4.sipsolutions.net> (sfid-20130611_135327_157869_34A0B6D4)
Subject: Re: [PATCHv4 4/4] nl80211: allow sending CMD_FRAME without
 specifying any frequency
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 11 Jun 2013 13:53:18 +0200
In-Reply-To: <1370444989-2095-4-git-send-email-ordex@autistici.org>
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
	 <1370444989-2095-4-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-05 at 17:09 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Users may want to send a frame on the current channel
> without specifying it.
> 
> This is particularly useful for the correct implementation
> of the IBSS/RSN support in wpa_supplicant which requires to
> receive and send AUTH frames.
> 
> Make mgmt_tx pass a NULL channel to the driver if none has
> been specified by the user.
> 
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
> 
> v3:
> - moved from 1/4 to 4/4
> 
> 
>  net/wireless/nl80211.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 88e820b..06af395 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -7139,6 +7139,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
>  		return -EOPNOTSUPP;
>  
>  	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_P2P_DEVICE:
> +		if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
> +			return -EINVAL;
>  	case NL80211_IFTYPE_STATION:
>  	case NL80211_IFTYPE_ADHOC:
>  	case NL80211_IFTYPE_P2P_CLIENT:
> @@ -7146,7 +7149,6 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
>  	case NL80211_IFTYPE_AP_VLAN:
>  	case NL80211_IFTYPE_MESH_POINT:
>  	case NL80211_IFTYPE_P2P_GO:
> -	case NL80211_IFTYPE_P2P_DEVICE:
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> @@ -7174,9 +7176,15 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
>  
>  	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
>  
> -	err = nl80211_parse_chandef(rdev, info, &chandef);
> -	if (err)
> -		return err;
> +	/* get the channel if any has been specified, otherwise pass NULL to
> +	 * the driver. The latter will use the current one
> +	 */
> +	chandef.chan = NULL;
> +	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
> +		err = nl80211_parse_chandef(rdev, info, &chandef);
> +		if (err)
> +			return err;
> +	}

I think not specifying a channel but setting
NL80211_ATTR_OFFCHANNEL_TX_OK must be an error.

johannes

