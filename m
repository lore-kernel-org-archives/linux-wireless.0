Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58179 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032435Ab2CPKHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 06:07:00 -0400
Received: by bkcik5 with SMTP id ik5so2765423bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 03:06:59 -0700 (PDT)
Message-ID: <4F631087.4040509@openwrt.org> (sfid-20120316_110711_615502_1C777158)
Date: Fri, 16 Mar 2012 11:05:59 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] cfg80211:  Add framework to support ethtool stats.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1331853606-28434-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Le 03/16/12 00:20, greearb@candelatech.com a écrit :
> From: Ben Greear<greearb@candelatech.com>
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> :100644 100644 9ed8021... d97c9da... M	include/net/cfg80211.h
> :100644 100644 9bde4d1... 7eecdf4... M	net/wireless/ethtool.c
>   include/net/cfg80211.h |    7 +++++++
>   net/wireless/ethtool.c |   29 +++++++++++++++++++++++++++++
>   2 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9ed8021..d97c9da 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1689,6 +1689,13 @@ struct cfg80211_ops {
>   				  u16 noack_map);
>
>   	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
> +
> +	int	(*get_et_sset_count)(struct wiphy *wiphy,
> +				     struct net_device* dev, int sset);
> +	void	(*get_et_stats)(struct wiphy *wiphy, struct net_device* dev,
> +				struct ethtool_stats *stats, u64 *data);
> +	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device* dev,
> +				  u32 sset, u8 *data);
>   };
>
>   /*
> diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
> index 9bde4d1..7eecdf4 100644
> --- a/net/wireless/ethtool.c
> +++ b/net/wireless/ethtool.c
> @@ -68,6 +68,32 @@ static int cfg80211_set_ringparam(struct net_device *dev,
>   	return -ENOTSUPP;
>   }
>
> +static int cfg80211_get_sset_count(struct net_device *dev, int sset)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +	if (rdev->ops->get_et_sset_count)
> +		return rdev->ops->get_et_sset_count(wdev->wiphy, dev, sset);
> +	return -EOPNOTSUPP;
> +}
> +
> +static void cfg80211_get_stats(struct net_device *dev,
> +			       struct ethtool_stats *stats, u64 *data)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +	if (rdev->ops->get_et_stats)
> +		rdev->ops->get_et_stats(wdev->wiphy, dev, stats, data);
> +}
> +
> +static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +	if (rdev->ops->get_et_strings)
> +		rdev->ops->get_et_strings(wdev->wiphy, dev, sset, data);
> +}
> +
>   const struct ethtool_ops cfg80211_ethtool_ops = {
>   	.get_drvinfo = cfg80211_get_drvinfo,
>   	.get_regs_len = cfg80211_get_regs_len,
> @@ -75,4 +101,7 @@ const struct ethtool_ops cfg80211_ethtool_ops = {
>   	.get_link = ethtool_op_get_link,
>   	.get_ringparam = cfg80211_get_ringparam,
>   	.set_ringparam = cfg80211_set_ringparam,
> +	.get_strings = cfg80211_get_strings,
> +	.get_ethtool_stats = cfg80211_get_stats,
> +	.get_sset_count = cfg80211_get_sset_count,
>   };

I do not think this is particularly a good idea to make eththool report 
wireless interfaces statistics:
- these are 802.11 interfaces and so they have specific statistics to 
report which are different from pure ethernet adapters
- people will start adding more statistics to ethtool because this or 
that wifi-specific counter is not reported, it is abusing the tool imho.
--
Florian
