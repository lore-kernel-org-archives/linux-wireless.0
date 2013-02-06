Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42157 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3BFSdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 13:33:09 -0500
Date: Wed, 06 Feb 2013 13:33:04 -0500 (EST)
Message-Id: <20130206.133304.809962323533002767.davem@davemloft.net> (sfid-20130206_193347_986835_93E4FA99)
To: dinggnu@gmail.com
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mac80211/cfg.c: fix error using of sizeof()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>
References: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cong Ding <dinggnu@gmail.com>
Date: Wed,  6 Feb 2013 17:23:45 +0100

> Using 'sizeof' on array given as function argument returns size of a pointer
> rather than the size of array.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  net/mac80211/cfg.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 661b878..af561d5 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2058,7 +2058,8 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
>  {
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  
> -	memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));
> +	memcpy(sdata->vif.bss_conf.mcast_rate, rate,
> +			sizeof(int) * IEEE80211_NUM_BANDS);
>  

This is not indented properly.  The "sizeof(int..." should start at the
first column after the openning parenthesis of the memcpy() call.
