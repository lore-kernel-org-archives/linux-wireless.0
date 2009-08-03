Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34810 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZHCTZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:20 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 18/24] ath9k: rename ath9k_hw_rfdetach() to ath9k_hw_rf_free()
Date: Mon, 3 Aug 2009 12:24:50 -0700
Message-ID: <1249327496-24629-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it clear what this does.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h  |    2 +-
 drivers/net/wireless/ath/ath9k/phy.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 65d2e7d..73dee19 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1229,7 +1229,7 @@ void ath9k_hw_detach(struct ath_hw *ah)
 	if (!AR_SREV_9100(ah))
 		ath9k_hw_ani_detach(ah);
 
-	ath9k_hw_rfdetach(ah);
+	ath9k_hw_rf_free(ah);
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 	kfree(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4c78e8c..4e717cc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -545,7 +545,7 @@ struct ath_hw {
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
-void ath9k_hw_rfdetach(struct ath_hw *ah);
+void ath9k_hw_rf_free(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
 void ath9k_hw_fill_cap_info(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 98b1b56..59bb3ce 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -264,7 +264,7 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 }
 
 void
-ath9k_hw_rfdetach(struct ath_hw *ah)
+ath9k_hw_rf_free(struct ath_hw *ah)
 {
 #define ATH_FREE_BANK(bank) do { \
 		kfree(bank); \
-- 
1.6.3.3

