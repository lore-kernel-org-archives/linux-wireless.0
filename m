Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2CEV0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 16:26:11 -0500
Subject: Re: [PATCH v3 2/2] mac80211: fix mesh airtime link metric
 estimating
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1330982223-8379-2-git-send-email-thomas@cozybit.com> (sfid-20120305_221743_028947_F8F6C4E2)
References: <1330982223-8379-1-git-send-email-thomas@cozybit.com>
	 <1330982223-8379-2-git-send-email-thomas@cozybit.com>
	 (sfid-20120305_221743_028947_F8F6C4E2)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 22:26:07 +0100
Message-ID: <1330982767.3545.15.camel@jlt3.sipsolutions.net> (sfid-20120305_222614_551467_3027CAB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-05 at 13:17 -0800, Thomas Pedersen wrote:
> Airtime link metric estimation was broken in HT mesh, use
> cfg80211_calculate_bitrate to get the right rate value.
> 
> Also factor out tx rate copying from sta_set_sinfo().
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
> v2:
> factor out rate copying (Johannes)
> 
> v3:
> just factor out tx rate copying (Johannes)
> 
>  net/mac80211/cfg.c       |   22 ++++++++++++++--------
>  net/mac80211/mesh_hwmp.c |    6 ++++--
>  net/mac80211/sta_info.h  |    2 ++
>  3 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 6a77d4c..9e6accd 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -336,6 +336,19 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
>  		rate->mcs = idx;
>  }
>  
> +void sta_set_rate_info(struct sta_info *sta, struct ieee80211_tx_rate rate,
> +		       struct rate_info *rinfo)

I think passing a struct by value is rather expensive?

Also I think it should have "tx" somewhere in the name.

johannes


