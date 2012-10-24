Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51068 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab2JXQ16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 12:27:58 -0400
Message-ID: <50881709.4050405@candelatech.com> (sfid-20121024_182802_049529_23C5FCA5)
Date: Wed, 24 Oct 2012 09:27:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/4] cfg80211: make TX power setting per interface
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net> <1351073603-11616-3-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1351073603-11616-3-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 03:13 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The TX power setting is currently per wiphy (hardware
> device) but with multi-channel capabilities that doesn't
> make much sense any more.
>
> Unfortunately, by making it per interface, we loose some
> backward compatibility with userspace, but that isn't a
> big issue since userspace must already accept that not
> all drivers support TX power setting, and mostly uses a
> netdev to identify the hardware anyway.
>

> @@ -1971,6 +1971,7 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
>   }
>
>   static int ieee80211_set_tx_power(struct wiphy *wiphy,
> +				  struct wireless_dev *wdev,
>   				  enum nl80211_tx_power_setting type, int mbm)
>   {
>   	struct ieee80211_local *local = wiphy_priv(wiphy);
> @@ -2005,7 +2006,9 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
>   	return 0;
>   }
>
> -static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
> +static int ieee80211_get_tx_power(struct wiphy *wiphy,
> +				  struct wireless_dev *wdev,
> +				  int *dbm)
>   {
>   	struct ieee80211_local *local = wiphy_priv(wiphy);

Do we really set mbm and read back dbm?


>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 879ca62..24175e2 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1588,6 +1588,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>   		enum nl80211_tx_power_setting type;
>   		int idx, mbm = 0;
>
> +		if (!wdev) {
> +			result = -EOPNOTSUPP;
> +			goto bad_res;
> +		}

I guess this is the part that breaks backwards compat when trying to set wiphy?
If it does stay like this, maybe add a WARN_ON_ONCE that tells users to fix their
user-space?

Too bad there is not an -EUSEVIFINSTEAD :P

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

