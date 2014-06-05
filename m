Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8416 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbaFEXQV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 19:16:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 5 Jun 2014 16:16:11 -0700
Subject: RE: [PATCH] cfg80211: make ethtool the driver's responsibility
Message-ID: <477F20668A386D41ADCC57781B1F70430FE1BF2FB7@SC-VEXCH1.marvell.com> (sfid-20140606_011625_221592_8B574B0C)
References: <1401896290-12942-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1401896290-12942-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 920ec8c1ce54..5c17b1f71dd4 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2278,16 +2278,6 @@ struct cfg80211_qos_map {
>   *
>   * @set_noack_map: Set the NoAck Map for the TIDs.
>   *
> - * @get_et_sset_count:  Ethtool API to get string-set count.
> - *	See @ethtool_ops.get_sset_count
> - *
> - * @get_et_stats:  Ethtool API to get a set of u64 stats.
> - *	See @ethtool_ops.get_ethtool_stats
> - *
> - * @get_et_strings:  Ethtool API to get a set of strings to describe stats
> - *	and perhaps other supported types of ethtool data-sets.
> - *	See @ethtool_ops.get_strings
> - *
>   * @get_channel: Get the current operating channel for the virtual interface.
>   *	For monitor interfaces, it should return %NULL unless there's a single
>   *	current monitoring channel.
> @@ -2529,13 +2519,6 @@ struct cfg80211_ops {
>  				  struct net_device *dev,
>  				  u16 noack_map);
> 
> -	int	(*get_et_sset_count)(struct wiphy *wiphy,
> -				     struct net_device *dev, int sset);
> -	void	(*get_et_stats)(struct wiphy *wiphy, struct net_device *dev,
> -				struct ethtool_stats *stats, u64 *data);
> -	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
> -				  u32 sset, u8 *data);
> -
>  	int	(*get_channel)(struct wiphy *wiphy,
>  			       struct wireless_dev *wdev,
>  			       struct cfg80211_chan_def *chandef);

Amitkumar found that set_ringparam and get_ringparam are forgotten to be removed from cfg80211_ops.

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dc93c6b..29cb4b2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2266,10 +2266,6 @@ struct cfg80211_qos_map {
  *
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
  *
- * @set_ringparam: Set tx and rx ring sizes.
- *
- * @get_ringparam: Get tx and rx ring current and maximum sizes.
- *
  * @tdls_mgmt: Transmit a TDLS management frame.
  * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
  *
@@ -2493,10 +2489,6 @@ struct cfg80211_ops {
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
 	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
 
-	int	(*set_ringparam)(struct wiphy *wiphy, u32 tx, u32 rx);
-	void	(*get_ringparam)(struct wiphy *wiphy,
-				 u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
-
 	int	(*sched_scan_start)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_sched_scan_request *request);


Thanks,
Bing

