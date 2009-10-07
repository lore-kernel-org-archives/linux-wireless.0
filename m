Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613AbZJGBTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/6] ath9k: initialize hw prior to debugfs
Date: Tue,  6 Oct 2009 21:19:07 -0400
Message-Id: <1254878351-32433-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs uses the hardware for several debugfs files as such the
hardware must be initialized and available prior to its usage. The
same applies to when we free the hw structs -- free debufs file
entries prior to free'ing the hardware.

Reported-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h        |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.c   |   11 ++++++++++-
 drivers/net/wireless/ath/ath9k/main.c |   28 ++++++++++++++--------------
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index b6cd752..5e19a73 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -23,6 +23,11 @@
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
+enum ath_device_state {
+	ATH_HW_UNAVAILABLE,
+	ATH_HW_INITIALIZED,
+};
+
 struct reg_dmn_pair_mapping {
 	u16 regDmnEnum;
 	u16 reg_5ghz_ctl;
@@ -59,6 +64,7 @@ struct ath_common {
 	void *priv;
 	struct ieee80211_hw *hw;
 	int debug_mask;
+	enum ath_device_state state;
 
 	u16 cachelsz;
 	u16 curaid;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 692fd1d..cab17c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -999,6 +999,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_init_nfcal_hist_buffer(ah);
 
+	common->state = ATH_HW_INITIALIZED;
+
 	return 0;
 }
 
@@ -1239,11 +1241,18 @@ const char *ath9k_hw_probe(u16 vendorid, u16 devid)
 
 void ath9k_hw_detach(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (common->state <= ATH_HW_INITIALIZED)
+		goto free_hw;
+
 	if (!AR_SREV_9100(ah))
 		ath9k_hw_ani_disable(ah);
 
-	ath9k_hw_rf_free(ah);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+
+free_hw:
+	ath9k_hw_rf_free(ah);
 	kfree(ah);
 	ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f90cb8..0fe915a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1365,8 +1365,8 @@ void ath_detach(struct ath_softc *sc)
 	    ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
 
-	ath9k_hw_detach(ah);
 	ath9k_exit_debug(ah);
+	ath9k_hw_detach(ah);
 	sc->sc_ah = NULL;
 }
 
@@ -1626,10 +1626,8 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 		     (unsigned long)sc);
 
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
-	if (!ah) {
-		r = -ENOMEM;
-		goto bad_no_ah;
-	}
+	if (!ah)
+		return -ENOMEM;
 
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = subsysid;
@@ -1651,15 +1649,18 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	/* XXX assert csz is non-zero */
 	common->cachelsz = csz << 2;	/* convert to bytes */
 
-	if (ath9k_init_debug(ah) < 0)
-		dev_err(sc->dev, "Unable to create debugfs files\n");
-
 	r = ath9k_hw_init(ah);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to initialize hardware; "
 			  "initialization status: %d\n", r);
-		goto bad;
+		goto bad_free_hw;
+	}
+
+	if (ath9k_init_debug(ah) < 0) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to create debugfs files\n");
+		goto bad_free_hw;
 	}
 
 	/* Get the hardware key cache size. */
@@ -1848,12 +1849,11 @@ bad2:
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
-bad:
+
+	ath9k_exit_debug(ah);
+bad_free_hw:
 	ath9k_hw_detach(ah);
-bad_no_ah:
-	ath9k_exit_debug(sc->sc_ah);
 	sc->sc_ah = NULL;
-
 	return r;
 }
 
@@ -1966,8 +1966,8 @@ error_attach:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	ath9k_hw_detach(ah);
 	ath9k_exit_debug(ah);
+	ath9k_hw_detach(ah);
 	sc->sc_ah = NULL;
 
 	return error;
-- 
1.6.0.4

