Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:48467 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3H3HRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 03:17:08 -0400
Subject: [PATCH] ath10k: check chip id from the soc register during probe
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 10:17:03 +0300
Message-ID: <20130830071703.14206.21974.stgit@localhost6.localdomain6> (sfid-20130830_091712_222761_515D5918)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k doesn't support qca988x hw1.0 boards anymore. Unfortunately
the PCI id is the same in hw1.0 and hw2.0 so ath10k tries to use
hw1.0 boards anyway. But without hw1.0 workarounds in place
ath10k just crashes horribly.

To avoid using hw1.0 boards at all add a chip id detection
to ath10k_pci_probe() and fail the probe if hw1.0 id is found.
Also add a warning if there's an unknown chip id but continue
the boot process normally anyway.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |    5 +++++
 drivers/net/wireless/ath/ath10k/pci.c |   26 +++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5708888..933d05d 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -26,8 +26,12 @@
 #define SUPPORTED_FW_RELEASE	0
 #define SUPPORTED_FW_BUILD	636
 
+/* QCA988X 1.0 definitions (unsupported) */
+#define QCA988X_HW_1_0_CHIP_ID		0x043000ff
+
 /* QCA988X 2.0 definitions */
 #define QCA988X_HW_2_0_VERSION		0x4100016c
+#define QCA988X_HW_2_0_CHIP_ID		0x043002ff
 #define QCA988X_HW_2_0_FW_DIR		"ath10k/QCA988X/hw2.0"
 #define QCA988X_HW_2_0_FW_FILE		"firmware.bin"
 #define QCA988X_HW_2_0_OTP_FILE		"otp.bin"
@@ -163,6 +167,7 @@ enum ath10k_mcast2ucast_mode {
 #define SOC_LPO_CAL_OFFSET			0x000000e0
 #define SOC_LPO_CAL_ENABLE_LSB			20
 #define SOC_LPO_CAL_ENABLE_MASK			0x00100000
+#define SOC_CHIP_ID_ADDRESS			0x000000ec
 
 #define WLAN_RESET_CONTROL_COLD_RST_MASK	0x00000008
 #define WLAN_RESET_CONTROL_WARM_RST_MASK	0x00000004
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 996efdd..c9e5741a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2290,7 +2290,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	int ret = 0;
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
-	u32 lcr_val;
+	u32 lcr_val, chip_id;
 
 	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
 
@@ -2394,6 +2394,30 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ar_pci->cacheline_sz = dma_get_cache_alignment();
 
+	ath10k_do_pci_wake(ar);
+	chip_id = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS + SOC_CHIP_ID_ADDRESS);
+	ath10k_do_pci_sleep(ar);
+
+	/* Check that we are not using hw1.0 (some of them have same pci id
+	 * as hw2.0) before doing anything else as ath10k crashes horribly
+	 * due to missing hw1.0 workarounds. */
+	switch (chip_id) {
+	case QCA988X_HW_1_0_CHIP_ID:
+		ath10k_err("ERROR: qca988x hw1.0 (0x%08x) is not supported\n",
+			   chip_id);
+		ret = -EOPNOTSUPP;
+		goto err_iomap;
+
+	case QCA988X_HW_2_0_CHIP_ID:
+		/* known chip id, continue normally */
+		break;
+
+	default:
+		ath10k_warn("Warning: chip id 0x%08x is not known, expect problems\n",
+			   chip_id);
+		break;
+	}
+	
 	ret = ath10k_core_register(ar);
 	if (ret) {
 		ath10k_err("could not register driver core (%d)\n", ret);

