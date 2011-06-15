Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20429 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1FOMzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 08:55:39 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 05:55:04 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	<susinder@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>
Subject: [PATCH] ath9k: Add debug messages to track PAPRD failures
Date: Wed, 15 Jun 2011 18:25:31 +0530
Message-ID: <1308142531-21062-1-git-send-email-mshajakhan@atheros.com> (sfid-20110615_145542_732990_CF15EE6F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Add few debug messages for some of the possible scenarios
where we can detect PAPRD failures. this will help us to be
sure that we had really enabled PAPRD

Cc: susinder@qca.qualcomm.com
Cc: senthilb@qca.qualcomm.com
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7f94533..e0e0e86 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -360,7 +360,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	txctl.paprd = BIT(chain);
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		ath_dbg(common, ATH_DBG_XMIT, "PAPRD TX failed\n");
+		ath_dbg(common, ATH_DBG_CALIBRATE, "PAPRD TX failed\n");
 		dev_kfree_skb_any(skb);
 		return false;
 	}
@@ -369,7 +369,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 			msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
 
 	if (!time_left)
-		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CALIBRATE,
+		ath_dbg(common, ATH_DBG_CALIBRATE,
 			"Timeout waiting for paprd training on TX chain %d\n",
 			chain);
 
@@ -431,11 +431,18 @@ void ath_paprd_calibrate(struct work_struct *work)
 		if (!ath_paprd_send_frame(sc, skb, chain))
 			goto fail_paprd;
 
-		if (!ar9003_paprd_is_done(ah))
+		if (!ar9003_paprd_is_done(ah)) {
+			ath_dbg(common, ATH_DBG_CALIBRATE,
+				"PAPRD not yet done on chain %d\n", chain);
 			break;
+		}
 
-		if (ar9003_paprd_create_curve(ah, caldata, chain) != 0)
+		if (ar9003_paprd_create_curve(ah, caldata, chain)) {
+			ath_dbg(common, ATH_DBG_CALIBRATE,
+				"PAPRD create curve failed on chain %d\n",
+								   chain);
 			break;
+		}
 
 		chain_ok = 1;
 	}
-- 
1.7.0.4

