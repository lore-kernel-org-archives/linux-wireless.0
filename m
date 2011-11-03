Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34802 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779Ab1KCP4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 11:56:11 -0400
Received: by eye27 with SMTP id 27so1258485eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 08:56:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320328553-28066-2-git-send-email-zefir.kurtisi@neratec.com>
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>
	<1320328553-28066-2-git-send-email-zefir.kurtisi@neratec.com>
Date: Thu, 3 Nov 2011 21:26:10 +0530
Message-ID: <CAD2nsn0PJqm3gCOiReUhJ3UGChWJZuy_pUnpu_rDUcshAcQWfQ@mail.gmail.com> (sfid-20111103_165617_213655_25146386)
Subject: Re: [RFC v2 1/2] ath9k: add DFS radar pulse processing
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 3, 2011 at 7:25 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> This initial DFS module provides basic functionality to deal with
> radar pulses reported by the DFS HW pattern detector.
>
> The reported data is evaluated and basic plausibility checks are
> performed to filter false pulses. Passing radar pulses are
> forwarded to pattern detectors (not part of this patch).
>
> The patch also includes
>  * new debug level ATH_DBG_DFS
>  * debugfs DFS radar statistics
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> ---
>  drivers/net/wireless/ath/ath.h             |    2 +
>  drivers/net/wireless/ath/ath9k/dfs.c       |  192 ++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/dfs.h       |   24 ++++
>  drivers/net/wireless/ath/ath9k/dfs_debug.c |   89 +++++++++++++
>  drivers/net/wireless/ath/ath9k/dfs_debug.h |   59 +++++++++
>  5 files changed, 366 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
>  create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h
>  create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.c
>  create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.h
>
> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
> index 46d6926..e38fcad 100644
> --- a/drivers/net/wireless/ath/ath.h
> +++ b/drivers/net/wireless/ath/ath.h
> @@ -215,6 +215,7 @@ do {                                                                \
>  * @ATH_DBG_HWTIMER: hardware timer handling
>  * @ATH_DBG_BTCOEX: bluetooth coexistance
>  * @ATH_DBG_BSTUCK: stuck beacons
> + * @ATH_DBG_DFS: radar datection
>  * @ATH_DBG_ANY: enable all debugging
>  *
>  * The debug level is used to control the amount and type of debugging output
> @@ -240,6 +241,7 @@ enum ATH_DEBUG {
>        ATH_DBG_BTCOEX          = 0x00002000,
>        ATH_DBG_WMI             = 0x00004000,
>        ATH_DBG_BSTUCK          = 0x00008000,
> +       ATH_DBG_DFS             = 0x00010000,
>        ATH_DBG_ANY             = 0xffffffff
>  };
>
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
> new file mode 100644
> index 0000000..9d3c8b9
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dfs.c
> @@ -0,0 +1,192 @@
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
> +#include "hw.h"
> +#include "hw-ops.h"
> +#include "ath9k.h"
> +#include "dfs.h"
> +#include "dfs_debug.h"
> +
> +/* pulse duration reported is scaled with 1000/800 us */
> +#define AR93X_NSECS_PER_DUR 800
> +static u32 dur_to_usecs(u32 dur)
> +{
> +       return (dur * AR93X_NSECS_PER_DUR + 500) / 1000;
> +}
> +
> +/* internal struct to pass radar data */
> +struct ath_radar_data {
> +       u8 pulse_bw_info;
> +       u8 rssi;
> +       u8 ext_rssi;
> +       u8 pulse_length_ext;
> +       u8 pulse_length_pri;
> +};
> +
> +/* TODO: move into or synchronize this with generic header
> + *       as soon as IF is defined */
> +struct dfs_radar_pulse {
> +       u16 freq;
> +       u64 ts;
> +       u32 width;
> +       u8 rssi;
> +};
> +
> +#define PRI_CH_RADAR_FOUND 0x01
> +#define EXT_CH_RADAR_FOUND 0x02
> +static bool postprocess_radar_event(struct ath_softc *sc,
> +               struct ath_radar_data *are, struct dfs_radar_pulse *drp)
> +{
> +       u8 rssi;
> +       u16 dur;
> +
> +       ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_DFS,
> +               "pulse_bw_info=0x%x, pri,ext len/rssi=(%u/%u, %u/%u)\n",
> +               are->pulse_bw_info,
> +               are->pulse_length_pri, are->rssi,
> +               are->pulse_length_ext, are->ext_rssi);
> +
> +       /* Only the last 2 bits of the BW info are relevant, they indicate
> +        which channel the radar was detected in.*/
> +       are->pulse_bw_info &= 0x03;
> +
> +       switch (are->pulse_bw_info) {
> +       case 0:

can we define some macro for this. thanks!

> +               /* Bogus bandwidth info received in descriptor,
> +                so ignore this PHY error */
> +               DFS_STAT_INC(sc, bwinfo_discards);
> +               return false;
> +       case PRI_CH_RADAR_FOUND:
> +               /* radar in ctrl channel */
> +               dur = are->pulse_length_pri;
> +               DFS_STAT_INC(sc, pri_phy_errors);
> +               /* cannot use ctrl channel RSSI
> +                * if extension channel is stronger */
> +               rssi = (are->ext_rssi >= (are->rssi + 3)) ? 0 : are->rssi;
> +               break;
> +       case EXT_CH_RADAR_FOUND:
> +               /* radar in extension channel */
> +               dur = are->pulse_length_ext;
> +               DFS_STAT_INC(sc, ext_phy_errors);
> +               /* cannot use extension channel RSSI
> +                * if control channel is stronger */
> +               rssi = (are->rssi >= (are->ext_rssi + 12)) ? 0 : are->ext_rssi;
> +               break;
> +       case (PRI_CH_RADAR_FOUND | EXT_CH_RADAR_FOUND):
> +               /*
> +                * Conducted testing, when pulse is on DC, both pri and ext
> +                * durations are reported to be same
> +                *
> +                * Radiated testing, when pulse is on DC, different pri and
> +                * ext durations are reported, so take the larger of the two
> +                * */
> +               if (are->pulse_length_ext >= are->pulse_length_pri)
> +                       dur = are->pulse_length_ext;
> +               else
> +                       dur = are->pulse_length_pri;
> +               DFS_STAT_INC(sc, dc_phy_errors);
> +
> +               /* when both are present use stronger one */
> +               rssi = (are->rssi < are->ext_rssi) ? are->ext_rssi : are->rssi;
> +               break;
> +       }
> +
> +       if (rssi == 0) {
> +               DFS_STAT_INC(sc, rssi_discards);
> +               return false;
> +       }
> +
> +       /*
> +        * TODO: check chirping pulses
> +        */
> +
> +       /* convert duration to usecs */
> +       drp->width = dur_to_usecs(dur);
> +       drp->rssi = rssi;
> +
> +       DFS_STAT_INC(sc, pulses_detected);
> +       return true;
> +}
> +
> +
> +/*
> + * DFS: check PHY-error for radar pulse and feed the detector
> + */
> +void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
> +               struct ath_rx_status *rs, u64 mactime)
> +{
> +       struct ath_radar_data ard;
> +       u16 datalen;
> +       char *vdata_end;
> +       struct dfs_radar_pulse drp;
> +       struct ath_hw *ah = sc->sc_ah;
> +       struct ath_common *common = ath9k_hw_common(ah);
> +
> +       if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR)) &&
> +               (!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
> +               ath_dbg(common, ATH_DBG_DFS,
> +                       "Error: rs_phyer=0x%x not a radar error\n",
> +                       rs->rs_phyerr);
> +               return;
> +       }
> +
> +       datalen = rs->rs_datalen;
> +       if (datalen == 0) {
> +               DFS_STAT_INC(sc, datalen_discards);
> +               return;
> +       }
> +
> +       ard.rssi = rs->rs_rssi_ctl0;
> +       ard.ext_rssi = rs->rs_rssi_ext0;
> +
> +       /* hardware stores this as 8 bit signed value.
> +        * we will cap it at 0 if it is a negative number
> +        */
> +       if (ard.rssi & 0x80)
> +               ard.rssi = 0;
> +       if (ard.ext_rssi & 0x80)
> +               ard.ext_rssi = 0;
> +
> +       vdata_end = (char *)data + datalen;
> +       ard.pulse_bw_info = vdata_end[-1];
> +       ard.pulse_length_ext = vdata_end[-2];
> +       ard.pulse_length_pri = vdata_end[-3];
> +
> +       ath_dbg(common, ATH_DBG_DFS,
> +               "bw_info=%d, length_pri=%d, length_ext=%d, "
> +               "rssi_pri=%d, rssi_ext=%d\n",
> +               ard.pulse_bw_info, ard.pulse_length_pri, ard.pulse_length_ext,
> +               ard.rssi, ard.ext_rssi);
> +
> +       drp.freq = ah->curchan->channel;
> +       drp.ts = mactime;
> +       if (postprocess_radar_event(sc, &ard, &drp)) {
> +               static u64 last_ts;
> +               ath_dbg(common, ATH_DBG_DFS,
> +                       "ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
> +                       "width=%d, rssi=%d, delta_ts=%llu\n",
> +                       drp.freq, drp.ts, drp.width, drp.rssi, drp.ts-last_ts);
> +               last_ts = drp.ts;
> +               /*
> +                * TODO: forward pulse to pattern detector
> +                *
> +                * ieee80211_add_radar_pulse(drp.freq, drp.ts,
> +                *                           drp.width, drp.rssi);
> +                */
> +       }
> +}
> +EXPORT_SYMBOL(ath9k_dfs_process_phyerr);
> diff --git a/drivers/net/wireless/ath/ath9k/dfs.h b/drivers/net/wireless/ath/ath9k/dfs.h
> new file mode 100644
> index 0000000..4d95cad
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dfs.h
> @@ -0,0 +1,24 @@
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
> +#ifndef ATH9K_DFS_H
> +#define ATH9K_DFS_H
> +
> +void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
> +               struct ath_rx_status *rs, u64 mactime);
> +
> +#endif /* ATH9K_DFS_H */
> diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
> new file mode 100644
> index 0000000..3c03552
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
> @@ -0,0 +1,89 @@
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
> +#include <linux/debugfs.h>
> +
> +#include "ath9k.h"
> +#include "dfs_debug.h"
> +
> +
> +#if defined(CONFIG_ATH9K_DEBUGFS)
> +
> +#define ATH9K_DFS_STAT(s, p) \
> +       len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
> +                       sc->debug.stats.dfs_stats.p);
> +
> +static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
> +                            size_t count, loff_t *ppos)
> +{
> +       struct ath_softc *sc = file->private_data;
> +       struct ath9k_hw_version *hw_ver = &sc->sc_ah->hw_version;
> +       char *buf;
> +       unsigned int len = 0, size = 8000;
> +       ssize_t retval = 0;
> +
> +       buf = kzalloc(size, GFP_KERNEL);
> +       if (buf == NULL)
> +               return -ENOMEM;
> +
> +       len += snprintf(buf + len, size - len, "DFS support for "
> +                       "macVersion = 0x%x, macRev = 0x%x: %s\n",
> +                       hw_ver->macVersion, hw_ver->macRev,
> +                       (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
> +                                       "enabled" : "disabled");
> +       ATH9K_DFS_STAT("DFS pulses detected     ", pulses_detected);
> +       ATH9K_DFS_STAT("Datalen discards        ", datalen_discards);
> +       ATH9K_DFS_STAT("RSSI discards           ", rssi_discards);
> +       ATH9K_DFS_STAT("BW info discards        ", bwinfo_discards);
> +       ATH9K_DFS_STAT("Primary channel pulses  ", pri_phy_errors);
> +       ATH9K_DFS_STAT("Secondary channel pulses", ext_phy_errors);
> +       ATH9K_DFS_STAT("Dual channel pulses     ", dc_phy_errors);
> +
> +       if (len > size)
> +               len = size;
> +
> +       retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +       kfree(buf);
> +
> +       return retval;
> +}
> +
> +static int ath9k_dfs_debugfs_open(struct inode *inode, struct file *file)
> +{
> +       file->private_data = inode->i_private;
> +       return 0;
> +}
> +
> +
> +static const struct file_operations fops_dfs_stats = {
> +       .read = read_file_dfs,
> +       .open = ath9k_dfs_debugfs_open,
> +       .owner = THIS_MODULE,
> +       .llseek = default_llseek,
> +};
> +
> +
> +void ath9k_dfs_init_debug(struct ath_softc *sc)
> +{
> +       debugfs_create_file("dfs_stats", S_IRUSR,
> +                       sc->debug.debugfs_phy, sc, &fops_dfs_stats);
> +}
> +EXPORT_SYMBOL(ath9k_dfs_init_debug);
> +
> +#endif /* CONFIG_ATH9K_DEBUGFS */
> +
> diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
> new file mode 100644
> index 0000000..079cf53
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
> @@ -0,0 +1,59 @@
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
> +
> +#if defined(CONFIG_ATH9K_DEBUGFS)
> +
> +#define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
> +void ath9k_dfs_init_debug(struct ath_softc *sc);
> +
> +#else
> +
> +#define DFS_STAT_INC(sc, c) do { } while (0)
> +static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
> +
> +#endif
> +
> +
> +#endif /* DFS_DEBUG_H */
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
