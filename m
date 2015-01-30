Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39988 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbbA3Nc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:57 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgu-004FiR-MQ
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 13/17] ath9k: Register max WOW patterns
Date: Fri, 30 Jan 2015 19:05:33 +0530
Message-Id: <1422624937-4810-14-git-send-email-sujith@msujith.org> (sfid-20150130_143630_273336_477E7B34)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the number of patterns that can be configured in
the HW is higher for newer chips, store the chip-specific
value in ath9k_hw_wow.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 +++++++
 drivers/net/wireless/ath/ath9k/hw.h | 4 +++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8c2f9e2..60aa8d7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2548,6 +2548,13 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 
+#ifdef CONFIG_ATH9K_WOW
+	if (AR_SREV_9462_20_OR_LATER(ah) || AR_SREV_9565_11_OR_LATER(ah))
+		ah->wow.max_patterns = MAX_NUM_PATTERN;
+	else
+		ah->wow.max_patterns = MAX_NUM_PATTERN_LEGACY;
+#endif
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d36210a..e1801c9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -204,7 +204,8 @@
 
 #define MAX_PATTERN_SIZE		256
 #define MAX_PATTERN_MASK_SIZE		32
-#define MAX_NUM_PATTERN			8
+#define MAX_NUM_PATTERN			16
+#define MAX_NUM_PATTERN_LEGACY		8
 #define MAX_NUM_USER_PATTERN		6 /*  deducting the disassociate and
 					      deauthenticate packets */
 
@@ -272,6 +273,7 @@ enum ath9k_hw_caps {
 
 struct ath9k_hw_wow {
 	u32 wow_event_mask;
+	u8 max_patterns;
 };
 
 struct ath9k_hw_capabilities {
-- 
2.2.2

