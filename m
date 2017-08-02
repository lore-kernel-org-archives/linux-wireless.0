Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37145 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752146AbdHBN56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 09:57:58 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] ath10k: Switch to use new generic UUID API
Date: Wed,  2 Aug 2017 16:57:25 +0300
Message-Id: <20170802135725.9317-1-andriy.shevchenko@linux.intel.com> (sfid-20170802_155802_222249_0C2EF2C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are new types and helpers that are supposed to be used in new code.

As a preparation to get rid of legacy types and API functions do
the conversion here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 2 +-
 drivers/net/wireless/ath/ath10k/debug.c | 6 +++---
 drivers/net/wireless/ath/ath10k/pci.c   | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2b499af722ad..4b13e0078cf6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -459,7 +459,7 @@ struct ath10k_ce_crash_hdr {
 struct ath10k_fw_crash_data {
 	bool crashed_since_read;
 
-	uuid_le uuid;
+	guid_t guid;
 	struct timespec timestamp;
 	__le32 registers[REG_DUMP_COUNT_QCA988X];
 	struct ath10k_ce_crash_data ce_crash_data[CE_COUNT_MAX];
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 56404fe4e8f5..df514507d3f1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -70,7 +70,7 @@ struct ath10k_dump_file_data {
 
 	/* some info we can get from ath10k struct that might help */
 
-	u8 uuid[16];
+	guid_t guid;
 
 	__le32 chip_id;
 
@@ -719,7 +719,7 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 	lockdep_assert_held(&ar->data_lock);
 
 	crash_data->crashed_since_read = true;
-	uuid_le_gen(&crash_data->uuid);
+	guid_gen(&crash_data->guid);
 	getnstimeofday(&crash_data->timestamp);
 
 	return crash_data;
@@ -766,7 +766,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar,
 
 	dump_data->version = cpu_to_le32(ATH10K_FW_CRASH_DUMP_VERSION);
 
-	memcpy(dump_data->uuid, &crash_data->uuid, sizeof(dump_data->uuid));
+	guid_copy(&dump_data->guid, &crash_data->guid);
 	dump_data->chip_id = cpu_to_le32(ar->chip_id);
 	dump_data->bus_type = cpu_to_le32(0);
 	dump_data->target_version = cpu_to_le32(ar->target_version);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a697caec6579..0a5b88e80214 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1463,7 +1463,7 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data;
-	char uuid[50];
+	char guid[UUID_STRING_LEN + 1];
 
 	spin_lock_bh(&ar->data_lock);
 
@@ -1472,11 +1472,11 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	crash_data = ath10k_debug_get_new_fw_crash_data(ar);
 
 	if (crash_data)
-		scnprintf(uuid, sizeof(uuid), "%pUl", &crash_data->uuid);
+		scnprintf(guid, sizeof(guid), "%pUl", &crash_data->guid);
 	else
-		scnprintf(uuid, sizeof(uuid), "n/a");
+		scnprintf(guid, sizeof(guid), "n/a");
 
-	ath10k_err(ar, "firmware crashed! (uuid %s)\n", uuid);
+	ath10k_err(ar, "firmware crashed! (guid %s)\n", guid);
 	ath10k_print_driver_info(ar);
 	ath10k_pci_dump_registers(ar, crash_data);
 	ath10k_ce_dump_registers(ar, crash_data);
-- 
2.13.2
