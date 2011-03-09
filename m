Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab1CIQqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 11:46:53 -0500
Subject: Re: [PATCH 1/3] wireless: add support for
 ethtool_ops->{get,set}_ringparam
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	me@bobcopeland.com, mickflemm@gmail.com
In-Reply-To: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
References: <1299687684-19638-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 17:46:51 +0100
Message-ID: <1299689211.23764.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-09 at 11:21 -0500, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  include/net/cfg80211.h |    4 ++++
>  net/wireless/ethtool.c |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 1ac5786..25f546f 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1364,6 +1364,10 @@ struct cfg80211_ops {
>  
>  	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
>  	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
> +
> +	int	(*set_ringparam)(struct wiphy *wiphy, u32 tx, u32 rx);
> +	void	(*get_ringparam)(struct wiphy *wiphy,
> +				 u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);

Can you add docs here and in mac80211 please?

johannes

