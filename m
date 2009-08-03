Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34823 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZHCTZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:26 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:27 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 22/24] ath9k: call ath9k_hw_detach() once upon hw init failure
Date: Mon, 3 Aug 2009 12:24:54 -0700
Message-ID: <1249327496-24629-23-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If hw initialization fails (ath9k_hw_init()) on ath_init_softc()
we bail out and call ath9k_hw_detach(). The call ath9k_hw_detach()
is conditional though as ath9k_hw_init() could itself have called
ath9k_hw_detach(). Just describing this is itself a brain twister.
Avoid this nonsense by removing ath9k_hw_detach() from ath9k_hw_init().

Upon hw initialization failure we expect the callers to take care of
the cleanup.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   24 ++++++++----------------
 drivers/net/wireless/ath/ath9k/main.c |    3 +--
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 633fe8b..0871529 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -898,26 +898,22 @@ static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
 
 int ath9k_hw_init(struct ath_hw *ah)
 {
-	int r;
+	int r = 0;
 
-	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
-		r = -EOPNOTSUPP;
-		goto bad;
-	}
+	if (!ath9k_hw_devid_supported(ah->hw_version.devid))
+		return -EOPNOTSUPP;
 
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
-		r = -EIO;
-		goto bad;
+		return -EIO;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
-		r = -EIO;
-		goto bad;
+		return -EIO;
 	}
 
 	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
@@ -939,8 +935,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
 			ah->hw_version.macRev);
-		r = -EOPNOTSUPP;
-		goto bad;
+		return -EOPNOTSUPP;
 	}
 
 	if (AR_SREV_9100(ah)) {
@@ -965,7 +960,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	r = ath9k_hw_post_init(ah);
 	if (r)
-		goto bad;
+		return r;
 
 	ath9k_hw_init_mode_gain_regs(ah);
 	ath9k_hw_fill_cap_info(ah);
@@ -975,7 +970,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	if (r) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Failed to initialize MAC address\n");
-		goto bad;
+		return r;
 	}
 
 	if (AR_SREV_9285(ah))
@@ -986,9 +981,6 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath9k_init_nfcal_hist_buffer(ah);
 
 	return 0;
-bad:
-	ath9k_hw_detach(ah);
-	return r;
 }
 
 static void ath9k_hw_init_bb(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d3d2cb6..a5475b7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1520,8 +1520,7 @@ bad2:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 bad:
-	if (ah)
-		ath9k_hw_detach(ah);
+	ath9k_hw_detach(ah);
 	sc->sc_ah = NULL;
 bad_no_ah:
 	ath9k_exit_debug(sc);
-- 
1.6.3.3

