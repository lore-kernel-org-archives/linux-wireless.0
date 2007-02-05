Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:51160 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbXBEO63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 09:58:29 -0500
Date: Mon, 5 Feb 2007 06:58:25 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
Message-ID: <20070205145824.GA6637@jm.kir.nu>
References: <200702051412.50703.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702051412.50703.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 05, 2007 at 02:12:50PM +0100, Michael Buesch wrote:

> This adds API calls to generate RTS and CTS-to-self frames.
> To be called if the device firmware requires the host to
> generate RTS/CTS frames.

I understand the part of adding this. However..

> Index: bu3sch-wireless-dev/include/linux/ieee80211.h

> Index: bu3sch-wireless-dev/include/net/d80211.h
> ===================================================================
> --- bu3sch-wireless-dev.orig/include/net/d80211.h	2007-02-05 13:59:34.000000000 +0100
> +++ bu3sch-wireless-dev/include/net/d80211.h	2007-02-05 14:01:30.000000000 +0100
> @@ -194,7 +194,6 @@ struct ieee80211_tx_control {
>  #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
>  	u32 flags;			       /* tx control flags defined
>  						* above */
> -	u16 rts_cts_duration;	/* duration field for RTS/CTS frame */
>  	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
>  	u8 power_level;		/* per-packet transmit power level, in dBm */
>  	u8 antenna_sel; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */

NAK. Why are you removing this? It is needed for hardware that generates
RTS/CTS frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
