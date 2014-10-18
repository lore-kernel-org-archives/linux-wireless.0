Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:49123
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458AbaJRRCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:02:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 05/10] ath9k: restart hardware after noise floor calibration failure
Date: Sat, 18 Oct 2014 19:02:07 +0200
Message-Id: <1413651732-69783-5-git-send-email-nbd@openwrt.org> (sfid-20141018_190244_995852_3B840F52)
In-Reply-To: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When NF calibration fails, the radio often becomes deaf. The usual
hardware hang checks do not detect this, so it's better to issue a reset
when that happens.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 11 ++++++-----
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 11 ++++++-----
 drivers/net/wireless/ath/ath9k/calib.c        |  6 ++++--
 drivers/net/wireless/ath/ath9k/calib.h        |  2 +-
 drivers/net/wireless/ath/ath9k/debug.c        |  1 +
 drivers/net/wireless/ath/ath9k/debug.h        |  1 +
 drivers/net/wireless/ath/ath9k/hw-ops.h       |  7 +++----
 drivers/net/wireless/ath/ath9k/hw.h           |  6 ++----
 drivers/net/wireless/ath/ath9k/link.c         | 11 ++++++++---
 9 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index cdc7400..6bfdebf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -657,14 +657,13 @@ static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
 		ar9280_hw_olc_temp_compensation(ah);
 }
 
-static bool ar9002_hw_calibrate(struct ath_hw *ah,
-				struct ath9k_channel *chan,
-				u8 rxchainmask,
-				bool longcal)
+static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
+			       u8 rxchainmask, bool longcal)
 {
 	bool iscaldone = true;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 	bool nfcal, nfcal_pending = false;
+	int ret;
 
 	nfcal = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF);
 	if (ah->caldata)
@@ -698,7 +697,9 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 			 * NF is slow time-variant, so it is OK to use a
 			 * historical value.
 			 */
-			ath9k_hw_loadnf(ah, ah->curchan);
+			ret = ath9k_hw_loadnf(ah, ah->curchan);
+			if (ret < 0)
+				return ret;
 		}
 
 		if (longcal) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index ac8301e..06ab71d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -121,13 +121,12 @@ static bool ar9003_hw_per_calibration(struct ath_hw *ah,
 	return iscaldone;
 }
 
-static bool ar9003_hw_calibrate(struct ath_hw *ah,
-				struct ath9k_channel *chan,
-				u8 rxchainmask,
-				bool longcal)
+static int ar9003_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
+			       u8 rxchainmask, bool longcal)
 {
 	bool iscaldone = true;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
+	int ret;
 
 	/*
 	 * For given calibration:
@@ -163,7 +162,9 @@ static bool ar9003_hw_calibrate(struct ath_hw *ah,
 		 * NF is slow time-variant, so it is OK to use a historical
 		 * value.
 		 */
-		ath9k_hw_loadnf(ah, ah->curchan);
+		ret = ath9k_hw_loadnf(ah, ah->curchan);
+		if (ret < 0)
+			return ret;
 
 		/* start NF calibration, without updating BB NF register */
 		ath9k_hw_start_nfcal(ah, false);
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 278365b..e200a6e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -234,7 +234,7 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 }
 
-void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
+int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath9k_nfcal_hist *h = NULL;
 	unsigned i, j;
@@ -301,7 +301,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		ath_dbg(common, ANY,
 			"Timeout while waiting for nf to load: AR_PHY_AGC_CONTROL=0x%x\n",
 			REG_READ(ah, AR_PHY_AGC_CONTROL));
-		return;
+		return -ETIMEDOUT;
 	}
 
 	/*
@@ -322,6 +322,8 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		}
 	}
 	REGWRITE_BUFFER_FLUSH(ah);
+
+	return 0;
 }
 
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index b8ed95e..87badf4 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -109,7 +109,7 @@ struct ath9k_pacal_info{
 
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
 void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update);
-void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
+int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
 bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index cf4a98b..2a2a17d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -863,6 +863,7 @@ static ssize_t read_file_reset(struct file *file, char __user *user_buf,
 		[RESET_TYPE_MAC_HANG] = "MAC Hang",
 		[RESET_TYPE_BEACON_STUCK] = "Stuck Beacon",
 		[RESET_TYPE_MCI] = "MCI Reset",
+		[RESET_TYPE_CALIBRATION] = "Calibration error",
 	};
 	char buf[512];
 	unsigned int len = 0;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 53ae15b..bd75b1f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -49,6 +49,7 @@ enum ath_reset_type {
 	RESET_TYPE_MAC_HANG,
 	RESET_TYPE_BEACON_STUCK,
 	RESET_TYPE_MCI,
+	RESET_TYPE_CALIBRATION,
 	__RESET_TYPE_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 8e85efe..88769b6 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -41,10 +41,9 @@ static inline void ath9k_hw_set_desc_link(struct ath_hw *ah, void *ds,
 	ath9k_hw_ops(ah)->set_desc_link(ds, link);
 }
 
-static inline bool ath9k_hw_calibrate(struct ath_hw *ah,
-				      struct ath9k_channel *chan,
-				      u8 rxchainmask,
-				      bool longcal)
+static inline int ath9k_hw_calibrate(struct ath_hw *ah,
+				     struct ath9k_channel *chan,
+				     u8 rxchainmask, bool longcal)
 {
 	return ath9k_hw_ops(ah)->calibrate(ah, chan, rxchainmask, longcal);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7a81f5b..f204099 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -688,10 +688,8 @@ struct ath_hw_ops {
 				     bool power_off);
 	void (*rx_enable)(struct ath_hw *ah);
 	void (*set_desc_link)(void *ds, u32 link);
-	bool (*calibrate)(struct ath_hw *ah,
-			  struct ath9k_channel *chan,
-			  u8 rxchainmask,
-			  bool longcal);
+	int (*calibrate)(struct ath_hw *ah, struct ath9k_channel *chan,
+			 u8 rxchainmask, bool longcal);
 	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked,
 			u32 *sync_cause_p);
 	void (*set_txdesc)(struct ath_hw *ah, void *ds,
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 2343f56..713b040 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -371,9 +371,14 @@ void ath_ani_calibrate(unsigned long data)
 
 	/* Perform calibration if necessary */
 	if (longcal || shortcal) {
-		common->ani.caldone =
-			ath9k_hw_calibrate(ah, ah->curchan,
-					   ah->rxchainmask, longcal);
+		int ret = ath9k_hw_calibrate(ah, ah->curchan, ah->rxchainmask,
+					     longcal);
+		if (ret < 0) {
+			ath9k_queue_reset(sc, RESET_TYPE_CALIBRATION);
+			return;
+		}
+
+		common->ani.caldone = ret;
 	}
 
 	ath_dbg(common, ANI,
-- 
2.0.4

