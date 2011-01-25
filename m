Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:27183 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751741Ab1AYFYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 00:24:30 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0760363069
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 14:24:29 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/2] ath5k: remove debug_dump_skb() functions
Date: Tue, 25 Jan 2011 14:24:28 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
References: <1295929976-11858-1-git-send-email-me@bobcopeland.com> <1295929976-11858-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1295929976-11858-2-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101251424.28139.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 25 2011 13:32:56 Bob Copeland wrote:
> Now that rx and tx dumps go through the tracing infrastructure,
> we no longer need to keep these routines around.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/debug.c |   20 --------------------
>  drivers/net/wireless/ath/ath5k/debug.h |   10 ----------
>  2 files changed, 0 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c
> b/drivers/net/wireless/ath/ath5k/debug.c index d2f84d7..0230f30 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -308,8 +308,6 @@ static const struct {
>  	{ ATH5K_DEBUG_CALIBRATE, "calib",	"periodic calibration" },
>  	{ ATH5K_DEBUG_TXPOWER,	"txpower",	"transmit power setting" },
>  	{ ATH5K_DEBUG_LED,	"led",		"LED management" },
> -	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
> -	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
>  	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
>  	{ ATH5K_DEBUG_DMA,	"dma",		"dma start/stop" },
>  	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
> @@ -1036,24 +1034,6 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc,
> struct ath5k_hw *ah) }
> 
>  void
> -ath5k_debug_dump_skb(struct ath5k_softc *sc,
> -			struct sk_buff *skb, const char *prefix, int tx)
> -{
> -	char buf[16];
> -
> -	if (likely(!((tx && (sc->debug.level & ATH5K_DEBUG_DUMP_TX)) ||
> -		     (!tx && (sc->debug.level & ATH5K_DEBUG_DUMP_RX)))))
> -		return;
> -
> -	snprintf(buf, sizeof(buf), "%s %s", wiphy_name(sc->hw->wiphy), prefix);
> -
> -	print_hex_dump_bytes(buf, DUMP_PREFIX_NONE, skb->data,
> -		min(200U, skb->len));
> -
> -	printk(KERN_DEBUG "\n");
> -}
> -
> -void
>  ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
>  {
>  	struct ath5k_desc *ds = bf->desc;
> diff --git a/drivers/net/wireless/ath/ath5k/debug.h
> b/drivers/net/wireless/ath/ath5k/debug.h index 3e34428..b0355ae 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.h
> +++ b/drivers/net/wireless/ath/ath5k/debug.h
> @@ -116,8 +116,6 @@ enum ath5k_debug_level {
>  	ATH5K_DEBUG_CALIBRATE	= 0x00000020,
>  	ATH5K_DEBUG_TXPOWER	= 0x00000040,
>  	ATH5K_DEBUG_LED		= 0x00000080,
> -	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
> -	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
>  	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
>  	ATH5K_DEBUG_DMA		= 0x00000800,
>  	ATH5K_DEBUG_ANI		= 0x00002000,
> @@ -152,10 +150,6 @@ void
>  ath5k_debug_dump_bands(struct ath5k_softc *sc);
> 
>  void
> -ath5k_debug_dump_skb(struct ath5k_softc *sc,
> -			struct sk_buff *skb, const char *prefix, int tx);
> -
> -void
>  ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf);
> 
>  #else /* no debugging */
> @@ -182,10 +176,6 @@ static inline void
>  ath5k_debug_dump_bands(struct ath5k_softc *sc) {}
> 
>  static inline void
> -ath5k_debug_dump_skb(struct ath5k_softc *sc,
> -			struct sk_buff *skb, const char *prefix, int tx) {}
> -
> -static inline void
>  ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf) {}
> 
>  #endif /* ifdef CONFIG_ATH5K_DEBUG */

Acked-by: Bruno Randolf <br1@einfach.org>
