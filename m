Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51098 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaHYK3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 06:29:14 -0400
Received: by mail-lb0-f173.google.com with SMTP id u10so11981531lbd.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 03:29:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/3] ath10k: make target endianess more explicit
Date: Mon, 25 Aug 2014 12:19:23 +0200
Message-Id: <1408961963-3682-4-git-send-email-michal.kazior@tieto.com> (sfid-20140825_122919_076345_CB867C67)
In-Reply-To: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
References: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some copy engine structures are target specific
and are uploaded to the device during
init/configuration.

This also cleans up a bit diag_mem_read/write
implicit byteswap mess leaving only
diag_access_read/write with an implicit endianess
byteswap.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * create _diag_write32()
     * use _diag_read32()
     * fix checkpatch warnings (over 80 chars on some lines)

 drivers/net/wireless/ath/ath10k/pci.c | 259 +++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h |  18 +--
 2 files changed, 140 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index fa0e245..4c8e8261 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -149,74 +149,74 @@ static const struct ce_attr host_ce_config_wlan[] = {
 static const struct ce_pipe_config target_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
 	{
-		.pipenum = 0,
-		.pipedir = PIPEDIR_OUT,
-		.nentries = 32,
-		.nbytes_max = 256,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(0),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(256),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* CE1: target->host HTT + HTC control */
 	{
-		.pipenum = 1,
-		.pipedir = PIPEDIR_IN,
-		.nentries = 32,
-		.nbytes_max = 512,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(1),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(512),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* CE2: target->host WMI */
 	{
-		.pipenum = 2,
-		.pipedir = PIPEDIR_IN,
-		.nentries = 32,
-		.nbytes_max = 2048,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(2),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* CE3: host->target WMI */
 	{
-		.pipenum = 3,
-		.pipedir = PIPEDIR_OUT,
-		.nentries = 32,
-		.nbytes_max = 2048,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(3),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* CE4: host->target HTT */
 	{
-		.pipenum = 4,
-		.pipedir = PIPEDIR_OUT,
-		.nentries = 256,
-		.nbytes_max = 256,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(4),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(256),
+		.nbytes_max = __cpu_to_le32(256),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* NB: 50% of src nentries, since tx has 2 frags */
 
 	/* CE5: unused */
 	{
-		.pipenum = 5,
-		.pipedir = PIPEDIR_OUT,
-		.nentries = 32,
-		.nbytes_max = 2048,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(5),
+		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(2048),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* CE6: Reserved for target autonomous hif_memcpy */
 	{
-		.pipenum = 6,
-		.pipedir = PIPEDIR_INOUT,
-		.nentries = 32,
-		.nbytes_max = 4096,
-		.flags = CE_ATTR_FLAGS,
-		.reserved = 0,
+		.pipenum = __cpu_to_le32(6),
+		.pipedir = __cpu_to_le32(PIPEDIR_INOUT),
+		.nentries = __cpu_to_le32(32),
+		.nbytes_max = __cpu_to_le32(4096),
+		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
+		.reserved = __cpu_to_le32(0),
 	},
 
 	/* CE7 used only by Host */
@@ -229,92 +229,92 @@ static const struct ce_pipe_config target_ce_config_wlan[] = {
  */
 static const struct service_to_pipe target_service_to_ce_map_wlan[] = {
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_VO,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 3,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_VO),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(3),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_VO,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 2,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_VO),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(2),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_BK,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 3,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_BK),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(3),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_BK,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 2,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_BK),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(2),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_BE,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 3,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_BE),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(3),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_BE,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 2,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_BE),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(2),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_VI,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 3,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_VI),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(3),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_DATA_VI,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 2,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_DATA_VI),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(2),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_CONTROL,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 3,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_CONTROL),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(3),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_WMI_CONTROL,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 2,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_WMI_CONTROL),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(2),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_RSVD_CTRL,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 0,		/* could be moved to 3 (share with WMI) */
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_RSVD_CTRL),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(0),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_RSVD_CTRL,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 1,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_RSVD_CTRL),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(1),
 	},
