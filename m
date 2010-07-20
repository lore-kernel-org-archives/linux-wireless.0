Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:17205 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752370Ab0GTE7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 00:59:00 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0727381936
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 13:58:58 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH/RFC 1/3] ath5k: log descriptor chains at a new debug level
Date: Tue, 20 Jul 2010 14:01:09 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <1279395336-856-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1279395336-856-2-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201007201401.09882.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun July 18 2010 04:35:34 Bob Copeland wrote:
> Descriptors are currently logged with ATH5K_DEBUG_RESET,
> which isn't really apt, and also means we can't see just
> the descriptor setup or just the resets.  Add a new
> debug level just for that.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/debug.c |    5 +++--
>  drivers/net/wireless/ath/ath5k/debug.h |    2 ++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c
> b/drivers/net/wireless/ath/ath5k/debug.c index ebb9c23..2222022 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -309,6 +309,7 @@ static const struct {
>  	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
>  	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
>  	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
> +	{ ATH5K_DEBUG_DESC,	"desc",		"descriptor chains" },
>  	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
>  };
> 
> @@ -937,7 +938,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct
> ath5k_hw *ah) struct ath5k_rx_status rs = {};
>  	int status;
> 
> -	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
> +	if (likely(!(sc->debug.level & ATH5K_DEBUG_DESC)))
>  		return;
> 
>  	printk(KERN_DEBUG "rxdp %x, rxlink %p\n",
> @@ -979,7 +980,7 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct
> ath5k_buf *bf) struct ath5k_tx_status ts = {};
>  	int done;
> 
> -	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
> +	if (likely(!(sc->debug.level & ATH5K_DEBUG_DESC)))
>  		return;
> 
>  	done = sc->ah->ah_proc_tx_desc(sc->ah, bf->desc, &ts);
> diff --git a/drivers/net/wireless/ath/ath5k/debug.h
> b/drivers/net/wireless/ath/ath5k/debug.h index 606ae94..9b22722 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.h
> +++ b/drivers/net/wireless/ath/ath5k/debug.h
> @@ -95,6 +95,7 @@ struct ath5k_dbg_info {
>   * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
>   * @ATH5K_DEBUG_DUMPBANDS: dump bands
>   * @ATH5K_DEBUG_TRACE: trace function calls
> + * @ATH5K_DEBUG_DESC: descriptor setup
>   * @ATH5K_DEBUG_ANY: show at any debug level
>   *
>   * The debug level is used to control the amount and type of debugging
> output @@ -117,6 +118,7 @@ enum ath5k_debug_level {
>  	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
>  	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
>  	ATH5K_DEBUG_ANI		= 0x00002000,
> +	ATH5K_DEBUG_DESC	= 0x00004000,
>  	ATH5K_DEBUG_ANY		= 0xffffffff
>  };

Acked-by: Bruno Randolf <br1@einfach.org>
