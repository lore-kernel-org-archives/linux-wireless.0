Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51695 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1LJNaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 08:30:16 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>, Paul Stewart <pstew@google.com>
Subject: [PATCH] ath9k: fix max phy rate at rate control init
Date: Sat, 10 Dec 2011 18:59:43 +0530
Message-ID: <1323523783-536-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111210_143022_348560_0D357812)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The stations always chooses 1Mbps for all trasmitting frames,
whenever the AP is configured to lock the supported rates.
As the max phy rate is always set with the 4th from highest phy rate,
this assumption might be wrong if we have less than that. Fix that.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Reported-by: Ajay Gummalla <agummalla@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 888abc2..528d5f3 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1271,7 +1271,9 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	ath_rc_priv->max_valid_rate = k;
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
-	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
+	ath_rc_priv->rate_max_phy = (k > 4) ?
+					ath_rc_priv->valid_rate_index[k-4] :
+					ath_rc_priv->valid_rate_index[k-1];
 	ath_rc_priv->rate_table = rate_table;
 
 	ath_dbg(common, ATH_DBG_CONFIG,
-- 
1.7.8

