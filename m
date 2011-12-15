Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1LOEQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:16:54 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so2176479iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 20:16:54 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 3/3] ath9k: add DFS radar pulse processing
Date: Wed, 14 Dec 2011 20:16:34 -0800
Message-Id: <1323922595-15533-4-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111215_051657_170538_A46D3308)
In-Reply-To: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>

This initial DFS module provides basic functionality to deal
with radar pulses reported by the Atheros DFS HW pulse detector.

The reported data is evaluated and basic plausibility checks
are performed to filter false pulses. Passing radar pulses are
forwarded to pattern detectors which are not yet implemented.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig     |   22 +++
 drivers/net/wireless/ath/ath9k/Makefile    |    2 +
 drivers/net/wireless/ath/ath9k/debug.c     |    3 +
 drivers/net/wireless/ath/ath9k/debug.h     |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c       |  215 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs.h       |   43 ++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   81 +++++++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.h |   57 ++++++++
 8 files changed, 425 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.h

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 7b4c074..1b4786a 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -2,6 +2,9 @@ config ATH9K_HW
 	tristate
 config ATH9K_COMMON
 	tristate
+config ATH9K_DFS_DEBUGFS
+	def_bool y
+	depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED
 
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
@@ -51,6 +54,25 @@ config ATH9K_DEBUGFS
 
 	  Also required for changing debug message flags at run time.
 
+config ATH9K_DFS_CERTIFIED
+	bool "Atheros DFS support for certified platforms"
+	depends on ATH9K && EXPERT
+	default n
+	---help---
+	  This option enables DFS support for initiating radiation on
+	  ath9k. There is no way to dynamically detect if a card was DFS
+	  certified and as such this is left as a build time option. This
+	  option should only be enabled by system integrators that can
+	  guarantee that all the platforms that their kernel will run on
+	  have obtained appropriate regulatory body certification for a
+	  respective Atheros card by using ath9k on the target shipping
+	  platforms.
+
+	  This is currently only a placeholder for future DFS support,
+	  as DFS support requires more components that still need to be
+	  developed. At this point enabling this option won't do anything
+	  except increase code size.
+
 config ATH9K_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 390797d..783559c 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -10,6 +10,8 @@ ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
+ath9k-$(CONFIG_ATH9K_DEBUGFS) += dfs_debug.o
+ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6fb719d..2d73a7a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1630,6 +1630,9 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("debug", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    sc, &fops_debug);
 #endif
