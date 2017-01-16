Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52748 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750840AbdAPPbT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 10:31:19 -0500
Subject: [PATCH] ath10k: dump Copy Engine registers during firmware crash
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 16 Jan 2017 17:31:08 +0200
Message-ID: <148458066842.22029.11182008791835649945.stgit@potku.adurom.net> (sfid-20170116_163122_506746_18A45E99)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Dump Copy Engine source and destination ring addresses.
This is useful information to debug firmware crashes, assertes or hangs over long run
assessing the Copy Engine Register status. This also enables dumping CE
register status in debugfs Crash Dump file.

Screenshot:

ath10k_pci 0000:02:00.0: simulating hard firmware crash
ath10k_pci 0000:02:00.0: firmware crashed! (uuid 84901ff5-d33c-456e-93ee-0165dea643cf)
ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.59-2 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 4159f498
ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
ath10k_pci 0000:02:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1
ath10k_pci 0000:02:00.0: firmware register dump:
ath10k_pci 0000:02:00.0: [00]: 0x4100016C 0x00000000 0x009A0F2A 0x00000000
ath10k_pci 0000:02:00.0: [04]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [08]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [12]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [16]: 0x00000000 0x00000000 0x00000000 0x009A0F2A
ath10k_pci 0000:02:00.0: [20]: 0x00000000 0x00401930 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [24]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [28]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [32]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [36]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [40]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [44]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [48]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [52]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: [56]: 0x00000000 0x00000000 0x00000000 0x00000000
ath10k_pci 0000:02:00.0: Copy Engine register dump:
ath10k_pci 0000:02:00.0: [00]: 0x00057400   7   7   3   3
ath10k_pci 0000:02:00.0: [01]: 0x00057800  18  18  85  86
ath10k_pci 0000:02:00.0: [02]: 0x00057c00  49  49  48  49
ath10k_pci 0000:02:00.0: [03]: 0x00058000  16  16  17  16
ath10k_pci 0000:02:00.0: [04]: 0x00058400   4   4  44   4
ath10k_pci 0000:02:00.0: [05]: 0x00058800  12  12  11  12
ath10k_pci 0000:02:00.0: [06]: 0x00058c00   3   3   3   3
ath10k_pci 0000:02:00.0: [07]: 0x00059000   0   0   0   0
ieee80211 phy0: Hardware restart was requested
ath10k_pci 0000:02:00.0: device successfully recovered

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
[kvalo@qca.qualcomm.com: simplify the implementation]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c    |   39 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ce.h    |    4 ++-
 drivers/net/wireless/ath/ath10k/core.h  |   16 +++++++++++++
 drivers/net/wireless/ath/ath10k/debug.c |   16 +++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |    3 ++
 drivers/net/wireless/ath/ath10k/pci.c   |    1 +
 6 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 0b4d79659884..c04e68796a20 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1130,3 +1130,42 @@ void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id)
 	ce_state->src_ring = NULL;
 	ce_state->dest_ring = NULL;
 }
+
+void ath10k_ce_dump_registers(struct ath10k *ar,
+			      struct ath10k_fw_crash_data *crash_data)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_crash_data ce;
+	u32 addr, id;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	ath10k_err(ar, "Copy Engine register dump:\n");
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	for (id = 0; id < CE_COUNT; id++) {
+		addr = ath10k_ce_base_address(ar, id);
+		ce.base_addr = cpu_to_le32(addr);
+
+		ce.src_wr_idx =
+			cpu_to_le32(ath10k_ce_src_ring_write_index_get(ar, addr));
+		ce.src_r_idx =
+			cpu_to_le32(ath10k_ce_src_ring_read_index_get(ar, addr));
+		ce.dst_wr_idx =
+			cpu_to_le32(ath10k_ce_dest_ring_write_index_get(ar, addr));
+		ce.dst_r_idx =
+			cpu_to_le32(ath10k_ce_dest_ring_read_index_get(ar, addr));
+
+		if (crash_data)
+			crash_data->ce_crash_data[id] = ce;
+
+		ath10k_err(ar, "[%02d]: 0x%08x %3u %3u %3u %3u", id,
+			   le32_to_cpu(ce.base_addr),
+			   le32_to_cpu(ce.src_wr_idx),
+			   le32_to_cpu(ce.src_r_idx),
+			   le32_to_cpu(ce.dst_wr_idx),
+			   le32_to_cpu(ce.dst_r_idx));
+	}
+
+	spin_unlock_bh(&ar_pci->ce_lock);
+}
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index dfc098606bee..e76a98242b98 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -20,8 +20,6 @@
 
 #include "hif.h"
 
