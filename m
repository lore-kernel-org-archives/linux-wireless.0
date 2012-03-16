Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2CPIuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 04:50:51 -0400
Subject: Re: [PATCH 1/4] cfg80211:  Add framework to support ethtool stats.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331853606-28434-1-git-send-email-greearb@candelatech.com> (sfid-20120316_002021_164291_232D4D9B)
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120316_002021_164291_232D4D9B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 09:50:48 +0100
Message-ID: <1331887848.3435.0.camel@jlt3.sipsolutions.net> (sfid-20120316_095101_788120_810812B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 16:20 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 9ed8021... d97c9da... M	include/net/cfg80211.h
> :100644 100644 9bde4d1... 7eecdf4... M	net/wireless/ethtool.c
>  include/net/cfg80211.h |    7 +++++++
>  net/wireless/ethtool.c |   29 +++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9ed8021..d97c9da 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1689,6 +1689,13 @@ struct cfg80211_ops {
>  				  u16 noack_map);
>  
>  	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
> +
> +	int	(*get_et_sset_count)(struct wiphy *wiphy,
> +				     struct net_device* dev, int sset);

Do I really have to point out that the space should be before the
asterisk? ;-)

johannes


