Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34409 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab2BHTbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 14:31:39 -0500
Date: Wed, 8 Feb 2012 14:25:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	arend@broadcom.com
Subject: Re: [PATCH] mac80211: do not call rate control .tx_status before
 .rate_init
Message-ID: <20120208192536.GB2929@tuxdriver.com> (sfid-20120208_203142_642953_E32E31B7)
References: <1328725031-35464-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328725031-35464-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 08, 2012 at 07:17:11PM +0100, Felix Fietkau wrote:
> Most rate control implementations assume .get_rate and .tx_status are only
> called once the per-station data has been fully initialized.
> minstrel_ht crashes if this assumption is violated.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Tested-by: Arend van Spriel <arend@broadcom.com>
> ---
>  net/mac80211/rate.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
> index 5fc3135..fbb1efd 100644
> --- a/net/mac80211/rate.h
> +++ b/net/mac80211/rate.h
> @@ -37,7 +37,7 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
>  	struct ieee80211_sta *ista = &sta->sta;
>  	void *priv_sta = sta->rate_ctrl_priv;
>  
> -	if (!ref)
> +	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
>  		return;
>  
>  	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);

Any reason not to apply this for 3.3?  Or stable?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
