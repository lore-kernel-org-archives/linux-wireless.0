Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7830 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab2HGBPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:15:06 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27593.328878.831452@gargle.gargle.HOWL> (sfid-20120807_031510_504238_10071DB0)
Date: Tue, 7 Aug 2012 06:43:45 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 04/14] ath9k: Cleanup ath_rc_setvalid_htrates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a34f678..69745ad 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -552,15 +552,16 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
 {
 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
 	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
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
+			phy = rate_table->info[j].phy;
+			rate_flags = rate_table->info[j].rate_flags;
+			rate = rateset->rs_rates[i];
+			dot11rate = rate_table->info[j].dot11rate;
 
 			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
 			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
@@ -570,8 +571,8 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
 			if (!ath_rc_valid_phyrate(phy, capflag, 0))
 				continue;
 
-			ath_rc_priv->valid_phy_rateidx[phy]
-				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
+			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
 			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
 			hi = max(hi, j);
-- 
1.7.11.4

