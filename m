Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab1LOEQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:16:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so2176479iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 20:16:57 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [DO NOT APPLY] ath9k: DFS poo
Date: Wed, 14 Dec 2011 20:16:35 -0800
Message-Id: <1323922595-15533-5-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111215_051659_944873_BD876321)
In-Reply-To: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the stuff we need to figure out how to amend properly
upstream. I am not a fan of the SC_OP thing at all, neither am
I a fan of the channel stuff being dealt with within ath9k.

Consider this the remaining TODO for ath9k apart from the
other components we need in mac8011 / cfg80211 / hostapd.

---

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index afc156a..2d91e6f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -563,6 +563,7 @@ struct ath_ant_comb {
 #define SC_OP_BT_SCAN		     BIT(13)
 #define SC_OP_ANI_RUN		     BIT(14)
 #define SC_OP_PRIM_STA_VIF	     BIT(15)
+#define SC_OP_DFS		     BIT(16)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7d92004..00cfba7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -302,6 +302,10 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
 	}
 
+	/* set radar parameters if in DFS mode */
+	if (sc->sc_flags & SC_OP_DFS)
+		ath9k_hw_set_radar_params(ah);
+
 	ieee80211_wake_queues(sc->hw);
 
 	return true;
@@ -1689,9 +1693,21 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
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
index e031841..41652de 100644
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
 
 }
@@ -1846,6 +1849,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if ((rs.rs_status & ATH9K_RXERR_PHY) &&
+		    (rs.rs_phyerr == ATH9K_PHYERR_RADAR)) {
+			/* DFS: check for radar pulse */
+			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
+		}
+
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
 						 rxs, &decrypt_error);
 		if (retval)
