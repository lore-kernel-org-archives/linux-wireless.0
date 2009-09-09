Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/15] ath9k: move bt_stomp_type to driver core
Date: Wed,  9 Sep 2009 19:44:54 -0400
Message-Id: <1252539901-20679-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bt_stomp_type defines the bt coex weight, it has a one-to-one
mapping. In the future we may want to just use the weight directly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    9 +++++++++
 drivers/net/wireless/ath/ath9k/btcoex.c |    2 --
 drivers/net/wireless/ath/ath9k/btcoex.h |    8 --------
 drivers/net/wireless/ath/ath9k/main.c   |    7 ++++---
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 891e71b..d99c92d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -450,12 +450,21 @@ struct ath_ani {
 	struct timer_list timer;
 };
 
+/* Defines the BT AR_BT_COEX_WGHT used */
+enum ath_stomp_type {
+	ATH_BTCOEX_NO_STOMP,
+	ATH_BTCOEX_STOMP_ALL,
+	ATH_BTCOEX_STOMP_LOW,
+	ATH_BTCOEX_STOMP_NONE
+};
+
 struct ath_btcoex {
 	bool hw_timer_enabled;
 	spinlock_t btcoex_lock;
 	struct timer_list period_timer; /* Timer for BT period */
 	u32 bt_priority_cnt;
 	unsigned long bt_priority_time;
+	int bt_stomp_type; /* Types of BT stomping */
 	u32 btcoex_no_stomp; /* in usec */
 	u32 btcoex_period; /* in usec */
 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 91befc7..ab19072 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -65,8 +65,6 @@ void ath9k_hw_init_btcoex_hw_info(struct ath_hw *ah, int qnum)
 		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
 		AR_BT_DISABLE_BT_ANT;
 
-	btcoex_info->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-
 	for (i = 0; i < 32; i++)
 		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
 }
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index b2c3f76..d932f01 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -36,13 +36,6 @@ enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_3WIRE,
 };
 
-enum ath_stomp_type {
-	ATH_BTCOEX_NO_STOMP,
-	ATH_BTCOEX_STOMP_ALL,
-	ATH_BTCOEX_STOMP_LOW,
-	ATH_BTCOEX_STOMP_NONE
-};
-
 enum ath_bt_mode {
 	ATH_BT_COEX_MODE_LEGACY,	/* legacy rx_clear mode */
 	ATH_BT_COEX_MODE_UNSLOTTED,	/* untimed/unslotted mode */
@@ -69,7 +62,6 @@ struct ath_btcoex_info {
 	u8 btactive_gpio;
 	u8 btpriority_gpio;
 	u8 bt_duty_cycle; 	/* BT duty cycle in percentage */
-	int bt_stomp_type; 	/* Types of BT stomping */
 	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
 	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 90be4ed..bc3b9b0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1395,7 +1395,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath_btcoex_bt_stomp(sc, btinfo, btinfo->bt_stomp_type);
+	ath_btcoex_bt_stomp(sc, btinfo, btcoex->bt_stomp_type);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
@@ -1430,9 +1430,9 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
+	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW)
 		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_NONE);
-	 else if (btinfo->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath_btcoex_bt_stomp(sc, btinfo, ATH_BTCOEX_STOMP_LOW);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
@@ -1691,6 +1691,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 			goto bad2;
 		qnum = ath_tx_get_qnum(sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
 		ath9k_hw_init_btcoex_hw_info(ah, qnum);
+		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		break;
 	default:
 		WARN_ON(1);
-- 
1.6.3.3

