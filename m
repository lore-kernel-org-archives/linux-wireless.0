Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38946 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0LUPYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 10:24:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 81F1F860D0
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:17 +0100 (CET)
Received: from mail.neratec.ch ([127.0.0.1])
	by localhost (mail.neratec.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ebn5PuzXfFUC for <linux-wireless@vger.kernel.org>;
	Tue, 21 Dec 2010 16:15:16 +0100 (CET)
Received: from mail.neratec.ch (mail.neratec.ch [192.168.11.23])
	by mail.neratec.ch (Postfix) with ESMTP id C86AB664003
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 16:15:16 +0100 (CET)
Date: Tue, 21 Dec 2010 16:15:16 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Message-ID: <1772126663.11112.1292944516722.JavaMail.root@idefix>
In-Reply-To: <993654931.11102.1292944188555.JavaMail.root@idefix>
Subject: [PATCH 3/4] DFS: interface ath9k to pattern detector
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Enable DFS radar pulse detection in ath9k PHY and feed radar detector
with potential pulse events filtered from RX PHY errors.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 .../drivers/net/wireless/ath/ath9k/mac.c           |   51 ++++++++++++++++++++
 .../drivers/net/wireless/ath/ath9k/main.c          |    9 ++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e3d2ebf..a303010 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -624,6 +624,53 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_resettxqueue);
 
+/*
+ * DFS: check PHY-error for radar pulse and feed the detector
+ */
+void ath9k_dfs_process_phyerr(struct ath_hw *ah, struct ath_desc *ds,
+		struct ath_rx_status *rs, u_int64_t fulltsf)
+{
+	static u64 last_ts;
+	static u32 ts_hi;
+
+	struct ath9k_channel *chan = ah->curchan;
+	u8 rssi;
+	u32 dur = 0;
+	u32 ts;
+
+	if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR))
+			&& (!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
+		printk(KERN_INFO "Error: rs_phyer=0x%x not a radar error\n",
+				rs->rs_phyerr);
+		return;
+	}
+
+	/* update internal 64-bit time stamp with that of rs */
+	ts = rs->rs_tstamp;
+	if (ts <= (last_ts & 0xffffffff))
+		ts_hi++;
+	last_ts = ((u64)ts_hi << 32) | ts;
+
+	rssi = (u8) rs->rs_rssi_ctl0;
+
+	if (rssi == 0)
+		return;
+
+	if (rs->rs_datalen != 0) {
+		char *vdata = (char *)ds->ds_vdata + rs->rs_datalen - 3;
+		dur = (u32) vdata[0];
+#if 0
+		printk(KERN_INFO "dur=%d, datalen=%d: [%.2x, %.2x, %.2x]\n",
+			dur, rs->rs_datalen, vdata[0], vdata[1], vdata[2]);
+#endif
+	}
+
+	/* ZKU: reverse measured scaling factor of 2/3 for duration */
+	dur = (dur * 66 + 50) / 100;
+	ieee80211_add_radar_pulse(chan->channel, last_ts - dur, rssi, dur);
+}
+EXPORT_SYMBOL(ath9k_dfs_process_phyerr);
+
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			struct ath_rx_status *rs, u64 tsf)
 {
@@ -696,6 +743,10 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
+
+			/* DFS: feed assumed radar pulse */
+			ath9k_dfs_process_phyerr(ah, ds, rs, tsf);
+
 		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 29a6d35..a799c36 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -290,6 +290,15 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
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
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-- 
1.5.4.3
