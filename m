Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:30239 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754117AbYBEKBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 05:01:35 -0500
From: bruno randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 5/7] ath5k: Port debug.c over to the new band API and enable as build option
Date: Tue, 5 Feb 2008 19:01:23 +0900
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	linville@tuxdriver.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <48232833e8885012a94d1e4afeabfd1deca9f70f.1202092325.git.mcgrof@winlab.rutgers.edu>
In-Reply-To: <48232833e8885012a94d1e4afeabfd1deca9f70f.1202092325.git.mcgrof@winlab.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802051901.23454.bruno@thinktube.com> (sfid-20080205_100138_823982_8E2666EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 February 2008 00:03:54 Luis R. Rodriguez wrote:
> diff --git a/drivers/net/wireless/ath5k/Kconfig
> b/drivers/net/wireless/ath5k/Kconfig index af1b6b8..31d570e 100644
> --- a/drivers/net/wireless/ath5k/Kconfig
> +++ b/drivers/net/wireless/ath5k/Kconfig
> @@ -14,3 +14,24 @@ config ATH5K
>
>  	  If you choose to build a module, it'll be called ath5k. Say M if
>  	  unsure.
> +
> +config ATH5K_DEBUG
> +	bool "Atheros 5xxx debugging"
> +	depends on ATH5K
> +	---help---
> +	  Atheros 5xxx debugging messages.
> +
> +	  Say Y, if and you will get debug options for ath5k.
> +	  To use this, you need to mount debugfs:
> +
> +	  mkdir /debug/
> +	  mount -t debugfs debug /debug/
> +
> +	  You will get access to files under:
> +	  /debug/ath5k/phy0/
> +
> +	  To enable debug, pass the debug level to the debug module
> +	  parameter. For example:
> +
> +	  modprobe ath5k debug=0x00000400

maybe worth to note too:

also you can echo the debug level into /debug/ath5k/phy0/debug to toggle its 
state, e.g.

echo dumptx > /debug/ath5k/phy0/debug

> -ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode
> *modes) +ath5k_debug_dump_bands(struct ath5k_softc *sc)
>  {
> -	unsigned int m, i;
> +	unsigned int b, i;
>
> -	if (likely(!(sc->debug.level & ATH5K_DEBUG_DUMPMODES)))
> +	if (likely(!(sc->debug.level & ATH5K_DEBUG_DUMPBANDS)))
>  		return;
>
> -	for (m = 0; m < NUM_DRIVER_MODES; m++) {
> -		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
> -				modes[m].num_channels, modes[m].num_rates);
> +	BUG_ON(!sc->sbands);
> +
> +	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
> +		struct ieee80211_supported_band *band = &sc->sbands[b];
> +		char bname[5];
> +		switch (band->band) {
> +		case IEEE80211_BAND_2GHZ:
> +			strcpy(bname, "2 GHz");
> +			break;
> +		case IEEE80211_BAND_5GHZ:
> +			strcpy(bname, "5 GHz");
> +			break;
> +		default:
> +			printk(KERN_DEBUG "Band not supported: %d\n",
> +				band->band);
> +			return;
> +		}
> +		printk(KERN_DEBUG "Band %s: channels %d, rates %d\n", bname,
> +				band->n_channels, band->n_bitrates);

that looks a bit unnecessary to me. wouldn't something like that:

	printk(KERN_DEBUG "Band %d GHz: channels %d, rates %d\n", 
		band->band == IEEE80211_BAND_2GHZ ? 2 : 5,
		band->n_channels, band->n_bitrates);

be easier? but whatever, it's just debug code.

>  		printk(KERN_DEBUG " channels:\n");
> -		for (i = 0; i < modes[m].num_channels; i++)
> +		for (i = 0; i < band->n_channels; i++)
>  			printk(KERN_DEBUG "  %3d %d %.4x %.4x\n",
> -					modes[m].channels[i].chan,
> -					modes[m].channels[i].freq,
> -					modes[m].channels[i].val,
> -					modes[m].channels[i].flag);
> +					ieee80211_frequency_to_channel(
> +						band->channels[i].center_freq),
> +					band->channels[i].center_freq,
> +					band->channels[i].hw_value,
> +					band->channels[i].flags);
>  		printk(KERN_DEBUG " rates:\n");
> -		for (i = 0; i < modes[m].num_rates; i++)
> +		for (i = 0; i < band->n_bitrates; i++)
>  			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
> -					modes[m].rates[i].rate,
> -					modes[m].rates[i].val,
> -					modes[m].rates[i].flags,
> -					modes[m].rates[i].val2);
> +					band->bitrates[i].bitrate,
> +					band->bitrates[i].hw_value,
> +					band->bitrates[i].flags,
> +					band->bitrates[i].hw_value_short);
>  	}
>  }
>
> @@ -548,4 +565,4 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc,
>  		!done ? ' ' : (ds->ds_txstat.ts_status == 0) ? '*' : '!');
>  }
>
> -#endif /* if ATH5K_DEBUG */
> +#endif /* ifdef CONFIG_ATH5K_DEBUG */
> diff --git a/drivers/net/wireless/ath5k/debug.h
> b/drivers/net/wireless/ath5k/debug.h index c4fd8c4..16fbb6f 100644
> --- a/drivers/net/wireless/ath5k/debug.h
> +++ b/drivers/net/wireless/ath5k/debug.h
> @@ -61,11 +61,6 @@
>  #ifndef _ATH5K_DEBUG_H
>  #define _ATH5K_DEBUG_H
>
> -/* set this to 1 for debugging output */
> -#ifndef ATH5K_DEBUG
> -#define ATH5K_DEBUG	0
> -#endif
> -
>  struct ath5k_softc;
>  struct ath5k_hw;
>  struct ieee80211_hw_mode;
> @@ -96,7 +91,7 @@ struct ath5k_dbg_info {
>   * @ATH5K_DEBUG_LED: led management
>   * @ATH5K_DEBUG_DUMP_RX: print received skb content
>   * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
> - * @ATH5K_DEBUG_DUMPMODES: dump modes
> + * @ATH5K_DEBUG_DUMPBANDS: dump bands
>   * @ATH5K_DEBUG_TRACE: trace function calls
>   * @ATH5K_DEBUG_ANY: show at any debug level
>   *
> @@ -118,12 +113,12 @@ enum ath5k_debug_level {
>  	ATH5K_DEBUG_LED		= 0x00000080,
>  	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
>  	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
> -	ATH5K_DEBUG_DUMPMODES	= 0x00000400,
> +	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
>  	ATH5K_DEBUG_TRACE	= 0x00001000,
>  	ATH5K_DEBUG_ANY		= 0xffffffff
>  };
>
> -#if ATH5K_DEBUG
> +#ifdef CONFIG_ATH5K_DEBUG
>
>  #define ATH5K_TRACE(_sc) do { \
>  	if (unlikely((_sc)->debug.level & ATH5K_DEBUG_TRACE)) \
> @@ -158,8 +153,7 @@ void
>  ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah);
>
>  void
> -ath5k_debug_dump_modes(struct ath5k_softc *sc,
> -			struct ieee80211_hw_mode *modes);
> +ath5k_debug_dump_bands(struct ath5k_softc *sc);
>
>  void
>  ath5k_debug_dump_skb(struct ath5k_softc *sc,
> @@ -196,8 +190,7 @@ static inline void
>  ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah) {}
>
>  static inline void
> -ath5k_debug_dump_modes(struct ath5k_softc *sc,
> -			struct ieee80211_hw_mode *modes) {}
> +ath5k_debug_dump_bands(struct ath5k_softc *sc) {}
>
>  static inline void
>  ath5k_debug_dump_skb(struct ath5k_softc *sc,
> @@ -207,6 +200,6 @@ static inline void
>  ath5k_debug_printtxbuf(struct ath5k_softc *sc,
>  			struct ath5k_buf *bf, int done) {}
>
> -#endif /* if ATH5K_DEBUG */
> +#endif /* ifdef CONFIG_ATH5K_DEBUG */
>
>  #endif /* ifndef _ATH5K_DEBUG_H */


