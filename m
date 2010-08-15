Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2204 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab0HORNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/6] ath5k: rename ath5k_hw_set_associd to _set_bssid
Date: Sun, 15 Aug 2010 13:03:10 -0400
Message-Id: <1281891795-14718-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
References: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nick Kossifidis <mickflemm@gmail.com>

Although the named function also sets the aid, its main
purpose is configuring the bssid and we use that
everywhere else.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 +-
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/base.c   |    4 ++--
 drivers/net/wireless/ath/ath5k/pcu.c    |   13 ++++++-------
 drivers/net/wireless/ath/ath5k/reset.c  |    2 +-
 5 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ea6362a..9129e51 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1190,7 +1190,7 @@ extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
 void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
 /* BSSID Functions */
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
-void ath5k_hw_set_associd(struct ath5k_hw *ah);
+void ath5k_hw_set_bssid(struct ath5k_hw *ah);
 void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
 /* Receive start/stop functions */
 void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index b32e28c..e72a1e5 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -329,7 +329,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
 	memcpy(common->curbssid, ath_bcast_mac, ETH_ALEN);
-	ath5k_hw_set_associd(ah);
+	ath5k_hw_set_bssid(ah);
 	ath5k_hw_set_opmode(ah, sc->opmode);
 
 	ath5k_hw_rfgain_opt_init(ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 373dcfe..cc080d0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3475,7 +3475,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		/* Cache for later use during resets */
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = 0;
-		ath5k_hw_set_associd(ah);
+		ath5k_hw_set_bssid(ah);
 		mmiowb();
 	}
 
@@ -3493,7 +3493,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 				  "Bss Info ASSOC %d, bssid: %pM\n",
 				  bss_conf->aid, common->curbssid);
 			common->curaid = bss_conf->aid;
-			ath5k_hw_set_associd(ah);
+			ath5k_hw_set_bssid(ah);
 			/* Once ANI is available you would start it here */
 		}
 	}
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 86fdb6d..efde8df 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -308,27 +308,26 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 }
 
 /**
- * ath5k_hw_set_associd - Set BSSID for association
+ * ath5k_hw_set_bssid - Set current BSSID on hw
  *
  * @ah: The &struct ath5k_hw
- * @bssid: BSSID
- * @assoc_id: Assoc id
  *
- * Sets the BSSID which trigers the "SME Join" operation
+ * Sets the current BSSID and BSSID mask we have from the
+ * common struct into the hardware
  */
-void ath5k_hw_set_associd(struct ath5k_hw *ah)
+void ath5k_hw_set_bssid(struct ath5k_hw *ah)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u16 tim_offset = 0;
 
 	/*
-	 * Set simple BSSID mask on 5212
+	 * Set BSSID mask on 5212
 	 */
 	if (ah->ah_version == AR5K_AR5212)
 		ath_hw_setbssidmask(common);
 
 	/*
-	 * Set BSSID which triggers the "SME Join" operation
+	 * Set BSSID
 	 */
 	ath5k_hw_reg_write(ah,
 			   get_unaligned_le32(common->curbssid),
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 498aa28..f5434eb 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1160,7 +1160,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 
 	/* Restore bssid and bssid mask */
-	ath5k_hw_set_associd(ah);
+	ath5k_hw_set_bssid(ah);
 
 	/* Set PCU config */
 	ath5k_hw_set_opmode(ah, op_mode);
-- 
1.7.1.1


