Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54478 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1K2O7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:59:12 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 10/17] ath9k: add MCI specific definitions and structures
Date: Tue, 29 Nov 2011 20:25:31 +0530
Message-ID: <1322578538-18912-11-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_155915_727007_D7156C45)
In-Reply-To: <1322578538-18912-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322578538-18912-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index 9590c61..5df0d60 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -17,6 +17,9 @@
 #ifndef MCI_H
 #define MCI_H
 
+#define ATH_MCI_SCHED_BUF_SIZE		(16 * 16) /* 16 entries, 4 dword each */
+#define ATH_MCI_GPM_MAX_ENTRY		16
+#define ATH_MCI_GPM_BUF_SIZE		(ATH_MCI_GPM_MAX_ENTRY * 16)
 #define ATH_MCI_DEF_BT_PERIOD		40
 #define ATH_MCI_BDR_DUTY_CYCLE		20
 #define ATH_MCI_MAX_DUTY_CYCLE		90
@@ -110,6 +113,20 @@ struct ath_mci_profile {
 	u8 num_bdr;
 };
 
+
+struct ath_mci_buf {
+	void *bf_addr;		/* virtual addr of desc */
+	dma_addr_t bf_paddr;    /* physical addr of buffer */
+	u32 bf_len;		/* len of data */
+};
+
+struct ath_mci_coex {
+	atomic_t mci_cal_flag;
+	struct ath_mci_buf sched_buf;
+	struct ath_mci_buf gpm_buf;
+	u32 bt_cal_start;
+};
+
 void ath_mci_flush_profile(struct ath_mci_profile *mci);
 void ath_mci_process_profile(struct ath_softc *sc,
 			     struct ath_mci_profile_info *info);
-- 
1.7.0.4

