Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46724 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 015/102] ath9k_hw: move init config and default after chip is up
Date: Thu,  8 Apr 2010 15:26:11 -0400
Message-Id: <1270754858-26266-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to add SREV checks on these helpers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 655da06..5c267aa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -881,15 +881,15 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	ath9k_hw_init_defaults(ah);
-	ath9k_hw_init_config(ah);
-
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Couldn't reset chip\n");
 		return -EIO;
 	}
 
+	ath9k_hw_init_defaults(ah);
+	ath9k_hw_init_config(ah);
+
 	ath9k_hw_attach_ops(ah);
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-- 
1.6.3.3

