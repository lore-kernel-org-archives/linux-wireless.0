Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53454 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbBPFRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:23 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3e-000EUz-Dd
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] ath9k: Fix MCI TX control
Date: Mon, 16 Feb 2015 10:49:57 +0530
Message-Id: <1424064001-7009-6-git-send-email-sujith@msujith.org> (sfid-20150216_061727_840617_F118286C)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch makes sure that the antenna configuration
is used properly when setting AR_MCI_TX_CTRL.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 8 ++++++--
 drivers/net/wireless/ath/ath9k/ar9003_mci.h | 4 ++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 1a48528..aca9015 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -973,8 +973,12 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		  (SM(0xe801, AR_MCI_MSG_ATTRIBUTES_TABLE_INVALID_HDR) |
 		   SM(0x0000, AR_MCI_MSG_ATTRIBUTES_TABLE_CHECKSUM)));
 
-	REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
-		    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
+	if (MCI_ANT_ARCH_PA_LNA_SHARED(mci))
+		REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
+			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
+	else
+		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
+			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 
 	ar9003_mci_observation_set_up(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 6f305ab..174ebea 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -118,6 +118,10 @@ enum mci_gpm_coex_bt_update_flags_op {
 #define ATH_MCI_ANT_ARCH_2_ANT_PA_LNA_SHARED     0x03
 #define ATH_MCI_ANT_ARCH_3_ANT                   0x04
 
+#define MCI_ANT_ARCH_PA_LNA_SHARED(mci)					\
+	((MS(mci->config, ATH_MCI_CONFIG_ANT_ARCH) == ATH_MCI_ANT_ARCH_1_ANT_PA_LNA_SHARED) || \
+	 (MS(mci->config, ATH_MCI_CONFIG_ANT_ARCH) == ATH_MCI_ANT_ARCH_2_ANT_PA_LNA_SHARED))
+
 enum mci_message_header {		/* length of payload */
 	MCI_LNA_CTRL     = 0x10,        /* len = 0 */
 	MCI_CONT_NACK    = 0x20,        /* len = 0 */
-- 
2.3.0