+
+	ath9k_dfs_init_debug(sc);
+
 	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dma);
 	debugfs_create_file("interrupt", S_IRUSR, sc->debug.debugfs_phy, sc,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 356352a..776a24a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -19,6 +19,7 @@
 
 #include "hw.h"
 #include "rc.h"
+#include "dfs_debug.h"
 
 struct ath_txq;
 struct ath_buf;
@@ -187,6 +188,7 @@ struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 	struct ath_rx_stats rxstats;
+	struct ath_dfs_stats dfs_stats;
 	u32 reset[__RESET_TYPE_MAX];
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
new file mode 100644
index 0000000..e4e84a9
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "hw-ops.h"
+#include "ath9k.h"
+#include "dfs.h"
+#include "dfs_debug.h"
+
+/*
+ * TODO: move into or synchronize this with generic header
+ *	 as soon as IF is defined
+ */
+struct dfs_radar_pulse {
+	u16 freq;
+	u64 ts;
+	u32 width;
+	u8 rssi;
+};
+
+/* internal struct to pass radar data */
+struct ath_radar_data {
+	u8 pulse_bw_info;
+	u8 rssi;
+	u8 ext_rssi;
+	u8 pulse_length_ext;
+	u8 pulse_length_pri;
+};
+
+/* convert pulse duration to usecs, considering clock mode */
+static u32 dur_to_usecs(struct ath_hw *ah, u32 dur)
+{
+	const u32 AR93X_NSECS_PER_DUR = 800;
+	const u32 AR93X_NSECS_PER_DUR_FAST = (8000 / 11);
+	u32 nsecs;
+
+	if (IS_CHAN_A_FAST_CLOCK(ah, ah->curchan))
+		nsecs = dur * AR93X_NSECS_PER_DUR_FAST;
+	else
+		nsecs = dur * AR93X_NSECS_PER_DUR;
+
+	return (nsecs + 500) / 1000;
+}
+
+#define PRI_CH_RADAR_FOUND 0x01
+#define EXT_CH_RADAR_FOUND 0x02
+static bool
+ath9k_postprocess_radar_event(struct ath_softc *sc,
+			      struct ath_radar_data *are,
+			      struct dfs_radar_pulse *drp)
+{
+	u8 rssi;
+	u16 dur;
+
+	ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_DFS,
+		"pulse_bw_info=0x%x, pri,ext len/rssi=(%u/%u, %u/%u)\n",
+		are->pulse_bw_info,
+		are->pulse_length_pri, are->rssi,
+		are->pulse_length_ext, are->ext_rssi);
+
+	/*
+	 * Only the last 2 bits of the BW info are relevant, they indicate
+	 * which channel the radar was detected in.
+	 */
+	are->pulse_bw_info &= 0x03;
+
+	switch (are->pulse_bw_info) {
+	case PRI_CH_RADAR_FOUND:
+		/* radar in ctrl channel */
+		dur = are->pulse_length_pri;
+		DFS_STAT_INC(sc, pri_phy_errors);
+		/*
+		 * cannot use ctrl channel RSSI
+		 * if extension channel is stronger
+		 */
+		rssi = (are->ext_rssi >= (are->rssi + 3)) ? 0 : are->rssi;
+		break;
+	case EXT_CH_RADAR_FOUND:
+		/* radar in extension channel */
+		dur = are->pulse_length_ext;
+		DFS_STAT_INC(sc, ext_phy_errors);
+		/*
+		 * cannot use extension channel RSSI
+		 * if control channel is stronger
+		 */
+		rssi = (are->rssi >= (are->ext_rssi + 12)) ? 0 : are->ext_rssi;
+		break;
+	case (PRI_CH_RADAR_FOUND | EXT_CH_RADAR_FOUND):
+		/*
+		 * Conducted testing, when pulse is on DC, both pri and ext
+		 * durations are reported to be same
+		 *
+		 * Radiated testing, when pulse is on DC, different pri and
+		 * ext durations are reported, so take the larger of the two
+		 */
+		if (are->pulse_length_ext >= are->pulse_length_pri)
+			dur = are->pulse_length_ext;
+		else
+			dur = are->pulse_length_pri;
+		DFS_STAT_INC(sc, dc_phy_errors);
+
+		/* when both are present use stronger one */
+		rssi = (are->rssi < are->ext_rssi) ? are->ext_rssi : are->rssi;
+		break;
+	default:
+		/*
+		 * Bogus bandwidth info was received in descriptor,
+		 * so ignore this PHY error
+		 */
+		DFS_STAT_INC(sc, bwinfo_discards);
+		return false;
+	}
+
+	if (rssi == 0) {
+		DFS_STAT_INC(sc, rssi_discards);
+		return false;
+	}
+
+	/*
+	 * TODO: check chirping pulses
+	 *	 checks for chirping are dependent on the DFS regulatory domain
+	 *	 used, which is yet TBD
+	 */
+
+	/* convert duration to usecs */
+	drp->width = dur_to_usecs(sc->sc_ah, dur);
+	drp->rssi = rssi;
+
+	DFS_STAT_INC(sc, pulses_detected);
+	return true;
+}
+#undef PRI_CH_RADAR_FOUND
+#undef EXT_CH_RADAR_FOUND
+
+/*
+ * DFS: check PHY-error for radar pulse and feed the detector
+ */
+void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
+			      struct ath_rx_status *rs, u64 mactime)
+{
+	struct ath_radar_data ard;
+	u16 datalen;
+	char *vdata_end;
+	struct dfs_radar_pulse drp;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR)) &&
+	    (!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
+		ath_dbg(common, ATH_DBG_DFS,
+			"Error: rs_phyer=0x%x not a radar error\n",
+			rs->rs_phyerr);
+		return;
+	}
+
+	datalen = rs->rs_datalen;
+	if (datalen == 0) {
+		DFS_STAT_INC(sc, datalen_discards);
+		return;
+	}
+
+	ard.rssi = rs->rs_rssi_ctl0;
+	ard.ext_rssi = rs->rs_rssi_ext0;
+
+	/*
+	 * hardware stores this as 8 bit signed value.
+	 * we will cap it at 0 if it is a negative number
+	 */
+	if (ard.rssi & 0x80)
+		ard.rssi = 0;
+	if (ard.ext_rssi & 0x80)
+		ard.ext_rssi = 0;
+
+	vdata_end = (char *)data + datalen;
+	ard.pulse_bw_info = vdata_end[-1];
+	ard.pulse_length_ext = vdata_end[-2];
+	ard.pulse_length_pri = vdata_end[-3];
+
+	ath_dbg(common, ATH_DBG_DFS,
+		"bw_info=%d, length_pri=%d, length_ext=%d, "
+		"rssi_pri=%d, rssi_ext=%d\n",
+		ard.pulse_bw_info, ard.pulse_length_pri, ard.pulse_length_ext,
+		ard.rssi, ard.ext_rssi);
+
+	drp.freq = ah->curchan->channel;
+	drp.ts = mactime;
+	if (ath9k_postprocess_radar_event(sc, &ard, &drp)) {
+		static u64 last_ts;
+		ath_dbg(common, ATH_DBG_DFS,
+			"ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
+			"width=%d, rssi=%d, delta_ts=%llu\n",
+			drp.freq, drp.ts, drp.width, drp.rssi, drp.ts-last_ts);
+		last_ts = drp.ts;
+		/*
+		 * TODO: forward pulse to pattern detector
+		 *
+		 * ieee80211_add_radar_pulse(drp.freq, drp.ts,
+		 *                           drp.width, drp.rssi);
+		 */
+	}
+}
diff --git a/drivers/net/wireless/ath/ath9k/dfs.h b/drivers/net/wireless/ath/ath9k/dfs.h
new file mode 100644
index 0000000..c241285
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef ATH9K_DFS_H
+#define ATH9K_DFS_H
+
+#if defined(CONFIG_ATH9K_DFS_CERTIFIED)
+/**
+ * ath9k_dfs_process_phyerr - process radar PHY error
+ * @sc: ath_softc
+ * @data: RX payload data
+ * @rs: RX status after processing descriptor
+ * @mactime: receive time
+ *
+ * This function is called whenever the HW DFS module detects a radar
+ * pulse and reports it as a PHY error.
+ *
+ * The radar information provided as raw payload data is validated and
+ * filtered for false pulses. Events passing all tests are forwarded to
+ * the upper layer for pattern detection.
+ */
+void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
+			      struct ath_rx_status *rs, u64 mactime);
+#else
+static inline void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
+					    struct ath_rx_status *rs, u64 mactime) { }
+#endif
+
+#endif /* ATH9K_DFS_H */
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
new file mode 100644
index 0000000..106d031
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/export.h>
+
+#include "ath9k.h"
+#include "dfs_debug.h"
+
+#define ATH9K_DFS_STAT(s, p) \
+	len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			sc->debug.stats.dfs_stats.p);
+
+static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath9k_hw_version *hw_ver = &sc->sc_ah->hw_version;
+	char *buf;
+	unsigned int len = 0, size = 8000;
+	ssize_t retval = 0;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, size - len, "DFS support for "
+			"macVersion = 0x%x, macRev = 0x%x: %s\n",
+			hw_ver->macVersion, hw_ver->macRev,
+			(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
+					"enabled" : "disabled");
+	ATH9K_DFS_STAT("DFS pulses detected     ", pulses_detected);
+	ATH9K_DFS_STAT("Datalen discards        ", datalen_discards);
+	ATH9K_DFS_STAT("RSSI discards           ", rssi_discards);
+	ATH9K_DFS_STAT("BW info discards        ", bwinfo_discards);
+	ATH9K_DFS_STAT("Primary channel pulses  ", pri_phy_errors);
+	ATH9K_DFS_STAT("Secondary channel pulses", ext_phy_errors);
+	ATH9K_DFS_STAT("Dual channel pulses     ", dc_phy_errors);
+
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static int ath9k_dfs_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations fops_dfs_stats = {
+	.read = read_file_dfs,
+	.open = ath9k_dfs_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath9k_dfs_init_debug(struct ath_softc *sc)
+{
+	debugfs_create_file("dfs_stats", S_IRUSR,
+			    sc->debug.debugfs_phy, sc, &fops_dfs_stats);
+}
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
new file mode 100644
index 0000000..80e6028
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ * Copyright (c) 2011 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef DFS_DEBUG_H
+#define DFS_DEBUG_H
+
+#include "hw.h"
+
+/**
+ * struct ath_dfs_stats - DFS Statistics
+ *
+ * @pulses_detected:  No. of pulses detected so far
+ * @datalen_discards: No. of pulses discarded due to invalid datalen
+ * @rssi_discards:    No. of pulses discarded due to invalid RSSI
+ * @bwinfo_discards:  No. of pulses discarded due to invalid BW info
+ * @pri_phy_errors:   No. of pulses reported for primary channel
+ * @ext_phy_errors:   No. of pulses reported for extension channel
+ * @dc_phy_errors:    No. of pulses reported for primary + extension channel
+ */
+struct ath_dfs_stats {
+	u32 pulses_detected;
+	u32 datalen_discards;
+	u32 rssi_discards;
+	u32 bwinfo_discards;
+	u32 pri_phy_errors;
+	u32 ext_phy_errors;
+	u32 dc_phy_errors;
+};
+
+#if defined(CONFIG_ATH9K_DEBUGFS)
+
+#define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
+void ath9k_dfs_init_debug(struct ath_softc *sc);
+
+#else
+
+#define DFS_STAT_INC(sc, c) do { } while (0)
+static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
+
+#endif /* CONFIG_ATH9K_DEBUGFS */
+
+#endif /* DFS_DEBUG_H */
-- 
1.7.4.15.g7811d

