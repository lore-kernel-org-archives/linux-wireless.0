Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41785 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1BIMCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:02:01 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 6F7E1664005
	for <linux-wireless@vger.kernel.org>; Wed,  9 Feb 2011 13:02:00 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/2] ath9k: pulse detection
Date: Wed,  9 Feb 2011 13:01:42 +0100
Message-Id: <1297252905-29739-3-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Activate DFS pulse detection in ath9k and report pulse events to mac80211
to be passed through nl80211.
---
 drivers/net/wireless/ath/ath9k/mac.c  |   54 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c |    9 +++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c75d40f..f09a796 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -16,6 +16,7 @@
 
 #include "hw.h"
 #include "hw-ops.h"
+#include <net/cfg80211.h>
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
@@ -624,6 +625,57 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_resettxqueue);
 
+/*
+ * DFS: check PHY-error for radar pulse and feed the detector
+ */
+void ath9k_dfs_process_phyerr(struct ath_hw *ah, struct ath_desc *ds,
+		struct ath_rx_status *rs, u_int64_t fulltsf)
+{
+	/* fulltsf is zero => simulate monotonic time based on rs->rs_tstamp */
+	static u64 last_ts;
+	static u32 ts_hi;
+
+	struct ath9k_channel *chan = ah->curchan;
+	u8 rssi;
+	u32 dur = 0;
+	u32 ts;
+	struct wiphy *wiphy = NULL;
+
+	if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR))
+			&& (!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
+		printk(KERN_INFO "Error: rs_phyer=0x%x not a radar error\n",
+				rs->rs_phyerr);
+		return;
+	}
+
+	/* we need a valid wiphy to report per-wiphy pulses */
+	if (ah->common.hw == NULL)
+		return;
+
+	rssi = (u8) rs->rs_rssi_ctl0;
+	if (rssi == 0)
+		return;
+
+	/* update 64-bit time stamp with that of rs */
+	/* TODO: do this per-wiphy */
+	ts = rs->rs_tstamp;
+	if (ts <= (last_ts & 0xffffffff))
+		ts_hi++;
+	last_ts = ((u64)ts_hi << 32) | ts;
+
+
+	if (rs->rs_datalen != 0) {
+		char *vdata = (char *)ds->ds_vdata + rs->rs_datalen - 3;
+		dur = (u32) vdata[0];
+	}
+
+	/* ZKU: reverse measured scaling factor of 2/3 for duration */
+	dur = (dur * 66 + 50) / 100;
+
+	wiphy = ah->common.hw->wiphy;
+	ieee80211_add_radar_pulse(wiphy, chan->channel, last_ts - dur, dur);
+}
+
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			struct ath_rx_status *rs, u64 tsf)
 {
@@ -702,6 +754,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
+			/* DFS: feed assumed radar pulse */
+			ath9k_dfs_process_phyerr(ah, ds, rs, tsf);
 		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4ed43b2..746532a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -289,6 +289,15 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		ath_start_ani(common);
 	}
 
+	/**
+	 * enable radar pulse detection
+	 *
+	 * TODO: do this only for DFS channels
+	 */
+	ah->private_ops.set_radar_params(ah, &ah->radar_conf);
+	ath9k_hw_setrxfilter(ah,
+			ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
+
  ps_restore:
 	ieee80211_wake_queues(hw);
 
-- 
1.7.1

