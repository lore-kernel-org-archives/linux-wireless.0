Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36848 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaI1WIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2014 18:08:21 -0400
Received: by mail-wg0-f52.google.com with SMTP id n12so10470011wgh.35
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2014 15:08:19 -0700 (PDT)
Date: Mon, 29 Sep 2014 00:08:03 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, nbd@nbd.name, ikstream86@gmail.com
Subject: Re: [PATCH v2 2/2] mac80211: improve minstrel_ht rate sorting by
 throughput & probability
Message-ID: <20140928220803.GA28168@gobelin> (sfid-20140929_000832_226428_B23C23B9)
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 09, 2014 at 11:22:14PM +0200, Thomas Huehn wrote:
> This patch improves the way minstrel_ht sorts rates according to throughput
> and success probability. 3 FOR-loops across the entire rate and mcs group set
> in function minstrel_ht_update_stats() which where used to determine the
> fastest, second fastest and most robust rate are reduced to 2 FOR-loop.
> 
> The sorted list of rates according throughput is extended to the best four
> rates as we need them in upcoming joint rate and power control. The sorting
> is done via the new function minstrel_ht_sort_best_tp_rates(). The annotation
> of those 4 best throughput rates in the debugfs file rc-stats is changes to:
> "A,B,C,D", where A is the fastest rate and C the 4th fastest.
> 
> ---
> v2: fix coding style issues, thx the Felix Fietkau
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Tested-by: Stefan Venz <ikstream86@gmail.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c         | 303 +++++++++++++++++++----------
>  net/mac80211/rc80211_minstrel_ht.h         |  19 +-
>  net/mac80211/rc80211_minstrel_ht_debugfs.c |  10 +-
>  3 files changed, 213 insertions(+), 119 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 85c1e74..df90ce2 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -135,7 +135,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi);
>  static int
>  minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
>  {
> -	return GROUP_IDX((rate->idx / 8) + 1,
> +	return GROUP_IDX((rate->idx / MCS_GROUP_RATES) + 1,
>  			 !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
>  			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
>  }

Hi,

Here you should have kept 8, GROUP_IDX requires the number of streams.
I will rebase the vht RFC I sent a year ago tonight and also send the
fix for 7a5e3fa breakage.
 
Karl
