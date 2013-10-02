Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3JBIzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:55:12 -0400
Message-ID: <1380704100.13329.6.camel@jlt4.sipsolutions.net> (sfid-20131002_105516_056468_F2CFD656)
Subject: Re: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linville@tuxdriver.com, simon.wunderlich@s2003.tu-chemnitz.de,
	linux-wireless@vger.kernel.org
Date: Wed, 02 Oct 2013 10:55:00 +0200
In-Reply-To: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20130930_145233_687067_9A90422E)
References: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20130930_145233_687067_9A90422E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 14:52 +0200, Lorenzo Bianconi wrote:
> Allow management frame injection on DFS channels if the channel has been CAC
> checked and is available

> +++ b/net/mac80211/tx.c
> @@ -1694,8 +1694,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  	 * radar detection by itself. We can do that later by adding a
>  	 * monitor flag interfaces used for AP support.
>  	 */
> -	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
> -			    IEEE80211_CHAN_PASSIVE_SCAN)))
> +	if (((chan->flags & (IEEE80211_CHAN_PASSIVE_SCAN |
> +			     IEEE80211_CHAN_NO_IBSS))) ||
> +	    ((chan->flags & IEEE80211_CHAN_RADAR) &&
> +	     chan->dfs_state != NL80211_DFS_AVAILABLE))

This would be the only place where mac80211 is accessing
chan->dfs_state, does that make sense? Why is it not needed elsewhere?

johannes

