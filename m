Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1KHNOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 08:14:23 -0500
Subject: Re: [PATCH 3/3] mac80211: simplify ieee80211_work_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320313247-23167-3-git-send-email-sgruszka@redhat.com>
References: <1320313247-23167-1-git-send-email-sgruszka@redhat.com>
	 <1320313247-23167-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 14:14:19 +0100
Message-ID: <1320758059.4304.32.camel@jlt3.sipsolutions.net> (sfid-20111108_141425_637505_EA429BED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 10:40 +0100, Stanislaw Gruszka wrote:
> Since local->tmp_channel is always NULL in one branch, some code paths
> will newer be taken in that branch, so remove them.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  net/mac80211/work.c |   17 +++--------------
>  1 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 6c53b6d..788b96e 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -969,10 +969,9 @@ static void ieee80211_work_work(struct work_struct *work)
>  		}
>  
>  		if (!started && !local->tmp_channel) {
> -			bool on_oper_chan;
> -			bool tmp_chan_changed = false;
> -			bool on_oper_chan2;
> +			bool on_oper_chan, on_oper_chan2;
>  			enum nl80211_channel_type wk_ct;
> +
>  			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>  
>  			/* Work with existing channel type if possible. */
> @@ -981,11 +980,6 @@ static void ieee80211_work_work(struct work_struct *work)
>  				wk_ct = ieee80211_calc_ct(wk->chan_type,
>  						local->hw.conf.channel_type);
>  
> -			if (local->tmp_channel)
> -				if ((local->tmp_channel != wk->chan) ||
> -				    (local->tmp_channel_type != wk_ct))
> -					tmp_chan_changed = true;
> -
>  			local->tmp_channel = wk->chan;
>  			local->tmp_channel_type = wk_ct;
>  			/*
> @@ -1008,12 +1002,7 @@ static void ieee80211_work_work(struct work_struct *work)
>  								    true,
>  								    false);
>  				}
> -			} else if (tmp_chan_changed)
> -				/* Still off-channel, but on some other
> -				 * channel, so update hardware.
> -				 * PS should already be off-channel.
> -				 */
> -				ieee80211_hw_config(local, 0);
> +			}
>  
>  			started = true;
>  			wk->timeout = jiffies;