-/* Maximum number of Copy Engine's supported */
-#define CE_COUNT_MAX 12
 #define CE_HTT_H2T_MSG_SRC_NENTRIES 8192
 
 /* Descriptor rings must be aligned to this boundary */
@@ -228,6 +226,8 @@ void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_disable_interrupts(struct ath10k *ar);
 void ath10k_ce_enable_interrupts(struct ath10k *ar);
+void ath10k_ce_dump_registers(struct ath10k *ar,
+			      struct ath10k_fw_crash_data *crash_data);
 
 /* ce_attr.flags values */
 /* Use NonSnooping PCIe accesses? */
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c7664d6569fa..7a6fcea760f0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -419,6 +419,21 @@ struct ath10k_vif_iter {
 	struct ath10k_vif *arvif;
 };
 
+/* Copy Engine register dump, protected by ce-lock */
+struct ath10k_ce_crash_data {
+	__le32 base_addr;
+	__le32 src_wr_idx;
+	__le32 src_r_idx;
+	__le32 dst_wr_idx;
+	__le32 dst_r_idx;
+};
+
+struct ath10k_ce_crash_hdr {
+	__le32 ce_count;
+	__le32 reserved[3]; /* for future use */
+	struct ath10k_ce_crash_data entries[];
+};
+
 /* used for crash-dump storage, protected by data-lock */
 struct ath10k_fw_crash_data {
 	bool crashed_since_read;
@@ -426,6 +441,7 @@ struct ath10k_fw_crash_data {
 	uuid_le uuid;
 	struct timespec timestamp;
 	__le32 registers[REG_DUMP_COUNT_QCA988X];
+	struct ath10k_ce_crash_data ce_crash_data[CE_COUNT_MAX];
 };
 
 struct ath10k_debug {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index b882b0892dcf..d5ff0f4ef5ce 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -41,6 +41,7 @@
  */
 enum ath10k_fw_crash_dump_type {
 	ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
+	ATH10K_FW_CRASH_DUMP_CE_DATA = 1,
 
 	ATH10K_FW_CRASH_DUMP_MAX,
 };
@@ -729,6 +730,7 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar,
 							    bool mark_read)
 {
 	struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
+	struct ath10k_ce_crash_hdr *ce_hdr;
 	struct ath10k_dump_file_data *dump_data;
 	struct ath10k_tlv_dump_data *dump_tlv;
 	int hdr_len = sizeof(*dump_data);
@@ -737,6 +739,8 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar,
 
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
+	len += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
+		CE_COUNT * sizeof(ce_hdr->entries[0]);
 
 	sofar += hdr_len;
 
@@ -795,6 +799,18 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar,
 	       sizeof(crash_data->registers));
 	sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 
+	dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
+	dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_CE_DATA);
+	dump_tlv->tlv_len = cpu_to_le32(sizeof(*ce_hdr) +
+					CE_COUNT * sizeof(ce_hdr->entries[0]));
+	ce_hdr = (struct ath10k_ce_crash_hdr *)(dump_tlv->tlv_data);
+	ce_hdr->ce_count = cpu_to_le32(CE_COUNT);
+	memset(ce_hdr->reserved, 0, sizeof(ce_hdr->reserved));
+	memcpy(ce_hdr->entries, crash_data->ce_crash_data,
+	       CE_COUNT * sizeof(ce_hdr->entries[0]));
+	sofar += sizeof(*dump_tlv) + sizeof(*ce_hdr) +
+		 CE_COUNT * sizeof(ce_hdr->entries[0]);
+
 	ar->debug.fw_crash_data->crashed_since_read = !mark_read;
 
 	spin_unlock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7feffec531cc..38aa7c95732e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -578,6 +578,9 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define TARGET_10_4_IPHDR_PAD_CONFIG		1
 #define TARGET_10_4_QWRAP_CONFIG		0
 
+/* Maximum number of Copy Engine's supported */
+#define CE_COUNT_MAX 12
+
 /* Number of Copy Engines supported */
 #define CE_COUNT ar->hw_values->ce_count
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 93b9790cfe8d..95ccd6db7623 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1474,6 +1474,7 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 	ath10k_err(ar, "firmware crashed! (uuid %s)\n", uuid);
 	ath10k_print_driver_info(ar);
 	ath10k_pci_dump_registers(ar, crash_data);
+	ath10k_ce_dump_registers(ar, crash_data);
 
 	spin_unlock_bh(&ar->data_lock);
 
