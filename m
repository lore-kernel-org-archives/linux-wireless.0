Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:50641 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbbAPKtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:49:31 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC 1/2] nl80211: support per-rate/per-station statistics
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 16 Jan 2015 11:49:20 +0100
In-Reply-To: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Fri, 16 Jan 2015 10:48:27 +0100")
Message-ID: <874mrrvw3z.fsf@nemi.mork.no> (sfid-20150116_114934_775140_C40199D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> +void cfg80211_report_rate_stats(struct wiphy *wiphy, struct wireless_dev *wdev,
> +				const u8 *addr, unsigned int n_stats,
> +				struct cfg80211_rate_stats *stats, gfp_t gfp);
> +
>  /* ethtool helper */
>  void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
>  
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index f52797a90816..d03e3caef505 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -35,6 +35,7 @@
>  #define NL80211_MULTICAST_GROUP_MLME		"mlme"
>  #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
>  #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
> +#define NL80211_MULTICAST_GROUP_RATESTATS	"rate-stats"
>  
>  /**
>   * DOC: Station handling
> @@ -796,6 +797,10 @@
>   *	as an event to indicate changes for devices with wiphy-specific regdom
>   *	management.
>   *
> + * @NL80211_CMD_GET_RATE_STATISTICS: This command can be used to trigger the

So in a few lines we have all these phrases describing the same feature
in different contexts (3 of which are different even after ignoring
casing and _/- translation):

 rate_stats
 RATESTATS
 rate-stats
 RATE_STATISTICS

How about sticking to one phrase to avoid having to look these up every
time you use them? 

I don't care too much about which one it would be. But if I were to
choose, I would have gone for the shortest one: RATESTATS. It also has
the advantage that you don't need the _/- translation, which avoids
another possible confusion.


Bjørn
