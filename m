Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1KGIuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 03:50:10 -0500
Subject: Re: [PATCH] mac80211: uAPSD - fix IEEE80211_FCTL_MOREDATA bit
 setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz.Dziedzic@tieto.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3078A9B976EF864C8DDD0C499FFD07911E3B56E1EC@EXMB01.eu.tieto.com>
References: <3078A9B976EF864C8DDD0C499FFD07911E3B56E1EC@EXMB01.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 09:50:08 +0100
Message-ID: <1320655808.3993.13.camel@jlt3.sipsolutions.net> (sfid-20111107_095014_978476_DA39839E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 09:47 +0200, Janusz.Dziedzic@tieto.com wrote:
> Set IEEE80211_FCTL_MOREDATA bit also in case we have buffered
> frames (more than one) only for one AC.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

> ---
>  net/mac80211/sta_info.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index ce962d2..8eaa746 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1354,12 +1354,12 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
>  			 * Use MoreData flag to indicate whether there are
>  			 * more buffered frames for this STA
>  			 */
> -			if (!more_data)
> -				hdr->frame_control &=
> -					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
> -			else
> +			if (more_data || !skb_queue_empty(&frames))
>  				hdr->frame_control |=
>  					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
> +			else
> +				hdr->frame_control &=
> +					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
>  
>  			if (ieee80211_is_data_qos(hdr->frame_control) ||
>  			    ieee80211_is_qos_nullfunc(hdr->frame_control))


