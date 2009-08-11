Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34952 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZHKSgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 14:36:37 -0400
Received: by ewy10 with SMTP id 10so4005359ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 11:36:36 -0700 (PDT)
Message-ID: <4A81BB1E.6040904@gmail.com>
Date: Tue, 11 Aug 2009 20:40:30 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ath9k: Prevent read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent a read from valid_rate_index[] with a negative index

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Maybe we should add this?

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ba06e78..a67b7f6 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1458,7 +1458,7 @@ static void ath_rc_init(struct ath_softc *sc,
 		ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
 	}
 	ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
-	ASSERT(k <= RATE_TABLE_SIZE);
+	ASSERT(k <= RATE_TABLE_SIZE && k >= 4);
 
 	ath_rc_priv->max_valid_rate = k;
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
