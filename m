Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1IDVRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Sep 2011 17:17:35 -0400
Received: by bke11 with SMTP id 11so4035420bke.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Sep 2011 14:17:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: N-PHY: use helper for checking IPA
Date: Sun,  4 Sep 2011 23:18:22 +0200
Message-Id: <1315171105-26496-1-git-send-email-zajec5@gmail.com> (sfid-20110904_231739_233136_A55A935D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 4951678..40e436e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -89,6 +89,13 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
 
+static inline bool b43_nphy_ipa(struct b43_wldev *dev)
+{
+	enum ieee80211_band band = b43_current_band(dev->wl);
+	return ((dev->phy.n->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
+		(dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ));
+}
+
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
@@ -353,8 +360,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 		if (dev->phy.rev < 2 && dev->phy.is_40mhz)
 			b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_TSSIRPSMW);
 
-		if ((nphy->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
-		    (nphy->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
+		if (b43_nphy_ipa(dev)) {
 			b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x4);
 			b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x4);
 		}
@@ -650,14 +656,10 @@ static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw */
 static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
 	u16 tmp;
-	enum ieee80211_band band = b43_current_band(dev->wl);
-	bool ipa = (nphy->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
-			(nphy->ipa5g_on && band == IEEE80211_BAND_5GHZ);
 
 	if (dev->phy.rev >= 3) {
-		if (ipa) {
+		if (b43_nphy_ipa(dev)) {
 			tmp = 4;
 			b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S2,
 			      (((((tmp << 3) | tmp) << 3) | tmp) << 3) | tmp);
@@ -2204,7 +2206,6 @@ static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 
 static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
 	u8 i;
 	u16 reg, val;
 
@@ -2268,10 +2269,7 @@ static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 					enum ieee80211_band band =
 						b43_current_band(dev->wl);
 
-					if ((nphy->ipa2g_on &&
-						band == IEEE80211_BAND_2GHZ) ||
-						(nphy->ipa5g_on &&
-						band == IEEE80211_BAND_5GHZ))
+					if (b43_nphy_ipa(dev))
 						val = (band == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
 					else
 						val = 0x11;
@@ -2897,10 +2895,7 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 				enum ieee80211_band band =
 					b43_current_band(dev->wl);
 
-				if ((nphy->ipa2g_on &&
-				     band == IEEE80211_BAND_2GHZ) ||
-				    (nphy->ipa5g_on &&
-				     band == IEEE80211_BAND_5GHZ)) {
+				if (b43_nphy_ipa(dev)) {
 					table = b43_nphy_get_ipa_gain_table(dev);
 				} else {
 					if (band == IEEE80211_BAND_5GHZ) {
@@ -3736,8 +3731,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	}
 
 	tmp2 = b43_current_band(dev->wl);
-	if ((nphy->ipa2g_on && tmp2 == IEEE80211_BAND_2GHZ) ||
-	    (nphy->ipa5g_on && tmp2 == IEEE80211_BAND_5GHZ)) {
+	if (b43_nphy_ipa(dev)) {
 		b43_phy_set(dev, B43_NPHY_PAPD_EN0, 0x1);
 		b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ0, 0x007F,
 				nphy->papd_epsilon_offset[0] << 7);
-- 
1.7.3.4

