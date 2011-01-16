Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1APIep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 03:34:45 -0500
Subject: Re: [PATCH 04/10] mac80211: do not calc frame duration when using
 HW rate-control
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1295156534-4178-5-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-5-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 09:34:43 +0100
Message-ID: <1295166883.3574.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 07:42 +0200, Arik Nemtsov wrote:
> When rate-control is performed in HW, we cannot calculate frame
> duration as we do not have the skb transmission rate in SW.
> 
> ieee80211_tx_h_calculate_duration() should only be called when
> ieee80211_tx_h_rate_ctrl() has been called before to initialize data
> in skb->cb. This doesn't happen for drivers with HW rate-control.
> 
> Fixes the following warning when operating in AP-mode
> in a driver with HW rate-control.
> 
> <4>[16747.586029] WARNING: at net/mac80211/tx.c:57 ieee80211_duration
> +0x54/0x1d8 [mac80211]()
> <4>[16747.594085] Modules linked in: wl12xx_sdio wl12xx firmware_class crc7
> mac80211 cfg80211 [last unloaded: crc7]
> <4>[16747.604095] [<c004707c>] (unwind_backtrace+0x0/0x124) from [<c006644c>]
> (warn_slowpath_common+0x4c/0x64)
> <4>[16747.613616] [<c006644c>] (warn_slowpath_common+0x4c/0x64) from
> [<c006647c>] (warn_slowpath_null+0x18/0x1c)
> <4>[16747.623382] [<c006647c>] (warn_slowpath_null+0x18/0x1c) from [<bf1aa8e8>]
> (ieee80211_duration+0x54/0x1d8 [mac80211])
> <4>[16747.634124] [<bf1aa8e8>] (ieee80211_duration+0x54/0x1d8 [mac80211]) from
> [<bf1aacec>] (ieee80211_tx_h_calculate_duration+0x3c/0x5c [mac80211])
> <4>[16747.647094] [<bf1aacec>] (ieee80211_tx_h_calculate_duration+0x3c/0x5c
> [mac80211]) from [<bf1ab21c>] (invoke_tx_handlers+0xdc/0x118 [mac80211])
> <4>[16747.660064] [<bf1ab21c>] (invoke_tx_handlers+0xdc/0x118 [mac80211])
> from [<bf1ab2dc>] (ieee80211_tx+0x84/0x248 [mac80211])
> <4>[16747.671295] [<bf1ab2dc>] (ieee80211_tx+0x84/0x248 [mac80211]) from
> [<bf1abe3c>] (ieee80211_tx_pending+0x12c/0x278 [mac80211])
> <4>[16747.682739] [<bf1abe3c>] (ieee80211_tx_pending+0x12c/0x278 [mac80211])
> from [<c006b3bc>] (tasklet_action+0x68/0xc0)
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

though I wish the backtrace in your commit log wasn't all mangled and
word-wrapped.

johannes

> ---
>  net/mac80211/tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5950e3a..e0d6d5c 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1394,7 +1394,8 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
>  	/* handlers after fragment must be aware of tx info fragmentation! */
>  	CALL_TXH(ieee80211_tx_h_stats);
>  	CALL_TXH(ieee80211_tx_h_encrypt);
> -	CALL_TXH(ieee80211_tx_h_calculate_duration);
> +	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
> +		CALL_TXH(ieee80211_tx_h_calculate_duration);
>  #undef CALL_TXH
>  
>   txh_done:


