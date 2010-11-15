Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4990 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0KOPTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 10:19:47 -0500
Date: Mon, 15 Nov 2010 10:07:02 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
Message-ID: <20101115150702.GA30935@hash.localnet>
References: <16168765.161289826231239.JavaMail.wlan@CHBU500181> <1785288.181289826959653.JavaMail.wlan@CHBU500181>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1785288.181289826959653.JavaMail.wlan@CHBU500181>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 15, 2010 at 02:16:06PM +0100, Wojciech Dubowik wrote:
> What about such changes compared to original patch? It's then possible to
> compile both modules at the same time. Of course linking won't work because
> I would need to separate functions like in ath9k.

Is there a plan to add a config entry for ATHEROS_AR231X (or did
I miss it?)  Someone will one day run their Kconfig checker and
report it missing.

> --- a/drivers/net/wireless/ath/ath5k/Kconfig
> +++ b/drivers/net/wireless/ath/ath5k/Kconfig
> @@ -1,9 +1,11 @@
>  config ATH5K
>         tristate "Atheros 5xxx wireless cards support"
> -       depends on PCI && MAC80211
> +       depends on (PCI || ATHEROS_AR231X) && MAC80211
>         select MAC80211_LEDS
>         select LEDS_CLASS
>         select NEW_LEDS
> +       select ATH5K_AHB if ATHEROS_AR231X
> +       select ATH5K_PCI if PCI

I like this better, but there probably needs to be a mutual
exclusion so that randconfig builds don't break.  Then you don't
get to build both still, but the resulting Makefile is a bit more
normal.  And then if someone shows up saying that they really do
have some AR231X device with PCI, then it's more obvious what they
need to do to fix it (i.e. separate bus interfaces from core).

Something like?
select ATH5K_PCI if (PCI && !ATHEROS_AR231X)
or
depends on ((PCI && !ATHEROS_AR231X) || (!PCI && ATHEROS_AR231X)) ...

-- 
Bob Copeland %% www.bobcopeland.com

