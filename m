Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51340 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab1JCKaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:30:14 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 3/6] ath9k: initial radar pulse detection for DFS
Date: Mon,  3 Oct 2011 12:29:15 +0200
Message-Id: <1317637758-11907-4-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111003_123023_211417_C3397ACF)
In-Reply-To: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This initial DFS module provides basic functionality to deal with radar
pulses reported by the DFS HW pattern detector.

It is based on Atheros proprietary driver sources with the core
functionality ported to ath9k to inspect pulse data and perform
plausibility checks to filter false pulses.

The numerous TODOs left include
 * checks for chirping pulses
 * differentiation between different chipsets
 * support for configuring the DFS HW
 * etc.

The output of this module are radar events ready to be feed to a
pattern detection module.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c |  192 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs.h |   24 ++++
 2 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
new file mode 100644
index 0000000..1fc9596
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -0,0 +1,192 @@
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
+
+
+/* pulse duration reported is scaled with 1000/800 us */
+#define AR93X_NSECS_PER_DUR 800
+static u32 dur_to_usecs(u32 dur)
+{
+	return (dur * AR93X_NSECS_PER_DUR + 500) / 1000;
+}
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
+/* TODO: move into or synchronize this with generic header
+ *       as soon as IF is defined */
+struct dfs_radar_pulse {
+	u16 freq;
+	u64 ts;
+	u32 width;
+	u8 rssi;
+};
+
+#define PRI_CH_RADAR_FOUND 0x01
+#define EXT_CH_RADAR_FOUND 0x02
+static bool postprocess_radar_event(struct ath_softc *sc,
+		struct ath_radar_data *are, struct dfs_radar_pulse *drp)
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
+	/* Only the last 2 bits of the BW info are relevant, they indicate
+	 which channel the radar was detected in.*/
+	are->pulse_bw_info &= 0x03;
+
+	switch (are->pulse_bw_info) {
+	case 0:
+		/* Bogus bandwidth info received in descriptor,
+		 so ignore this PHY error */
+		DFS_STAT_INC(sc, bwinfo_discards);
+		return false;
+	case PRI_CH_RADAR_FOUND:
+		/* radar in ctrl channel */
+		dur = are->pulse_length_pri;
+		DFS_STAT_INC(sc, pri_phy_errors);
+		/* cannot use ctrl channel RSSI
+		 * if extension channel is stronger */
+		rssi = (are->ext_rssi >= (are->rssi + 3)) ? 0 : are->rssi;
+		break;
+	case EXT_CH_RADAR_FOUND:
+		/* radar in extension channel */
+		dur = are->pulse_length_ext;
+		DFS_STAT_INC(sc, ext_phy_errors);
+		/* cannot use extension channel RSSI
+		 * if control channel is stronger */
+		rssi = (are->rssi >= (are->ext_rssi + 12)) ? 0 : are->ext_rssi;
+		break;
+	case (PRI_CH_RADAR_FOUND | EXT_CH_RADAR_FOUND):
+		/*
+		 * Conducted testing, when pulse is on DC, both pri and ext
+		 * durations are reported to be same
+		 *
+		 * Radiated testing, when pulse is on DC, different pri and
+		 * ext durations are reported, so take the larger of the two
+		 * */
+		if (are->pulse_length_ext >= are->pulse_length_pri)
+			dur = are->pulse_length_ext;
+		else
+			dur = are->pulse_length_pri;
+		DFS_STAT_INC(sc, dc_phy_errors);
+
+		/* when both are present use stronger one */
+		rssi = (are->rssi < are->ext_rssi) ? are->ext_rssi : are->rssi;
+		break;
+	}
+
+	if (rssi == 0) {
+		DFS_STAT_INC(sc, rssi_discards);
+		return false;
+	}
+
+	/*
+	 * TODO: check chirping pulses
+	 */
+
+	/* convert duration to usecs */
+	drp->width = dur_to_usecs(dur);
+	drp->rssi = rssi;
+
+	DFS_STAT_INC(sc, pulses_detected);
+	return true;
+}
+
+
+/*
+ * DFS: check PHY-error for radar pulse and feed the detector
+ */
+void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
+		struct ath_rx_status *rs, u64 mactime)
+{
+	struct ath_radar_data ard;
+	u16 datalen;
+	char *vdata_end;
+	struct dfs_radar_pulse drp;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR)) &&
+		(!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
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
+	/* hardware stores this as 8 bit signed value.
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
+	if (postprocess_radar_event(sc, &ard, &drp)) {
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
+EXPORT_SYMBOL(ath9k_dfs_process_phyerr);
diff --git a/drivers/net/wireless/ath/ath9k/dfs.h b/drivers/net/wireless/ath/ath9k/dfs.h
new file mode 100644
index 0000000..4d95cad
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs.h
@@ -0,0 +1,24 @@
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
+void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
+		struct ath_rx_status *rs, u64 mactime);
+
+#endif /* ATH9K_DFS_H */
-- 
1.7.4.1

