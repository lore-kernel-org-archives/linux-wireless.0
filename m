Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17137 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbYG2Frd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:33 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:33 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 04/16] ath9k: Use struct ath_softc directly instead of a void pointer
Date: Mon, 28 Jul 2008 22:47:13 -0700
Message-ID: <5ddb1f4a52ab256218733a6ac7253e9ca645cf50.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074735_790268_76F5D895)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 3352617..0c58bb9 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -913,7 +913,7 @@ struct ath_hal {
 	u_int32_t ah_magic;
 	u_int16_t ah_devid;
 	u_int16_t ah_subvendorid;
-	void *ah_sc;
+	struct ath_softc *ah_sc;
 	void __iomem *ah_sh;
 	u_int16_t ah_countryCode;
 	u_int32_t ah_macVersion;
@@ -999,7 +999,9 @@ enum hal_status ath_hal_getcapability(struct ath_hal *ah,
 const struct hal_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
 						   u_int mode);
 void ath9k_hw_detach(struct ath_hal *ah);
-struct ath_hal *ath9k_hw_attach(u_int16_t devid, void *sc, void __iomem *mem,
+struct ath_hal *ath9k_hw_attach(u_int16_t devid,
+				struct ath_softc *sc,
+				void __iomem *mem,
 				enum hal_status *error);
 enum hal_bool ath9k_regd_init_channels(struct ath_hal *ah,
 				       struct hal_channel *chans,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ab52647..f1f7265 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1173,7 +1173,8 @@ static void ath9k_hw_mark_phy_inactive(struct ath_hal *ah)
 }
 
 
-static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid, void *sc,
+static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
+					      struct ath_softc *sc,
 					      void __iomem *mem,
 					      enum hal_status *status)
 {
@@ -3240,7 +3241,8 @@ enum hal_bool ath9k_hw_setpower(struct ath_hal *ah,
 	return status;
 }
 
-static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid, void *sc,
+static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
+					  struct ath_softc *sc,
 					  void __iomem *mem,
 					  enum hal_status *status)
 {
@@ -8317,7 +8319,9 @@ const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid)
 		ath9k_hw_devname(devid) : NULL;
 }
 
-struct ath_hal *ath9k_hw_attach(u_int16_t devid, void *sc, void __iomem *mem,
+struct ath_hal *ath9k_hw_attach(u_int16_t devid,
+				struct ath_softc *sc,
+				void __iomem *mem,
 				enum hal_status *error)
 {
 	struct ath_hal *ah = NULL;
-- 
1.5.4.3