-	{
-		 ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS,	/* not currently used */
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 0,
+	{ /* not used */
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(0),
 	},
-	{
-		 ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS,	/* not currently used */
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 1,
+	{ /* not used */
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(1),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_HTT_DATA_MSG,
-		 PIPEDIR_OUT,		/* out = UL = host -> target */
-		 4,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_HTT_DATA_MSG),
+		__cpu_to_le32(PIPEDIR_OUT),	/* out = UL = host -> target */
+		__cpu_to_le32(4),
 	},
 	{
-		 ATH10K_HTC_SVC_ID_HTT_DATA_MSG,
-		 PIPEDIR_IN,		/* in = DL = target -> host */
-		 1,
+		__cpu_to_le32(ATH10K_HTC_SVC_ID_HTT_DATA_MSG),
+		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
+		__cpu_to_le32(1),
 	},
 
 	/* (Additions here) */
 
-	{				/* Must be last */
-		 0,
-		 0,
-		 0,
+	{ /* must be last */
+		__cpu_to_le32(0),
+		__cpu_to_le32(0),
+		__cpu_to_le32(0),
 	},
 };
 
@@ -602,14 +602,9 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	}
 
 done:
-	if (ret == 0) {
-		/* Copy data from allocated DMA buf to caller's buf */
-		WARN_ON_ONCE(orig_nbytes & 3);
-		for (i = 0; i < orig_nbytes / sizeof(__le32); i++) {
-			((u32 *)data)[i] =
-				__le32_to_cpu(((__le32 *)data_buf)[i]);
-		}
-	} else
+	if (ret == 0)
+		memcpy(data, data_buf, orig_nbytes);
+	else
 		ath10k_warn(ar, "failed to read diag value at 0x%x: %d\n",
 			    address, ret);
 
@@ -622,7 +617,13 @@ done:
 
 static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
 {
-	return ath10k_pci_diag_read_mem(ar, address, value, sizeof(u32));
+	__le32 val = 0;
+	int ret;
+
+	ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(__le32));
+	*value = __le32_to_cpu(val);
+
+	return ret;
 }
 
 static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
@@ -699,9 +700,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	}
 
 	/* Copy caller's data to allocated DMA buf */
-	WARN_ON_ONCE(orig_nbytes & 3);
-	for (i = 0; i < orig_nbytes / sizeof(__le32); i++)
-		((__le32 *)data_buf)[i] = __cpu_to_le32(((u32 *)data)[i]);
+	memcpy(data_buf, data, orig_nbytes);
 
 	/*
 	 * The address supplied by the caller is in the
@@ -797,14 +796,20 @@ done:
 	return ret;
 }
 
+static int ath10k_pci_diag_write32(struct ath10k *ar, u32 address, u32 value)
+{
+	__le32 val = __cpu_to_le32(value);
+
+	return ath10k_pci_diag_write_mem(ar, address, &val, sizeof(val));
+}
+
 /* Write 4B data to Target memory or register */
 static int ath10k_pci_diag_write_access(struct ath10k *ar, u32 address,
 					u32 data)
 {
 	/* Assume range doesn't cross this boundary */
 	if (address >= DRAM_BASE_ADDRESS)
-		return ath10k_pci_diag_write_mem(ar, address, &data,
-						 sizeof(u32));
+		return ath10k_pci_diag_write32(ar, address, data);
 
 	ath10k_pci_write32(ar, address, data);
 	return 0;
@@ -988,14 +993,14 @@ static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 static void ath10k_pci_dump_registers(struct ath10k *ar,
 				      struct ath10k_fw_crash_data *crash_data)
 {
-	u32 i, reg_dump_values[REG_DUMP_COUNT_QCA988X] = {};
-	int ret;
+	__le32 reg_dump_values[REG_DUMP_COUNT_QCA988X] = {};
+	int i, ret;
 
 	lockdep_assert_held(&ar->data_lock);
 
 	ret = ath10k_pci_diag_read_hi(ar, &reg_dump_values[0],
 				      hi_failure_state,
-				      REG_DUMP_COUNT_QCA988X * sizeof(u32));
+				      REG_DUMP_COUNT_QCA988X * sizeof(__le32));
 	if (ret) {
 		ath10k_err(ar, "failed to read firmware dump area: %d\n", ret);
 		return;
@@ -1007,17 +1012,16 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i += 4)
 		ath10k_err(ar, "[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			   i,
-			   reg_dump_values[i],
-			   reg_dump_values[i + 1],
-			   reg_dump_values[i + 2],
-			   reg_dump_values[i + 3]);
+			   __le32_to_cpu(reg_dump_values[i]),
+			   __le32_to_cpu(reg_dump_values[i + 1]),
+			   __le32_to_cpu(reg_dump_values[i + 2]),
+			   __le32_to_cpu(reg_dump_values[i + 3]));
 
 	if (!crash_data)
 		return;
 
