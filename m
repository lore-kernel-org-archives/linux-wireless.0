Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63199 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HJLRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:17:52 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20516.60821.809262.268863@gargle.gargle.HOWL> (sfid-20120810_131754_837026_D1F56D74)
Date: Fri, 10 Aug 2012 16:46:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/15] ath9k: Remove ath_rc_set_valid_rate_idx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e8f8e3d..8a5fc62 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -424,13 +424,6 @@ static void ath_rc_sort_validrates(struct ath_rate_priv *ath_rc_priv)
 	}
 }
 
-static inline void ath_rc_set_valid_rate_idx(struct ath_rate_priv *ath_rc_priv,
-					   u8 index, int valid_tx_rate)
-{
-	BUG_ON(index > ath_rc_priv->rate_table_size);
-	ath_rc_priv->valid_rate_index[index] = !!valid_tx_rate;
-}
-
 static inline
 int ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
 				struct ath_rate_priv *ath_rc_priv,
@@ -503,7 +496,7 @@ static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv)
 
 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = i;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_rate_idx(ath_rc_priv, i, 1);
+			ath_rc_priv->valid_rate_index[i] = true;
 			hi = i;
 		}
 	}
@@ -539,7 +532,7 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+			ath_rc_priv->valid_rate_index[j] = true;
 			hi = max(hi, j);
 		}
 	}
@@ -573,7 +566,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+			ath_rc_priv->valid_rate_index[j] = true;
 			hi = max(hi, j);
 		}
 	}
-- 
1.7.11.4

