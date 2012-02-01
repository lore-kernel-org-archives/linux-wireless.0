Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab2BAPwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 10:52:09 -0500
Subject: Re: [PATCH] mac80211: timeout a single frame in the rx reorder
 buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328098003-28004-1-git-send-email-eliad@wizery.com> (sfid-20120201_130345_843848_445F69E2)
References: <1328098003-28004-1-git-send-email-eliad@wizery.com>
	 (sfid-20120201_130345_843848_445F69E2)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 07:51:59 -0800
Message-ID: <1328111519.3297.0.camel@jlt3.sipsolutions.net> (sfid-20120201_165213_406595_2D6E8C30)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-01 at 14:06 +0200, Eliad Peller wrote:
> The current code checks for stored_mpdu_num > 1, causing
> the reorder_timer to be triggered indefinitely, but the
> frame is never timed-out (until the next packet is received)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Looks kinda obvious & trivial, want to CC stable?

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/rx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index f407427..7e3980f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -611,7 +611,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
>  	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
>  						tid_agg_rx->buf_size;
>  	if (!tid_agg_rx->reorder_buf[index] &&
> -	    tid_agg_rx->stored_mpdu_num > 1) {
> +	    tid_agg_rx->stored_mpdu_num) {
>  		/*
>  		 * No buffers ready to be released, but check whether any
>  		 * frames in the reorder buffer have timed out.


