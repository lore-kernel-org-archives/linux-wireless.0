Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2B1Njk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 08:39:40 -0500
Subject: Re: [PATCH v2] {nl,cfg,mac}80211: Implement RSSI threshold for
 mesh peering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1330382334-3899-1-git-send-email-ashok@cozybit.com> (sfid-20120227_233912_786633_B303BFEB)
References: <1330382334-3899-1-git-send-email-ashok@cozybit.com>
	 (sfid-20120227_233912_786633_B303BFEB)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 14:39:37 +0100
Message-ID: <1330436377.3368.2.camel@jlt3.sipsolutions.net> (sfid-20120228_143943_736889_472E4DF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 14:38 -0800, Ashok Nagarajan wrote:
> Mesh peer links are established only if average rssi of the peer
> candidate satisfies the threshold. This is not in 802.11s specification
> but was requested by David Fulgham, an open80211s user. This is a way to avoid
> marginal peer links with stations that are barely within range.
> 
> This patch adds a new mesh configuration parameter, mesh_rssi_threshold.
> 
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
> v2: create mesh-specific rssi_threshold parameter (Johannes)
> 
>  include/linux/nl80211.h       |    4 ++++
>  include/net/cfg80211.h        |    1 +
>  net/mac80211/cfg.c            |    2 ++
>  net/mac80211/debugfs_netdev.c |    2 ++
>  net/mac80211/mesh_plink.c     |   22 +++++++++++++++++++++-
>  net/wireless/mesh.c           |    3 +++
>  net/wireless/nl80211.c        |    5 +++++
>  7 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index be35a68..0a05d17 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -2112,6 +2112,9 @@ enum nl80211_mntr_flags {
>   * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
>   * or forwarding entity (default is TRUE - forwarding entity)
>   *
> + * @NL80211_MESHCONF_RSSI_THRESHOLD: specifies the threshold for average signal
> + * strength of candidate station to establish a peer link.

Please specify the unit. I don't actually know what the unit is -- it
seems to be either dBm or "unspec" when you compare it to avg_signal, so
it's hardware dependent -- to me that doesn't sound like a good idea.

Maybe this should work only for devices that report dBm?

johannes

