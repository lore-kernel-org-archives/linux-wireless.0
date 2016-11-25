Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752658AbcKYIod (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 03:44:33 -0500
Message-ID: <1480063462.2517.105.camel@coelho.fi> (sfid-20161125_094504_982808_3C269702)
From: Luca Coelho <luca@coelho.fi>
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Vamsi Krishna <vamsin@qti.qualcomm.com>
Date: Fri, 25 Nov 2016 10:44:22 +0200
In-Reply-To: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 1/2] nl80211: Use different attrs for BSSID and random
 MAC addr in scan req
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-24 at 00:07 +0200, Jouni Malinen wrote:
> From: Vamsi Krishna <vamsin@qti.qualcomm.com>
> 
> NL80211_ATTR_MAC was used to set both the specific BSSID to be scanned
> and the random MAC address to be used when privacy is enabled. When both
> the features are enabled, both the BSSID and the local MAC address were
> getting same value causing Probe Request frames to go with unintended
> DA. Hence, this has been fixed by using a different NL80211_ATTR_BSSID
> attribute to set the specific BSSID (which was the more recent addition
> in cfg80211) for a scan.
> 
> Backwards compatibility with old userspace software is maintained to
> some extend by allowing NL80211_ATTR_MAC to be used to set the specific

typo, extent

> BSSID when scanning without enabling random MAC address use.

Hopefully nobody expects the broken functionality to be the correct
behavior, so we can slightly break backwards compatibility.


> Scanning with random source MAC address was introduced by commit
> ad2b26abc157 ("cfg80211: allow drivers to support random MAC addresses
> for scan") and the issue was introduced with the addition of the second
> user for the same attribute in commit 818965d39177 ("cfg80211: Allow a
> scan request for a specific BSSID").
> 
> Fixes: 818965d39177 ("cfg80211: Allow a scan request for a specific BSSID")
> Signed-off-by: Vamsi Krishna <vamsin@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---




> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 259c9c7..984a35ac 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h

[...]

> @@ -1977,6 +1977,10 @@ enum nl80211_commands {
>   * @NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED: Indicates whether or not multicast
>   *	packets should be send out as unicast to all stations (flag attribute).
>   *
> + * @NL80211_ATTR_BSSID: The BSSID of the AP (various uses). Note that

The BSSID may also be used for other things, like P2P GO, right? Also
"various uses" is probably unnecessary? Every command using this
attribute should describe it's use in their description.


> + *	%NL80211_ATTR_MAC has also been used in various commands/events for
> + *	specifying the BSSID.

This can be a bit confusing.  Maybe you can specify which commands
*used* to use NL80211_ATTR_MAC but now use NL80211_ATTR_BSSID?

[...]

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index e4f718e..8db5cb1 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c

[...]

> @@ -6703,7 +6704,20 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
>  	request->no_cck =
>  		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
>  
> -	if (info->attrs[NL80211_ATTR_MAC])
> +	/* Initial implementation used NL80211_ATTR_MAC to set the specific
> +	 * BSSID to scan for. This was problematic because that same attribute
> +	 * was already used for another purpose (local random MAC address). The
> +	 * NL80211_ATTR_BSSID attribute was added to fix this. For backwards
> +	 * compatibility with older userspace components, also use the
> +	 * NL80211_ATTR_MAC value here if it can be determined to be used for
> +	 * the specific BSSID use case instead of the random MAC address
> +	 * (NL80211_ATTR_SCAN_FLAGS is used to enable random MAC address use).
> +	 */

You should probably add this information to the
NL80211_CMD_TRIGGER_SCAN description.


> +	if (info->attrs[NL80211_ATTR_BSSID])
> +		memcpy(request->bssid,
> +		       nla_data(info->attrs[NL80211_ATTR_BSSID]), ETH_ALEN);
> +	else if (!info->attrs[NL80211_ATTR_SCAN_FLAGS] &&

You should actually check that the SCAN_FLAGS attribute either doesn't
exist (as you already do) or, if it exists, that it doesn't have the
NL80211_SCAN_FLAG_RANDOM_ADDR flags.


--
Cheers,
Luca.
