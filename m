Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3HAHoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 03:44:34 -0400
Message-ID: <1375343068.8608.11.camel@jlt4.sipsolutions.net> (sfid-20130801_094437_702931_B83A4015)
Subject: Re: [PATCH] mac80211: allow lowest basic rate for unicast
 management frame in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Thu, 01 Aug 2013 09:44:28 +0200
In-Reply-To: <1375148892-18121-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130730_034821_964354_C1059677)
References: <1375148892-18121-1-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130730_034821_964354_C1059677)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-29 at 18:48 -0700, Chun-Yeow Yeoh wrote:
> Allow lowest basic rate to be used for unicast management frame in
> mesh. Otherwise, the lowest supported rate is used for unicast
> management frame, such as 1Mbps for 2.4GHz and 6Mbps for 5GHz. Rename
> the rc_send_low_broadcast to re_send_low_basicrate since now it is
> also applied to unicast management frame in mesh.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> ---
>  net/mac80211/rate.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index ba63ac8..8038d47 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -210,7 +210,7 @@ static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
>  		!ieee80211_is_data(fc);
>  }
>  
> -static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
> +static void rc_send_low_basicrate(s8 *idx, u32 basic_rates,
>  				  struct ieee80211_supported_band *sband)
>  {
>  	u8 i;
> @@ -269,6 +269,7 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
>  {
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
>  	struct ieee80211_supported_band *sband = txrc->sband;
> +	struct sta_info *sta_mesh = container_of(sta, struct sta_info, sta);

That doesn't seem like a good idea - IMHO you shouldn't use container_of
on NULL even if it still works in the end.

Also it might be a good idea to use more regular names: struct
ieee80211_sta *pubsta, struct sta_info *sta.


> @@ -281,10 +282,16 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
>  				return true;
>  			}
>  
> -			rc_send_low_broadcast(&info->control.rates[0].idx,
> +			rc_send_low_basicrate(&info->control.rates[0].idx,
>  					      txrc->bss_conf->basic_rates,
>  					      sband);
>  		}
> +
> +		if (sta && ieee80211_vif_is_mesh(&sta_mesh->sdata->vif))
> +			rc_send_low_basicrate(&info->control.rates[0].idx,
> +					      txrc->bss_conf->basic_rates,
> +					      sband);

I don't get this - that just duplicates the code above, no chance to
refactor it a bit instead of duplicating the call?

johannes