-	/* crash_data is in little endian */
 	for (i = 0; i < REG_DUMP_COUNT_QCA988X; i++)
-		crash_data->registers[i] = cpu_to_le32(reg_dump_values[i]);
+		crash_data->registers[i] = reg_dump_values[i];
 }
 
 static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
@@ -1111,27 +1115,27 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 	for (i = 0; i < ARRAY_SIZE(target_service_to_ce_map_wlan); i++) {
 		entry = &target_service_to_ce_map_wlan[i];
 
-		if (entry->service_id != service_id)
+		if (__le32_to_cpu(entry->service_id) != service_id)
 			continue;
 
-		switch (entry->pipedir) {
+		switch (__le32_to_cpu(entry->pipedir)) {
 		case PIPEDIR_NONE:
 			break;
 		case PIPEDIR_IN:
 			WARN_ON(dl_set);
-			*dl_pipe = entry->pipenum;
+			*dl_pipe = __le32_to_cpu(entry->pipenum);
 			dl_set = true;
 			break;
 		case PIPEDIR_OUT:
 			WARN_ON(ul_set);
-			*ul_pipe = entry->pipenum;
+			*ul_pipe = __le32_to_cpu(entry->pipenum);
 			ul_set = true;
 			break;
 		case PIPEDIR_INOUT:
 			WARN_ON(dl_set);
 			WARN_ON(ul_set);
-			*dl_pipe = entry->pipenum;
-			*ul_pipe = entry->pipenum;
+			*dl_pipe = __le32_to_cpu(entry->pipenum);
+			*ul_pipe = __le32_to_cpu(entry->pipenum);
 			dl_set = true;
 			ul_set = true;
 			break;
@@ -1583,10 +1587,9 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	pcie_config_flags &= ~PCIE_CONFIG_FLAG_ENABLE_L1;
 
-	ret = ath10k_pci_diag_write_mem(ar, pcie_state_targ_addr +
+	ret = ath10k_pci_diag_write_access(ar, pcie_state_targ_addr +
 				 offsetof(struct pcie_state, config_flags),
-				 &pcie_config_flags,
-				 sizeof(pcie_config_flags));
+				 pcie_config_flags);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to write pcie config_flags: %d\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index d88928c..cf36511 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -100,12 +100,12 @@ struct pcie_state {
  * NOTE: Structure is shared between Host software and Target firmware!
  */
 struct ce_pipe_config {
-	u32 pipenum;
-	u32 pipedir;
-	u32 nentries;
-	u32 nbytes_max;
-	u32 flags;
-	u32 reserved;
+	__le32 pipenum;
+	__le32 pipedir;
+	__le32 nentries;
+	__le32 nbytes_max;
+	__le32 flags;
+	__le32 reserved;
 };
 
 /*
@@ -127,9 +127,9 @@ struct ce_pipe_config {
 
 /* Establish a mapping between a service/direction and a pipe. */
 struct service_to_pipe {
-	u32 service_id;
-	u32 pipedir;
-	u32 pipenum;
+	__le32 service_id;
+	__le32 pipedir;
+	__le32 pipenum;
 };
 
 /* Per-pipe state. */
-- 
1.8.5.3

