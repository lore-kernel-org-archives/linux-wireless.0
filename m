Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab1LOE6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:58:54 -0500
Received: by iaeh11 with SMTP id h11so2221815iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 20:58:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323922595-15533-4-git-send-email-mcgrof@qca.qualcomm.com>
References: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com> <1323922595-15533-4-git-send-email-mcgrof@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 15 Dec 2011 15:58:32 +1100
Message-ID: <CAGRGNgXPFM4Yo4WM0mUp0=famt2JeLxSRAX=iVtYDiGo9r+RTw@mail.gmail.com> (sfid-20111215_055926_720102_A42A94D8)
Subject: Re: [PATCH 3/3] ath9k: add DFS radar pulse processing
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis and Zefir,

On Thu, Dec 15, 2011 at 15:16, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>
> This initial DFS module provides basic functionality to deal
> with radar pulses reported by the Atheros DFS HW pulse detector.
>
> The reported data is evaluated and basic plausibility checks
> are performed to filter false pulses. Passing radar pulses are
> forwarded to pattern detectors which are not yet implemented.
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index 7b4c074..1b4786a 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -2,6 +2,9 @@ config ATH9K_HW
>        tristate
>  config ATH9K_COMMON
>        tristate
> +config ATH9K_DFS_DEBUGFS
> +       def_bool y
> +       depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED
>
>  config ATH9K
>        tristate "Atheros 802.11n wireless cards support"
> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
> index 390797d..783559c 100644
> --- a/drivers/net/wireless/ath/ath9k/Makefile
> +++ b/drivers/net/wireless/ath/ath9k/Makefile
> @@ -10,6 +10,8 @@ ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
>  ath9k-$(CONFIG_ATH9K_PCI) += pci.o
>  ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
>  ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
> +ath9k-$(CONFIG_ATH9K_DEBUGFS) += dfs_debug.o

Shouldn't this config variable be CONFIG_ATH9K_DFS_DEBUGFS?

You introduce that config variable but never use it.

> +ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
>
>  obj-$(CONFIG_ATH9K) += ath9k.o
>
> diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
> new file mode 100644
> index 0000000..80e6028
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
> @@ -0,0 +1,57 @@
> +/*
> + * Copyright (c) 2008-2011 Atheros Communications Inc.
> + * Copyright (c) 2011 Neratec Solutions AG
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +
> +#ifndef DFS_DEBUG_H
> +#define DFS_DEBUG_H
> +
> +#include "hw.h"
> +
> +/**
> + * struct ath_dfs_stats - DFS Statistics
> + *
> + * @pulses_detected:  No. of pulses detected so far
> + * @datalen_discards: No. of pulses discarded due to invalid datalen
> + * @rssi_discards:    No. of pulses discarded due to invalid RSSI
> + * @bwinfo_discards:  No. of pulses discarded due to invalid BW info
> + * @pri_phy_errors:   No. of pulses reported for primary channel
> + * @ext_phy_errors:   No. of pulses reported for extension channel
> + * @dc_phy_errors:    No. of pulses reported for primary + extension channel
> + */
> +struct ath_dfs_stats {
> +       u32 pulses_detected;
> +       u32 datalen_discards;
> +       u32 rssi_discards;
> +       u32 bwinfo_discards;
> +       u32 pri_phy_errors;
> +       u32 ext_phy_errors;
> +       u32 dc_phy_errors;
> +};
> +
> +#if defined(CONFIG_ATH9K_DEBUGFS)

Same here.

> +
> +#define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
> +void ath9k_dfs_init_debug(struct ath_softc *sc);
> +
> +#else
> +
> +#define DFS_STAT_INC(sc, c) do { } while (0)
> +static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
> +
> +#endif /* CONFIG_ATH9K_DEBUGFS */

And here =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
