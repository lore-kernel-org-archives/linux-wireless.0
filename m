Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42741 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0INRMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:12:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
Subject: [PATCH 1/2] ath9k: fix BSSID mask calculation
Date: Tue, 14 Sep 2010 18:37:19 +0200
Message-Id: <1284482240-57922-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the time the .add_interface driver op is called, the interface has not
been marked as running yet, so ieee80211_iterate_active_interfaces will
not pass it to the iterator function.
Because of this, the calculated BSSID mask is wrong, which breaks multi-BSS
operation.

Additionally, the current way of comparing all addresses against each other
is pointless, as the hardware only uses the hardware MAC address and the BSSID
mask for matching the destination address, so all the address array
reallocation is completely unnecessary.

This patch simplifies the logic by setting the initial mask bytes to 0xff
and removing all bits in the iterator call that don't match the hardware MAC
address. It also calls the iterator for the vif that was passed to
add_interface()

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c    |    2 +-
 drivers/net/wireless/ath/ath9k/virtual.c |   63 +++++++----------------------
 3 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5fe570b..c8ff417 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -719,7 +719,7 @@ static inline void ath_ahb_exit(void) {};
 void ath9k_ps_wakeup(struct ath_softc *sc);
 void ath9k_ps_restore(struct ath_softc *sc);
 
-void ath9k_set_bssid_mask(struct ieee80211_hw *hw);
+void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int ath9k_wiphy_add(struct ath_softc *sc);
 int ath9k_wiphy_del(struct ath_wiphy *aphy);
 void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..d3f96e4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1415,7 +1415,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	sc->nvifs++;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath9k_set_bssid_mask(hw);
+		ath9k_set_bssid_mask(hw, vif);
 
 	if (sc->nvifs > 1)
 		goto out; /* skip global settings for secondary vif */
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index fd20241..ec7cf5e 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -19,45 +19,36 @@
 #include "ath9k.h"
 
 struct ath9k_vif_iter_data {
-	int count;
-	u8 *addr;
+	const u8 *hw_macaddr;
+	u8 mask[ETH_ALEN];
 };
 
 static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct ath9k_vif_iter_data *iter_data = data;
-	u8 *nbuf;
-
-	nbuf = krealloc(iter_data->addr, (iter_data->count + 1) * ETH_ALEN,
-			GFP_ATOMIC);
-	if (nbuf == NULL)
-		return;
+	int i;
 
-	memcpy(nbuf + iter_data->count * ETH_ALEN, mac, ETH_ALEN);
-	iter_data->addr = nbuf;
-	iter_data->count++;
+	for (i = 0; i < ETH_ALEN; i++)
+		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
 }
 
-void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
+void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_vif_iter_data iter_data;
-	int i, j;
-	u8 mask[ETH_ALEN];
+	int i;
 
 	/*
-	 * Add primary MAC address even if it is not in active use since it
-	 * will be configured to the hardware as the starting point and the
-	 * BSSID mask will need to be changed if another address is active.
+	 * Use the hardware MAC address as reference, the hardware uses it
+	 * together with the BSSID mask when matching addresses.
 	 */
-	iter_data.addr = kmalloc(ETH_ALEN, GFP_ATOMIC);
-	if (iter_data.addr) {
-		memcpy(iter_data.addr, common->macaddr, ETH_ALEN);
-		iter_data.count = 1;
-	} else
-		iter_data.count = 0;
+	iter_data.hw_macaddr = common->macaddr;
+	memset(&iter_data.mask, 0xff, ETH_ALEN);
+
+	if (vif)
+		ath9k_vif_iter(&iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
 	spin_lock_bh(&sc->wiphy_lock);
@@ -71,31 +62,7 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	}
 	spin_unlock_bh(&sc->wiphy_lock);
 
-	/* Generate an address mask to cover all active addresses */
-	memset(mask, 0, ETH_ALEN);
-	for (i = 0; i < iter_data.count; i++) {
-		u8 *a1 = iter_data.addr + i * ETH_ALEN;
-		for (j = i + 1; j < iter_data.count; j++) {
-			u8 *a2 = iter_data.addr + j * ETH_ALEN;
-			mask[0] |= a1[0] ^ a2[0];
-			mask[1] |= a1[1] ^ a2[1];
-			mask[2] |= a1[2] ^ a2[2];
-			mask[3] |= a1[3] ^ a2[3];
-			mask[4] |= a1[4] ^ a2[4];
-			mask[5] |= a1[5] ^ a2[5];
-		}
-	}
-
-	kfree(iter_data.addr);
-
-	/* Invert the mask and configure hardware */
-	common->bssidmask[0] = ~mask[0];
-	common->bssidmask[1] = ~mask[1];
-	common->bssidmask[2] = ~mask[2];
-	common->bssidmask[3] = ~mask[3];
-	common->bssidmask[4] = ~mask[4];
-	common->bssidmask[5] = ~mask[5];
-
+	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
 	ath_hw_setbssidmask(common);
 }
 
-- 
1.7.2.2

