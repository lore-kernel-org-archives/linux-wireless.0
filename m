Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19447 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1FOWBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 18:01:07 -0400
Subject: [PATCH 1/2] ath9k: use standard max(), remove A_MAX macro
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 15 Jun 2011 18:01:05 -0400
Message-ID: <20110615220105.1755.45521.stgit@mj.roinet.com> (sfid-20110616_000111_508379_26872E85)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/rc.c    |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3bf1d83..b9c177f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -54,8 +54,6 @@ struct ath_node;
 		(_l) &= ((_sz) - 1);		\
 	} while (0)
 
-#define A_MAX(a, b) ((a) > (b) ? (a) : (b))
-
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ba7f36a..e7fe4d9 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -533,7 +533,7 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 					[valid_rate_count] = j;
 				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
 				ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
-				hi = A_MAX(hi, j);
+				hi = max(hi, j);
 			}
 		}
 	}
@@ -569,7 +569,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
 			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
-			hi = A_MAX(hi, j);
+			hi = max(hi, j);
 		}
 	}
 
@@ -1228,7 +1228,7 @@ static void ath_rc_init(struct ath_softc *sc,
 						       ht_mcs,
 						       ath_rc_priv->ht_cap);
 		}
-		hi = A_MAX(hi, hthi);
+		hi = max(hi, hthi);
 	}
 
 	ath_rc_priv->rate_table_size = hi + 1;
