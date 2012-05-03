Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2ECSzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:55:09 -0400
Message-ID: <1336071305.5167.5.camel@jlt3.sipsolutions.net> (sfid-20120503_205537_968409_5CB87CEC)
Subject: Re: [PATCH 2/2] mac80211: don't transmit 40MHz frames to 20MHz peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Thu, 03 May 2012 20:55:05 +0200
In-Reply-To: <1335477667-1625-2-git-send-email-thomas@cozybit.com> (sfid-20120427_000151_701205_D5FEC418)
References: <1335477667-1625-1-git-send-email-thomas@cozybit.com>
	 <1335477667-1625-2-git-send-email-thomas@cozybit.com>
	 (sfid-20120427_000151_701205_D5FEC418)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-26 at 15:01 -0700, Thomas Pedersen wrote:
> If a mesh peer indicates it is operating as 20MHz-only in its HT
> operation IE, have the rate control algorithm respect this by disabling
> the equivalent bit in the ieee80211_sta HT capabilities.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh_plink.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index f4124d7..6209327 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -302,6 +302,12 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>  	else
>  		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
>  
> +	if (elems->ht_operation)
> +		if (!(elems->ht_operation->ht_param &
> +		      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
> +			sta->sta.ht_cap.cap &=
> +					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;

The double if is a bit odd, why not use && to clean up all the
formatting?

johannes

