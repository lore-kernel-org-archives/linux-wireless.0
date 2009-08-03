Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34812 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbZHCTZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:22 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 19/24] ath9k: rename ath9k_hw_ani_detach() to ath9k_hw_ani_disable()
Date: Mon, 3 Aug 2009 12:24:51 -0700
Message-ID: <1249327496-24629-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |    4 ++--
 drivers/net/wireless/ath/ath9k/ani.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a613cf4..b709312 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -822,9 +822,9 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 		ah->proc_phyerr |= HAL_PROCESS_ANI;
 }
 
-void ath9k_hw_ani_detach(struct ath_hw *ah)
+void ath9k_hw_ani_disable(struct ath_hw *ah)
 {
-	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Detach ANI\n");
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disabling ANI\n");
 
 	if (ah->has_hw_phycounters) {
 		ath9k_hw_disable_mib_counters(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 803669f..a36b7bb 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -133,6 +133,6 @@ void ath9k_hw_procmibevent(struct ath_hw *ah,
 			   const struct ath9k_node_stats *stats);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
-void ath9k_hw_ani_detach(struct ath_hw *ah);
+void ath9k_hw_ani_disable(struct ath_hw *ah);
 
 #endif /* ANI_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 73dee19..6641fbe 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1227,7 +1227,7 @@ const char *ath9k_hw_probe(u16 vendorid, u16 devid)
 void ath9k_hw_detach(struct ath_hw *ah)
 {
 	if (!AR_SREV_9100(ah))
-		ath9k_hw_ani_detach(ah);
+		ath9k_hw_ani_disable(ah);
 
 	ath9k_hw_rf_free(ah);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
-- 
1.6.3.3

