Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:47275 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYKTIBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 03:01:06 -0500
Date: Thu, 20 Nov 2008 09:01:00 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: m68k: linux-next allmodconfig
In-Reply-To: <20081119170211.b4029fc4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811200859590.6519@anakin> (sfid-20081120_090111_689524_419E8287)
References: <20081119170211.b4029fc4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 19 Nov 2008, Andrew Morton wrote:
> include/net/mac80211.h: In function 'ieee80211_tx_info_clear_status':
> include/net/mac80211.h:400: error: size of array 'type name' is negative
> include/net/mac80211.h:405: error: size of array 'type name' is negative
> 
> due to:
> 
> static inline void
> ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
> {
>         int i;
> 
>         BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
>                      offsetof(struct ieee80211_tx_info, control.rates));
>         BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
>                      offsetof(struct ieee80211_tx_info, driver_rates));
> -->     BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) != 8);
>         /* clear the rate counts */
>         for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
>                 info->status.rates[i].count = 0;
> 
> -->     BUILD_BUG_ON(

Yep, missing explicit padding in struct ieee80211_tx_info, breaking havoc on
m68k where the alignment requirement for 32-bit values is 2 bytes, not 4.

AFAIK, a fix should be floating around.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
