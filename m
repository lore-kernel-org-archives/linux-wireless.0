Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2HJLR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:17:58 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20516.60828.201025.657272@gargle.gargle.HOWL> (sfid-20120810_131800_988165_9D4977FF)
Date: Fri, 10 Aug 2012 16:46:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/15] ath9k: Unify valid rate calculation routines
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 74 +++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 8a5fc62..ed48d3d 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -504,50 +504,49 @@ static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv)
 	return hi;
 }
 
-static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
+static inline bool ath_rc_check_legacy(u8 rate, u8 dot11rate, u16 rate_flags,
+				       u32 phy, u32 capflag)
 {
-	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
-	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
-	u32 phy, capflag = ath_rc_priv->ht_cap;
-	u16 rate_flags;
-	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+	if (rate != dot11rate || WLAN_RC_PHY_HT(phy))
+		return false;
 
-	for (i = 0; i < rateset->rs_nrates; i++) {
-		for (j = 0; j < rate_table->rate_cnt; j++) {
-			phy = rate_table->info[j].phy;
-			rate_flags = rate_table->info[j].rate_flags;
-			rate = rateset->rs_rates[i];
-			dot11rate = rate_table->info[j].dot11rate;
+	if ((rate_flags & WLAN_RC_CAP_MODE(capflag)) != WLAN_RC_CAP_MODE(capflag))
+		return false;
 
-			if (rate != dot11rate
-			    || ((rate_flags & WLAN_RC_CAP_MODE(capflag)) !=
-				WLAN_RC_CAP_MODE(capflag))
-			    || !(rate_flags & WLAN_RC_CAP_STREAM(capflag))
-			    || WLAN_RC_PHY_HT(phy))
-				continue;
+	if (!(rate_flags & WLAN_RC_CAP_STREAM(capflag)))
+		return false;
 
-			if (!ath_rc_valid_phyrate(phy, capflag, 0))
-				continue;
+	return true;
+}
 
-			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
-			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
-			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_priv->valid_rate_index[j] = true;
-			hi = max(hi, j);
-		}
-	}
+static inline bool ath_rc_check_ht(u8 rate, u8 dot11rate, u16 rate_flags,
+				   u32 phy, u32 capflag)
+{
+	if (rate != dot11rate || !WLAN_RC_PHY_HT(phy))
+		return false;
 
-	return hi;
+	if (!WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
+		return false;
+
+	if (!(rate_flags & WLAN_RC_CAP_STREAM(capflag)))
+		return false;
+
+	return true;
 }
 
-static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
+static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv, bool legacy)
 {
 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
-	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
+	struct ath_rateset *rateset;
 	u32 phy, capflag = ath_rc_priv->ht_cap;
 	u16 rate_flags;
 	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
 
+	if (legacy)
+		rateset = &ath_rc_priv->neg_rates;
+	else
+		rateset = &ath_rc_priv->neg_ht_rates;
+
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			phy = rate_table->info[j].phy;
@@ -555,9 +554,14 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
 			rate = rateset->rs_rates[i];
 			dot11rate = rate_table->info[j].dot11rate;
 
-			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
-			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
-			    !WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
+			if (legacy &&
+			    !ath_rc_check_legacy(rate, dot11rate,
+						 rate_flags, phy, capflag))
+				continue;
+
+			if (!legacy &&
+			    !ath_rc_check_ht(rate, dot11rate,
+					     rate_flags, phy, capflag))
 				continue;
 
 			if (!ath_rc_valid_phyrate(phy, capflag, 0))
@@ -1181,10 +1185,10 @@ static void ath_rc_init(struct ath_softc *sc,
 	if (!rateset->rs_nrates) {
 		hi = ath_rc_init_validrates(ath_rc_priv);
 	} else {
-		hi = ath_rc_setvalid_rates(ath_rc_priv);
+		hi = ath_rc_setvalid_rates(ath_rc_priv, true);
 
 		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG)
-			hthi = ath_rc_setvalid_htrates(ath_rc_priv);
+			hthi = ath_rc_setvalid_rates(ath_rc_priv, false);
 
 		hi = max(hi, hthi);
 	}
-- 
1.7.11.4

