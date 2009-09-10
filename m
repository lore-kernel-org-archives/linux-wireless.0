Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZIJHKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 6/7] ath: move ath_bcast_mac to common header
Date: Thu, 10 Sep 2009 03:10:18 -0400
Message-Id: <1252566619-30390-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used by both ath5k and ath9k to set the first bssid mask.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h          |    2 ++
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/base.c   |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c    |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 --
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index a63e90c..59072e3 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -19,6 +19,8 @@
 
 #include <linux/skbuff.h>
 
+static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
 struct reg_dmn_pair_mapping {
 	u16 regDmnEnum;
 	u16 reg_5ghz_ctl;
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 71a1bd2..9a009a7 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -336,7 +336,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 	ath5k_hw_set_lladdr(ah, (u8[ETH_ALEN]){});
 
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memset(ah->ah_bssid, 0xff, ETH_ALEN);
+	memcpy(ah->ah_bssid, ath_bcast_mac, ETH_ALEN);
 	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
 	ath5k_hw_set_opmode(ah);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9c6ab53..a28d795 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -815,7 +815,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	SET_IEEE80211_PERM_ADDR(hw, mac);
 	/* All MAC address bits matter for ACKs */
-	memset(sc->bssidmask, 0xff, ETH_ALEN);
+	memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
 	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
 
 	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 2942f13..43aa358 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -365,7 +365,7 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
  * assuming only 4 bits for a mac address and for BSSIDs you can then have:
  *
  *                  \
- * MAC:                0001 |
+ * MAC:        0001 |
  * BSSID-01:   0100 | --> Belongs to us
  * BSSID-02:   1001 |
  *                  /
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d99c92d..e54fac3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -60,8 +60,6 @@ struct ath_node;
 
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
 
-static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-
 struct ath_config {
 	u32 ath_aggr_prot;
 	u16 txpowlimit;
-- 
1.6.3.3

