Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2JOKB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:01:28 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 05/11] ath9k_hw: Disable MCI stat counter by default for AR9565
Date: Mon, 15 Oct 2012 15:29:49 +0530
Message-ID: <1350295195-23410-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_120143_720728_04FB7AFE)
In-Reply-To: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 3 +++
 drivers/net/wireless/ath/ath9k/reg.h        | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index c46d8f1..87d9c34 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -938,6 +938,9 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	mci->ready = true;
 	ar9003_mci_prep_interface(ah);
 
+	if (AR_SREV_9565(ah))
+		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
+			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
 	if (en_int)
 		ar9003_mci_enable_interrupt(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c7a9ea7..8f40dba 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2363,5 +2363,8 @@ enum {
 #define AR_MCI_MISC                    0x1a74
 #define AR_MCI_MISC_HW_FIX_EN          0x00000001
 #define AR_MCI_MISC_HW_FIX_EN_S        0
+#define AR_MCI_DBG_CNT_CTRL            0x1a78
+#define AR_MCI_DBG_CNT_CTRL_ENABLE     0x00000001
+#define AR_MCI_DBG_CNT_CTRL_ENABLE_S   0
 
 #endif
-- 
1.7.12.2

