Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:44594 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab1KCN4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 09:56:11 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC v2 2/2] ath9k: integrate initial DFS module
Date: Thu,  3 Nov 2011 14:55:53 +0100
Message-Id: <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111103_145618_263211_D2AF7C2B)
In-Reply-To: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch integrates the DFS module into ath9k, including
 * building the module into ath9k_hw
 * setting up DFS debugfs
 * defining HW capability flag for DFS support
 * setting this flag by DFS supporting devices
   (so far: AR_SREV_9280_20_OR_LATER, TBC)
 * setting PHYRADAR rx filter flag to enable radar
   pulse reporting
 * forward radar PHY errors to dfs module

This is WIP and at its current stage is limited to test ath9k
pulse detection capabilities. The DFS pattern matching is
TBD in the higher layers and is not part of this patch.

CONFIG_ATH9K_DFS must be set to enable pulse detection.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    2 ++
 drivers/net/wireless/ath/ath9k/debug.c  |    3 +++
 drivers/net/wireless/ath/ath9k/debug.h  |    2 ++
 drivers/net/wireless/ath/ath9k/hw.c     |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c   |   18 +++++++++++++-----
 7 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 36ed3c4..1f260a5 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -29,6 +29,8 @@ ath9k_hw-y:=	\
 		eeprom_9287.o \
 		ani.o \
 		btcoex.o \
+		dfs.o \
+		dfs_debug.o \
 		mac.o \
 		ar9002_mac.o \
 		ar9003_mac.o \
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 138ae09..6642108 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1633,6 +1633,9 @@ int ath9k_init_debug(struct ath_hw *ah)
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
index 4f6c939..f70735a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -19,6 +19,7 @@
 
 #include "hw.h"
 #include "rc.h"
+#include "dfs_debug.h"
 
 struct ath_txq;
 struct ath_buf;
@@ -180,6 +181,7 @@ struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 	struct ath_rx_stats rxstats;
+	struct ath_dfs_stats dfs_stats;
 	u32 reset[__RESET_TYPE_MAX];
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 76dbc85..0f2fb42 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2333,6 +2333,18 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->pcie_lcr_offset = 0x80;
 	}
 
+#ifdef CONFIG_ATH9K_DFS
+	/*
+	 * enable radar detection on DFS supporting devices
+	 */
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/*
+		 * TODO: check for which chip-sets we want to support DFS
+		 */
+		pCap->hw_caps |= ATH9K_HW_CAP_DFS;
+	}
+#endif
+
 	tx_chainmask = pCap->tx_chainmask;
 	rx_chainmask = pCap->rx_chainmask;
 	while (tx_chainmask || rx_chainmask) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9dbc3cd..4f02f83 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -204,6 +204,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_5GHZ			= BIT(14),
 	ATH9K_HW_CAP_APM			= BIT(15),
 	ATH9K_HW_CAP_RTT			= BIT(16),
+	ATH9K_HW_CAP_DFS			= BIT(17),
 };
 
 struct ath9k_hw_capabilities {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d3b92ce..4d70aab 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -305,6 +305,23 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
 	}
 
+	if (ah->caps.hw_caps && ATH9K_HW_CAP_DFS) {
+		/**
+		 * enable radar pulse detection
+		 *
+		 * TODO: do this only for DFS channels
+		 */
+		ah->private_ops.set_radar_params(ah, &ah->radar_conf);
+		ath9k_hw_setrxfilter(ah,
+			ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
+		ath_dbg(common, ATH_DBG_DFS,
+			"DFS radar detection enabled for channel %d\n",
+			ah->curchan->channel);
+	} else {
+		ath9k_hw_setrxfilter(ah,
+			ath9k_hw_getrxfilter(ah) & ~ATH9K_RX_FILTER_PHYRADAR);
+	}
+
 	ieee80211_wake_queues(sc->hw);
 
 	return true;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a46e6ab..5dfd081 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -17,6 +17,7 @@
 #include <linux/dma-mapping.h>
 #include "ath9k.h"
 #include "ar9003_mac.h"
+#include "dfs.h"
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
@@ -1865,11 +1866,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (sc->sc_flags & SC_OP_RXFLUSH)
 			goto requeue_drop_frag;
 
-		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
-		if (retval)
-			goto requeue_drop_frag;
-
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
 		if (rs.rs_tstamp > tsf_lower &&
 		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
@@ -1879,6 +1875,18 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if ((ah->caps.hw_caps & ATH9K_HW_CAP_DFS) &&
+		    (rs.rs_status & ATH9K_RXERR_PHY) &&
+		    (rs.rs_phyerr == ATH9K_PHYERR_RADAR)) {
+			/* DFS: check for radar pulse */
+			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
+		}
+
+		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
+						 rxs, &decrypt_error);
+		if (retval)
+			goto requeue_drop_frag;
+
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
-- 
1.7.4.1

