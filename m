Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:53593 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3IAIWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 04:22:17 -0400
Subject: [PATCH v2 1/2] ath10k: check chip id from the soc register during
 probe
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 11:22:14 +0300
Message-ID: <20130901082214.1930.61079.stgit@localhost6.localdomain6> (sfid-20130901_102236_551248_34045DB0)
In-Reply-To: <20130901082007.1930.79088.stgit@localhost6.localdomain6>
References: <20130901082007.1930.79088.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k doesn't support qca988x hw1.0 boards anymore. Unfortunately
the PCI id is the same in hw1.0 and hw2.0 so ath10k tries to use
hw1.0 boards anyway. But without hw1.0 workarounds in place
ath10k just crashes horribly.

To avoid using hw1.0 boards at all add a chip id detection
and fail the probe if hw1.0 is detected:

[ 5265.786408] ath10k: ERROR: qca988x hw1.0 is not supported
[ 5265.786497] ath10k: Unsupported chip id 0x043202ff
[ 5265.786574] ath10k: could not register driver core (-95)
[ 5265.793191] ath10k_pci: probe of 0000:02:00.0 failed with error -95

Also add a warning if there's an unknown chip id but continue
the boot process normally anyway.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   35 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |    3 ++-
 drivers/net/wireless/ath/ath10k/hw.h   |    8 +++++++
 drivers/net/wireless/ath/ath10k/pci.c  |   15 ++++++++++++--
 4 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 04c132e..2dd39a8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -706,10 +706,43 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	return 0;
 }
 
-int ath10k_core_register(struct ath10k *ar)
+static int ath10k_core_check_chip_id(struct ath10k *ar)
+{
+	u32 hw_revision = MS(ar->chip_id, SOC_CHIP_ID_REV);
+
+	/* Check that we are not using hw1.0 (some of them have same pci id
+	 * as hw2.0) before doing anything else as ath10k crashes horribly
+	 * due to missing hw1.0 workarounds. */
+	switch (hw_revision) {
+	case QCA988X_HW_1_0_CHIP_ID_REV:
+		ath10k_err("ERROR: qca988x hw1.0 is not supported\n");
+		return -EOPNOTSUPP;
+
+	case QCA988X_HW_2_0_CHIP_ID_REV:
+		/* known hardware revision, continue normally */
+		return 0;
+
+	default:
+		ath10k_warn("Warning: hardware revision unknown (0x%x), expect problems\n",
+			    ar->chip_id);
+		return 0;
+	}
+
+	return 0;
+}
+
+int ath10k_core_register(struct ath10k *ar, u32 chip_id)
 {
 	int status;
 
+	ar->chip_id = chip_id;
+
+	status = ath10k_core_check_chip_id(ar);
+	if (status) {
+		ath10k_err("Unsupported chip id 0x%08x\n", ar->chip_id);
+		return status;
+	}
+
 	status = ath10k_core_probe_fw(ar);
 	if (status) {
 		ath10k_err("could not probe fw (%d)\n", status);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ab05c4c..174c4b4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -284,6 +284,7 @@ struct ath10k {
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
 
+	u32 chip_id;
 	u32 target_version;
 	u8 fw_version_major;
 	u32 fw_version_minor;
@@ -403,7 +404,7 @@ void ath10k_core_destroy(struct ath10k *ar);
 
 int ath10k_core_start(struct ath10k *ar);
 void ath10k_core_stop(struct ath10k *ar);
-int ath10k_core_register(struct ath10k *ar);
+int ath10k_core_register(struct ath10k *ar, u32 chip_id);
 void ath10k_core_unregister(struct ath10k *ar);
 
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5708888..643f0c9 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -26,8 +26,12 @@
 #define SUPPORTED_FW_RELEASE	0
 #define SUPPORTED_FW_BUILD	636
 
+/* QCA988X 1.0 definitions (unsupported) */
+#define QCA988X_HW_1_0_CHIP_ID_REV	0x0
+
 /* QCA988X 2.0 definitions */
 #define QCA988X_HW_2_0_VERSION		0x4100016c
+#define QCA988X_HW_2_0_CHIP_ID_REV	0x2
 #define QCA988X_HW_2_0_FW_DIR		"ath10k/QCA988X/hw2.0"
 #define QCA988X_HW_2_0_FW_FILE		"firmware.bin"
 #define QCA988X_HW_2_0_OTP_FILE		"otp.bin"
@@ -164,6 +168,10 @@ enum ath10k_mcast2ucast_mode {
 #define SOC_LPO_CAL_ENABLE_LSB			20
 #define SOC_LPO_CAL_ENABLE_MASK			0x00100000
 
+#define SOC_CHIP_ID_ADDRESS			0x000000ec
+#define SOC_CHIP_ID_REV_LSB			8
+#define SOC_CHIP_ID_REV_MASK			0x00000f00
+
 #define WLAN_RESET_CONTROL_COLD_RST_MASK	0x00000008
 #define WLAN_RESET_CONTROL_WARM_RST_MASK	0x00000004
 #define WLAN_SYSTEM_SLEEP_DISABLE_LSB		0
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 29ccd04..622901d 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2390,7 +2390,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	int ret = 0;
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
-	u32 lcr_val;
+	u32 lcr_val, chip_id;
 
 	ath10k_dbg(ATH10K_DBG_PCI, "%s\n", __func__);
 
@@ -2492,7 +2492,18 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	spin_lock_init(&ar_pci->ce_lock);
 
-	ret = ath10k_core_register(ar);
+	ret = ath10k_do_pci_wake(ar);
+	if (ret) {
+		ath10k_err("Failed to get chip id: %d\n", ret);
+		return ret;
+	}
+
+	chip_id = ath10k_pci_read32(ar,
+				    RTC_SOC_BASE_ADDRESS + SOC_CHIP_ID_ADDRESS);
+
+	ath10k_do_pci_sleep(ar);
+
+	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err("could not register driver core (%d)\n", ret);
 		goto err_iomap;

