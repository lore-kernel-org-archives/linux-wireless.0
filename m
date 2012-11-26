Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2KZPHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 10:07:44 -0500
Message-ID: <1353942490.2800.0.camel@jlt4.sipsolutions.net> (sfid-20121126_160747_834637_9A197F59)
Subject: Re: [RFC] mac80211: re-organize the rx rate calculation logic
From: Johannes Berg <johannes@sipsolutions.net>
To: saravanad@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 16:08:10 +0100
In-Reply-To: <d4c0566bd33c1afdcc0f7b820024d19f@posedge.com>
References: <d4c0566bd33c1afdcc0f7b820024d19f@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 04:17 -0800, saravanad@posedge.com wrote:
> Mac80211: currently the logic to calculate the rx rate is accessible 
> only in the cfg.c as the rate_idx_to_bitrate() is static function.
> The rx rate calculation might be needed by other files(modules) of 
> mac80211(possibly debugfs). So grouping the rx rate calculation logic to
> a separate function which can be accessed from other files. This change 
> will make the rx rate calculation implementation similar to tx rate.

Generally, this seems fine. Your patches are line-wrapped though.

> Signed-off-by: Saravana <saravanad@posedge.com>
> ---
> The diff file is generated from wireless-testing git tree.

I just changed this code in mac80211-next and would appreciate if you
would rebase onto that.

> +void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info 
> *rinfo)
> +{
> +	rinfo->flags = 0;
> +	if (sta->last_rx_rate_flag & RX_FLAG_HT)
> +		rinfo->flags |= RATE_INFO_FLAGS_MCS;
> +	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
> +		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
> +	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
> +		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
> +	rate_idx_to_bitrate(rinfo, sta, sta->last_rx_rate_idx);
> +
> +}
>   static void sta_set_sinfo(struct sta_info *sta, struct station_info 
> *sinfo)

That blank line is in the wrong spot, it should be after the closing
bracket :)

johannes

