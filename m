Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:34693
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab2LGKCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:02:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 4/8] ath9k: Fix redundant PS wrappers
Date: Fri,  7 Dec 2012 15:31:57 +0530
Message-Id: <1354874521-4138-5-git-send-email-sujith@msujith.org> (sfid-20121207_110252_277583_C63F23E4)
In-Reply-To: <1354874521-4138-1-git-send-email-sujith@msujith.org>
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Move the PowerSave wrappers outside ath_paprd_activate(),
since they are already being used in ath_paprd_calibrate().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/link.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 3c996ff..c70b31a 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -188,7 +188,6 @@ static void ath_paprd_activate(struct ath_softc *sc)
 		return;
 	}
 
-	ath9k_ps_wakeup(sc);
 	ar9003_paprd_enable(ah, false);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
 		if (!(ah->txchainmask & BIT(chain)))
@@ -199,7 +198,6 @@ static void ath_paprd_activate(struct ath_softc *sc)
 
 	ath_dbg(common, CALIBRATE, "Activating PAPRD\n");
 	ar9003_paprd_enable(ah, true);
-	ath9k_ps_restore(sc);
 }
 
 static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int chain)
@@ -436,11 +434,15 @@ set_timer:
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
+
 	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD) && ah->caldata) {
-		if (!ah->caldata->paprd_done)
+		if (!ah->caldata->paprd_done) {
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
-		else if (!ah->paprd_table_write_done)
+		} else if (!ah->paprd_table_write_done) {
+			ath9k_ps_wakeup(sc);
 			ath_paprd_activate(sc);
+			ath9k_ps_restore(sc);
+		}
 	}
 }
 
-- 
1.8.0.1

