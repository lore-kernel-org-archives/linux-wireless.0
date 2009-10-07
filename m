Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452AbZJGApL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 20:45:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/7] ath5k: simplify passed params to ath5k_hw_set_associd()
Date: Tue,  6 Oct 2009 20:44:31 -0400
Message-Id: <1254876274-1145-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have access to common->curbssid and common->curaid so just
use those. Note that common->curaid is always 0 so this keeps
our current behaviour of always using 0 for now. Once we fix
storing the association ID passed by mac80211 this will
require no changes here.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 +-
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/base.c   |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c    |   10 +++++-----
 drivers/net/wireless/ath/ath5k/reset.c  |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 43585d5..647d826 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1191,7 +1191,7 @@ extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
 /* BSSID Functions */
 extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
-extern void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id);
+extern void ath5k_hw_set_associd(struct ath5k_hw *ah);
 extern void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
 /* Receive start/stop functions */
 extern void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index e230de8..92995ad 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -326,7 +326,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
 	memcpy(common->curbssid, ath_bcast_mac, ETH_ALEN);
-	ath5k_hw_set_associd(ah, common->curbssid, 0);
+	ath5k_hw_set_associd(ah);
 	ath5k_hw_set_opmode(ah);
 
 	ath5k_hw_rfgain_opt_init(ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5aaa9bd..01da83d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3213,7 +3213,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
 		 * a clean way of letting us retrieve this yet. */
-		ath5k_hw_set_associd(ah, common->curbssid, 0);
+		ath5k_hw_set_associd(ah);
 		mmiowb();
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 9e6e41b..23e5e7e 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -279,7 +279,7 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
  *
  * Sets the BSSID which trigers the "SME Join" operation
  */
-void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
+void ath5k_hw_set_associd(struct ath5k_hw *ah)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 low_id, high_id;
@@ -294,13 +294,13 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	/*
 	 * Set BSSID which triggers the "SME Join" operation
 	 */
-	low_id = get_unaligned_le32(bssid);
-	high_id = get_unaligned_le16(bssid + 4);
+	low_id = get_unaligned_le32(common->curbssid);
+	high_id = get_unaligned_le16(common->curbssid + 4);
 	ath5k_hw_reg_write(ah, low_id, AR_BSSMSKL);
-	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
+	ath5k_hw_reg_write(ah, high_id | ((common->curaid & 0x3fff) <<
 				AR5K_BSS_ID1_AID_S), AR_BSSMSKU);
 
-	if (assoc_id == 0) {
+	if (common->curaid == 0) {
 		ath5k_hw_disable_pspoll(ah);
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 39346a2..fb89815 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1188,7 +1188,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 	/* Restore bssid and bssid mask */
 	/* XXX: add ah->aid once mac80211 gives this to us */
-	ath5k_hw_set_associd(ah, common->curbssid, 0);
+	ath5k_hw_set_associd(ah);
 
 	/* Set PCU config */
 	ath5k_hw_set_opmode(ah);
-- 
1.6.0.4

