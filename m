Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17135 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYG2Fra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:30 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:30 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Vasantha kumar Thiagaranjan <vasanth@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 02/16] ath9k: Remove ineffective multirate retry stuff.
Date: Mon, 28 Jul 2008 22:47:11 -0700
Message-ID: <387a6a3c779a5c03b13e856b4b502451583ea1d3.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074732_726572_889B6473)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasantha kumar Thiagaranjan <vasanth@atheros.com>

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index ed440a0..3352617 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -1059,11 +1059,6 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 			   const struct hal_node_stats *stats);
 enum hal_bool ath9k_hw_setrxabort(struct ath_hal *ah, enum hal_bool set);
 void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum hal_ht_macmode mode);
-enum hal_bool ath9k_hw_setupxtxdesc(struct ath_hal *ah,
-				    struct ath_desc *ds,
-				    u_int txRate1, u_int txTries1,
-				    u_int txRate2, u_int txTries2,
-				    u_int txRate3, u_int txTries3);
 enum hal_bool ath9k_hw_phycounters(struct ath_hal *ah);
 enum hal_bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry);
 enum hal_bool ath9k_hw_getcapability(struct ath_hal *ah,
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 56cc8a9..5752467 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1162,17 +1162,6 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	sc->sc_rtsaggrlimit = ah->ah_caps.halRtsAggrLimit;
 
 	/*
-	 * Check if the MAC has multi-rate retry support.
-	 * We do this by trying to setup a fake extended
-	 * descriptor.  MAC's that don't have support will
-	 * return false w/o doing anything.  MAC's that do
-	 * support it will return true w/o doing anything.
-	 *
-	 *  XXX This is lame.  Just query a hal property, Luke!
-	 */
-	sc->sc_mrretry = ath9k_hw_setupxtxdesc(ah, NULL, 0, 0, 0, 0, 0, 0);
-
-	/*
 	 * Check if the device has hardware counters for PHY
 	 * errors.  If so we need to enable the MIB interrupt
 	 * so we can act on stat triggers.
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 6c17088..b6a6373 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -945,7 +945,6 @@ struct ath_softc {
 	/* Properties, Config */
 	unsigned int
 		sc_invalid             : 1, /* being detached */
-		sc_mrretry             : 1, /* multi-rate retry support */
 		sc_needmib             : 1, /* enable MIB stats intr */
 		sc_hasdiversity        : 1, /* rx diversity available */
 		sc_diversity           : 1, /* enable rx diversity */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index b99e29b..91ba3e4 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -7833,30 +7833,6 @@ void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs)
 }
 
 enum hal_bool
-ath9k_hw_setupxtxdesc(struct ath_hal *ah, struct ath_desc *ds,
-		      u_int txRate1, u_int txTries1,
-		      u_int txRate2, u_int txTries2,
-		      u_int txRate3, u_int txTries3)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	if (txTries1) {
-		ads->ds_ctl2 |= AR_DurUpdateEna;
-		ads->ds_ctl2 |= SM(txTries1, AR_XmitDataTries1);
-		ads->ds_ctl3 |= (txRate1 << AR_XmitRate1_S);
-	}
-	if (txTries2) {
-		ads->ds_ctl2 |= SM(txTries2, AR_XmitDataTries2);
-		ads->ds_ctl3 |= (txRate2 << AR_XmitRate2_S);
-	}
-	if (txTries3) {
-		ads->ds_ctl2 |= SM(txTries3, AR_XmitDataTries3);
-		ads->ds_ctl3 |= (txRate3 << AR_XmitRate3_S);
-	}
-	return AH_TRUE;
-}
-
-enum hal_bool
 ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
 		    u_int segLen, enum hal_bool firstSeg,
 		    enum hal_bool lastSeg, const struct ath_desc *ds0)
-- 
1.5.4.3

