Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47433 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3L1EW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 7/7] ath9k: Fix interrupt statistics
Date: Sat, 28 Dec 2013 09:47:15 +0530
Message-Id: <1388204235-14682-7-git-send-email-sujith@msujith.org> (sfid-20131228_052248_526588_FB3BD2EB)
In-Reply-To: <1388204235-14682-1-git-send-email-sujith@msujith.org>
References: <1388204235-14682-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Initialize "sync_cause" to zero since commit
"ath9k: move ath9k_debug_sync_cause out of ath9k_hw"
fills it conditionally based on ISR status.
Not doing this results in garbage values in debugfs.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2f3e7b4..d0c3aec 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -544,7 +544,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath9k_int status;
-	u32 sync_cause;
+	u32 sync_cause = 0;
 	bool sched = false;
 
 	/*
-- 
1.8.5.2

