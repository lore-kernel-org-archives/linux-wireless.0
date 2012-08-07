Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7787 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab2HGBO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:14:59 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27585.897541.55743@gargle.gargle.HOWL> (sfid-20120807_031501_723069_0B91C0C1)
Date: Tue, 7 Aug 2012 06:43:37 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 03/14] ath9k: Cleanup ath_rc_setvalid_rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 49 ++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 49c71da..a34f678 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -516,39 +516,32 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
 {
 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
-	u32 capflag = ath_rc_priv->ht_cap;
-	u8 i, j, hi = 0;
+	u32 phy, capflag = ath_rc_priv->ht_cap;
+	u16 rate_flags;
+	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
 
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
-			u32 phy = rate_table->info[j].phy;
-			u16 rate_flags = rate_table->info[j].rate_flags;
-			u8 rate = rateset->rs_rates[i];
-			u8 dot11rate = rate_table->info[j].dot11rate;
-
-			/* We allow a rate only if its valid and the
-			 * capflag matches one of the validity
-			 * (VALID/VALID_20/VALID_40) flags */
-
-			if ((rate == dot11rate) &&
-			    (rate_flags & WLAN_RC_CAP_MODE(capflag)) ==
-			    WLAN_RC_CAP_MODE(capflag) &&
-			    (rate_flags & WLAN_RC_CAP_STREAM(capflag)) &&
-			    !WLAN_RC_PHY_HT(phy)) {
-				u8 valid_rate_count = 0;
-
-				if (!ath_rc_valid_phyrate(phy, capflag, 0))
-					continue;
+			phy = rate_table->info[j].phy;
+			rate_flags = rate_table->info[j].rate_flags;
+			rate = rateset->rs_rates[i];
+			dot11rate = rate_table->info[j].dot11rate;
+
+			if (rate != dot11rate
+			    || ((rate_flags & WLAN_RC_CAP_MODE(capflag)) !=
+				WLAN_RC_CAP_MODE(capflag))
+			    || !(rate_flags & WLAN_RC_CAP_STREAM(capflag))
+			    || WLAN_RC_PHY_HT(phy))
+				continue;
 
-				valid_rate_count =
-					ath_rc_priv->valid_phy_ratecnt[phy];
+			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+				continue;
 
-				ath_rc_priv->valid_phy_rateidx[phy]
-					[valid_rate_count] = j;
-				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-				ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
-				hi = max(hi, j);
-			}
+			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+			hi = max(hi, j);
 		}
 	}
 
-- 
1.7.11.4

