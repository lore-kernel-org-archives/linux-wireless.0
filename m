Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33317 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1HMFA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 01:00:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 08/11] ath9k: Move ath9k_init_crypto to common
Date: Sat, 13 Aug 2011 10:28:15 +0530
Message-ID: <1313211498-14442-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_070102_464893_E74F5B24)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h        |    1 -
 drivers/net/wireless/ath/ath9k/common.c       |   26 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h       |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   21 +------------------
 drivers/net/wireless/ath/ath9k/init.c         |   27 +------------------------
 drivers/net/wireless/ath/ath9k/pci.c          |    2 +-
 6 files changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4b08a3d..3a893e1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -663,7 +663,6 @@ extern int led_blink;
 extern bool is_ath9k_unloaded;
 
 irqreturn_t ath_isr(int irq, void *dev);
-void ath9k_init_crypto(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index fa6bd2d..dc705a2 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -169,6 +169,32 @@ void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
 }
 EXPORT_SYMBOL(ath9k_cmn_update_txpow);
 
+void ath9k_cmn_init_crypto(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int i = 0;
+
+	/* Get the hardware key cache size. */
+	common->keymax = AR_KEYTABLE_SIZE;
+
+	/*
+	 * Check whether the separate key cache entries
+	 * are required to handle both tx+rx MIC keys.
+	 * With split mic keys the number of stations is limited
+	 * to 27 otherwise 59.
+	 */
+	if (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA)
+		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
+
+	/*
+	 * Reset the key cache since some parts do not
+	 * reset the contents on initial power up.
+	 */
+	for (i = 0; i < common->keymax; i++)
+		ath_hw_keyreset(common, (u16) i);
+}
+EXPORT_SYMBOL(ath9k_cmn_init_crypto);
+
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 77ec288..ad14fec 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -62,3 +62,4 @@ void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
 				  enum ath_stomp_type stomp_type);
 void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
 			    u16 new_txpow, u16 *txpower);
+void ath9k_cmn_init_crypto(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 19aa5b7..9cf42f6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -572,25 +572,6 @@ err:
 	return -EINVAL;
 }
 
-static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
-{
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	int i = 0;
-
-	/* Get the hardware key cache size. */
-	common->keymax = AR_KEYTABLE_SIZE;
-
-	if (priv->ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA)
-		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
-
-	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up.
-	 */
-	for (i = 0; i < common->keymax; i++)
-		ath_hw_keyreset(common, (u16) i);
-}
-
 static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
 {
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
@@ -720,7 +701,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++)
 		priv->cur_beacon_conf.bslot[i] = NULL;
 
-	ath9k_init_crypto(priv);
+	ath9k_cmn_init_crypto(ah);
 	ath9k_init_channels_rates(priv);
 	ath9k_init_misc(priv);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index db38a58..d7761d1 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -404,31 +404,6 @@ fail:
 	return error;
 }
 
-void ath9k_init_crypto(struct ath_softc *sc)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int i = 0;
-
-	/* Get the hardware key cache size. */
-	common->keymax = AR_KEYTABLE_SIZE;
-
-	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up.
-	 */
-	for (i = 0; i < common->keymax; i++)
-		ath_hw_keyreset(common, (u16) i);
-
-	/*
-	 * Check whether the separate key cache entries
-	 * are required to handle both tx+rx MIC keys.
-	 * With split mic keys the number of stations is limited
-	 * to 27 otherwise 59.
-	 */
-	if (sc->sc_ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA)
-		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
-}
-
 static int ath9k_init_btcoex(struct ath_softc *sc)
 {
 	struct ath_txq *txq;
@@ -630,7 +605,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		goto err_btcoex;
 
-	ath9k_init_crypto(sc);
+	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 5685cf1..b4205fa 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -338,7 +338,7 @@ static int ath_pci_resume(struct device *device)
 	   * semi-random values after suspend/resume.
 	   */
 	ath9k_ps_wakeup(sc);
-	ath9k_init_crypto(sc);
+	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = true;
-- 
1.7.6

