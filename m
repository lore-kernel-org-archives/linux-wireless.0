Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47221 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1KHQeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:34:12 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, shafi.wireless@gmail.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/2] ath9k: integrate initial DFS module
Date: Tue,  8 Nov 2011 17:34:04 +0100
Message-Id: <1320770044-12271-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111108_173418_027226_4A4CC980)
In-Reply-To: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch integrates the DFS module into ath9k, including
 * build the module into ath9k_hw
 * set up DFS debugfs
 * define HW capability flag for DFS support
   (so far: AR_SREV_9280_20_OR_LATER, TBC)
 * define and set DFS opmode flag when on DFS channel
   * configure radar params after reset
   * provide radar RX filter flag in ath_calcrxfilter()
 * forward radar PHY errors to DFS module

This is WIP and at its current stage is limited to test ath9k
pulse detection capabilities. The DFS pattern matching is
TBD in the higher layers and not part of this patch.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    2 ++
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/debug.c  |    3 +++
 drivers/net/wireless/ath/ath9k/debug.h  |    2 ++
 drivers/net/wireless/ath/ath9k/hw-ops.h |    9 +++++++++
 drivers/net/wireless/ath/ath9k/hw.c     |    7 +++++++
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c   |   19 ++++++++++++++-----
 9 files changed, 55 insertions(+), 5 deletions(-)

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
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7ab7a1e..de0309e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -563,6 +563,7 @@ struct ath_ant_comb {
 #define SC_OP_BT_SCAN		     BIT(13)
 #define SC_OP_ANI_RUN		     BIT(14)
 #define SC_OP_PRIM_STA_VIF	     BIT(15)
+#define SC_OP_DFS		     BIT(16)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
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
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index e74c233..c4ad0b0 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -212,4 +212,13 @@ static inline int ath9k_hw_fast_chan_change(struct ath_hw *ah,
 	return ath9k_hw_private_ops(ah)->fast_chan_change(ah, chan,
 							  ini_reloaded);
 }
+
+static inline void ath9k_hw_set_radar_params(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->set_radar_params)
+		return;
+
+	ath9k_hw_private_ops(ah)->set_radar_params(ah, &ah->radar_conf);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 76dbc85..c9ba80d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2333,6 +2333,13 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->pcie_lcr_offset = 0x80;
 	}
 
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/*
+		 * TODO: check for which chip-sets we want to support DFS
+		 */
+		pCap->hw_caps |= ATH9K_HW_CAP_DFS;
+	}
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
index d3b92ce..e86d820 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -305,6 +305,10 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
 	}
 
+	/* set radar parameters if in DFS mode */
+	if (sc->sc_flags & SC_OP_DFS)
+		ath9k_hw_set_radar_params(ah);
+
 	ieee80211_wake_queues(sc->hw);
 
 	return true;
@@ -1722,9 +1726,21 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			memset(&sc->survey[pos], 0, sizeof(struct survey_info));
 		}
 
+		if (curchan->flags & IEEE80211_CHAN_RADAR) {
+			if (!(ah->caps.hw_caps & ATH9K_HW_CAP_DFS)) {
+				ath_err(common, "HW does not support DFS\n");
+				mutex_unlock(&sc->mutex);
+				return -EINVAL;
+			}
+			sc->sc_flags |= SC_OP_DFS;
+		} else
+			sc->sc_flags &= ~SC_OP_DFS;
+
 		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
+			/* clear DFS operation flag on failure */
+			sc->sc_flags &= ~SC_OP_DFS;
 			return -EINVAL;
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0d5f275..76d804c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -17,6 +17,7 @@
 #include <linux/dma-mapping.h>
 #include "ath9k.h"
 #include "ar9003_mac.h"
+#include "dfs.h"
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
@@ -473,6 +474,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
 
+	if (sc->sc_flags & SC_OP_DFS)
+		rfilt |= ATH9K_RX_FILTER_PHYRADAR;
 	return rfilt;
 
 #undef RX_FILTER_PRESERVE
@@ -1855,11 +1858,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
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
@@ -1869,6 +1867,17 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if ((rs.rs_status & ATH9K_RXERR_PHY) &&
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

