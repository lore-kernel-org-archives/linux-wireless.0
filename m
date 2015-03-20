Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54939 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbCTNlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:41:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Fix compilation error
Date: Fri, 20 Mar 2015 19:14:50 +0530
Message-Id: <1426859090-10153-1-git-send-email-sujith@msujith.org> (sfid-20150320_144150_488649_F0F7FAA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

AIC needs to be registered only when BTCOEX is enabled.
This fixes the error reported by kbuild:

>> ERROR: "ar9003_hw_attach_aic_ops" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c22edd3..aaec945 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1117,8 +1117,6 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah);
 int ar9002_hw_attach_ops(struct ath_hw *ah);
 void ar9003_hw_attach_ops(struct ath_hw *ah);
 
-void ar9003_hw_attach_aic_ops(struct ath_hw *ah);
-
 void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
 
 void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
@@ -1129,6 +1127,7 @@ void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us);
 void ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+void ar9003_hw_attach_aic_ops(struct ath_hw *ah);
 static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 {
 	return ah->btcoex_hw.enabled;
@@ -1146,6 +1145,9 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 	return ah->btcoex_hw.scheme;
 }
 #else
+static inline void ar9003_hw_attach_aic_ops(struct ath_hw *ah)
+{
+}
 static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 {
 	return false;
-- 
2.3.1

