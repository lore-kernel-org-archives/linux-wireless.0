Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZGOAO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:27 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/21] ath9k: downgrade assert in rc.c for invalid rate
Date: Tue, 14 Jul 2009 20:13:54 -0400
Message-Id: <1247616853-11221-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The case where no vaid rate is found should not happen now
but to help debugging and downgrade this to a warn.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ba06e78..d7f4030 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -741,10 +741,18 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
-	ASSERT((rate_table->info[rate].valid &&
-		(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
-	       (rate_table->info[rate].valid_single_stream &&
-		!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
+	if (rate_table->info[rate].valid &&
+	    (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
+		return rate;
+
+	if (rate_table->info[rate].valid_single_stream &&
+	    !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG));
+		return rate;
+
+	/* This should not happen */
+	WARN_ON(1);
+
+	rate = ath_rc_priv->valid_rate_index[0];
 
 	return rate;
 }
-- 
1.6.0.6

