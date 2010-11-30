Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab0K3LZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 06:25:56 -0500
Subject: Re: [PATCH] mac80211: Minor optimization in ieee80211_rx_h_data
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1291115974-4878-1-git-send-email-helmut.schaa@googlemail.com>
References: <1291115974-4878-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 12:25:51 +0100
Message-ID: <1291116351.3624.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 12:19 +0100, Helmut Schaa wrote:
> Remove a superfluous ieee80211_is_data check as that was checked a few
> lines before already and we wont't get here for non-data frames at all.
> 
> Second, the frame was already converted to 802.3 header format and
> reading the fc and addr1 fields was only possible because the 802.3
> header is short enough and didn't overwrite the relevant parts of the
> 802.11 header. Make the code more obvious by checking the ethernet
> header's h_dest field.
> 
> Furthermore reorder the conditions to reduce the number of checks
> when dynamic powersave is not needed (AP mode for example).
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Looks sane to me. Indeed if the check was required it should use the
"fc" variable, but clearly it's pointless. Must be some code that got
moved during PS code restructuring...

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> 
> Found via code review, compile tested only.
> 
>  net/mac80211/rx.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 9dd60a7..9e44fbf 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1871,9 +1871,8 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>  	dev->stats.rx_packets++;
>  	dev->stats.rx_bytes += rx->skb->len;
>  
> -	if (ieee80211_is_data(hdr->frame_control) &&
> -	    !is_multicast_ether_addr(hdr->addr1) &&
> -	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
> +	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 && 
> +	    !is_multicast_ether_addr(((struct ethhdr *)rx->skb->data)->h_dest)) {
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>  	}


