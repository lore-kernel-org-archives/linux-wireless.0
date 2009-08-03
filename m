Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34804 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZHCTZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:15 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/24] ath9k: describe hw initialization better
Date: Mon, 3 Aug 2009 12:24:46 -0700
Message-ID: <1249327496-24629-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During initialization ath9k tends to use "attach" to when we
initialize hardware due to the fact we used to attach a "HAL".
The notion of a HAL is long gone, so lets just be clear on what
we are doing.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c    |    2 +-
 drivers/net/wireless/ath/ath9k/ani.h    |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |   12 ++++++------
 drivers/net/wireless/ath/ath9k/hw.h     |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index aad259b..a613cf4 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -777,7 +777,7 @@ void ath9k_hw_ani_setup(struct ath_hw *ah)
 	}
 }
 
-void ath9k_hw_ani_attach(struct ath_hw *ah)
+void ath9k_hw_ani_init(struct ath_hw *ah)
 {
 	int i;
 
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 08b4e7e..803669f 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -132,7 +132,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
 void ath9k_hw_procmibevent(struct ath_hw *ah,
 			   const struct ath9k_node_stats *stats);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
-void ath9k_hw_ani_attach(struct ath_hw *ah);
+void ath9k_hw_ani_init(struct ath_hw *ah);
 void ath9k_hw_ani_detach(struct ath_hw *ah);
 
 #endif /* ANI_H */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 6fb1a80..e8ccec0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -3978,7 +3978,7 @@ static struct eeprom_ops eep_AR9287_ops = {
 };
 
 
-int ath9k_hw_eeprom_attach(struct ath_hw *ah)
+int ath9k_hw_eeprom_init(struct ath_hw *ah)
 {
 	int status;
 	if (AR_SREV_9287(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 7ddd016..335098d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -665,6 +665,6 @@ struct eeprom_ops {
 	(((_txchainmask >> 2) & 1) +                            \
 	 ((_txchainmask >> 1) & 1) + (_txchainmask & 1))
 
-int ath9k_hw_eeprom_attach(struct ath_hw *ah);
+int ath9k_hw_eeprom_init(struct ath_hw *ah);
 
 #endif /* EEPROM_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f280eef..65d2e7d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -578,7 +578,7 @@ static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
 	}
 }
 
-static int ath9k_hw_post_attach(struct ath_hw *ah)
+static int ath9k_hw_post_init(struct ath_hw *ah)
 {
 	int ecode;
 
@@ -589,7 +589,7 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 	if (ecode != 0)
 		return ecode;
 
-	ecode = ath9k_hw_eeprom_attach(ah);
+	ecode = ath9k_hw_eeprom_init(ah);
 	if (ecode != 0)
 		return ecode;
 
@@ -602,7 +602,7 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 
 	if (!AR_SREV_9100(ah)) {
 		ath9k_hw_ani_setup(ah);
-		ath9k_hw_ani_attach(ah);
+		ath9k_hw_ani_init(ah);
 	}
 
 	return 0;
@@ -896,7 +896,7 @@ static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
 	}
 }
 
-int ath9k_hw_attach(struct ath_hw *ah)
+int ath9k_hw_init(struct ath_hw *ah)
 {
 	int r;
 
@@ -963,7 +963,7 @@ int ath9k_hw_attach(struct ath_hw *ah)
 	else
 		ath9k_hw_disablepcie(ah);
 
-	r = ath9k_hw_post_attach(ah);
+	r = ath9k_hw_post_init(ah);
 	if (r)
 		goto bad;
 
@@ -2930,7 +2930,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		/*
 		 * AR9280 2.0 or later chips use SerDes values from the
 		 * initvals.h initialized depending on chipset during
-		 * ath9k_hw_attach()
+		 * ath9k_hw_init()
 		 */
 		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
 			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 35cf9f8..4c78e8c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -541,10 +541,10 @@ struct ath_hw {
 	struct ar5416IniArray iniModesTxGain;
 };
 
-/* Attach, Detach, Reset */
+/* Initialization, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
-int ath9k_hw_attach(struct ath_hw *ah);
+int ath9k_hw_init(struct ath_hw *ah);
 void ath9k_hw_rfdetach(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 230dedb..751d803 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1332,10 +1332,10 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	ah->hw_version.devid = devid;
 	sc->sc_ah = ah;
 
-	r = ath9k_hw_attach(ah);
+	r = ath9k_hw_init(ah);
 	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to attach hardware; "
+			"Unable to initialize hardware; "
 			"initialization status: %d\n", r);
 		goto bad;
 	}
-- 
1.6.3.3

