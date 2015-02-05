Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46444 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbbBEEtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:45 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENs-002ASp-98
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] ath9k: Check MCI PowerSave state
Date: Thu,  5 Feb 2015 10:22:41 +0530
Message-Id: <1423111964-19626-5-git-send-email-sujith@msujith.org> (sfid-20150205_054953_849090_95586BCF)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The power save state of MCI has to be disabled
when enabling WoW sleep, check this properly.
ar9003_mci_state() doesn't handle MCI_STATE_GET_WLAN_PS_STATE
right now, but this will be done later when proper
support for MCI/PS is added.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |  7 +++++++
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 19800af..cef2010 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -188,6 +188,13 @@ enum mci_bt_state {
 	MCI_BT_CAL
 };
 
+enum mci_ps_state {
+	MCI_PS_DISABLE,
+	MCI_PS_ENABLE,
+	MCI_PS_ENABLE_OFF,
+	MCI_PS_ENABLE_ON
+};
+
 /* Type of state query */
 enum mci_state_type {
 	MCI_STATE_ENABLE,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 721caf3..bf3378f0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -20,11 +20,25 @@
 #include "reg_wow.h"
 #include "hw-ops.h"
 
+static void ath9k_hw_set_sta_powersave(struct ath_hw *ah)
+{
+	if (!ath9k_hw_mci_is_enabled(ah))
+		goto set;
+	/*
+	 * If MCI is being used, set PWR_SAV only when MCI's
+	 * PS state is disabled.
+	 */
+	if (ar9003_mci_state(ah, MCI_STATE_GET_WLAN_PS_STATE) != MCI_PS_DISABLE)
+		return;
+set:
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+}
+
 static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	ath9k_hw_set_sta_powersave(ah);
 
 	/* set rx disable bit */
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
-- 
2.2.2

