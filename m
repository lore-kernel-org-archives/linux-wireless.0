Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35619 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932174AbcKNQfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:31 -0500
Received: by mail-lf0-f65.google.com with SMTP id p100so7512864lfg.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:30 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 06/12] ath10k: bmi: Added SOC reg read/write functions
Date: Mon, 14 Nov 2016 17:33:36 +0100
Message-Id: <1479141222-8493-7-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173629_116706_0C96DEAC)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added functions implementing the following BMI commands:

BMI_READ_SOC_REGISTER
BMI_WRITE_SOC_REGISTER

Reading and writing BMI registers is sometimes needed for
SDIO chipsets.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c |   79 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/bmi.h |    4 ++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 2872d34..1c378a2 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -97,7 +97,8 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
 	u32 rxlen;
 	int ret;
 
-	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi read address 0x%x length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI,
+		   "bmi read memory address 0x%x length %d\n",
 		   address, length);
 
 	if (ar->bmi.done_sent) {
@@ -137,7 +138,8 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 	u32 txlen;
 	int ret;
 
-	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi write address 0x%x length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI,
+		   "bmi write memory address 0x%x length %d\n",
 		   address, length);
 
 	if (ar->bmi.done_sent) {
@@ -175,6 +177,79 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 	return 0;
 }
 
+int ath10k_bmi_read_soc_reg(struct ath10k *ar,
+			    u32 address, u32 *regval)
+{
+	struct bmi_cmd cmd;
+	union bmi_resp resp;
+	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.read_soc_reg);
+	u32 rxlen;
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BMI,
+		   "bmi read SOC register address 0x%x\n",
+		   address);
+
+	if (ar->bmi.done_sent) {
+		ath10k_warn(ar, "command disallowed\n");
+		return -EBUSY;
+	}
+
+	rxlen = sizeof(resp.read_soc_reg.value);
+
+	cmd.id                = __cpu_to_le32(BMI_READ_SOC_REGISTER);
+	cmd.read_soc_reg.addr = __cpu_to_le32(address);
+
+	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen,
+					  &resp, &rxlen);
+	if (ret) {
+		ath10k_warn(ar, "unable to read from the device (%d)\n",
+			    ret);
+		return ret;
+	}
+
+	if (rxlen != sizeof(resp.read_soc_reg.value)) {
+		ath10k_warn(ar, "Unexpected read len: %u (expected %u)\n",
+			    rxlen, sizeof(resp.read_soc_reg.value));
+		return ret;
+	}
+
+	*regval = __le32_to_cpu(resp.read_soc_reg.value);
+
+	return 0;
+}
+
+int ath10k_bmi_write_soc_reg(struct ath10k *ar,
+			     u32 address, u32 regval)
+{
+	struct bmi_cmd cmd;
+	u32 cmdlen = sizeof(cmd.id) + sizeof(cmd.write_soc_reg);
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BMI,
+		   "bmi write SOC register address 0x%x\n",
+		   address);
+
+	if (ar->bmi.done_sent) {
+		ath10k_warn(ar, "command disallowed\n");
+		return -EBUSY;
+	}
+
+	cmd.id                  = __cpu_to_le32(BMI_WRITE_SOC_REGISTER);
+	cmd.write_soc_reg.addr  = __cpu_to_le32(address);
+	cmd.write_soc_reg.value = __cpu_to_le32(regval);
+
+	ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen,
+					  NULL, NULL);
+	if (ret) {
+		ath10k_warn(ar, "unable to write to the device (%d)\n",
+			    ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ath10k_bmi_execute(struct ath10k *ar, u32 address, u32 param, u32 *result)
 {
 	struct bmi_cmd cmd;
diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 7d3231a..a867867 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -201,6 +201,10 @@ int ath10k_bmi_read_memory(struct ath10k *ar, u32 address,
 			   void *buffer, u32 length);
 int ath10k_bmi_write_memory(struct ath10k *ar, u32 address,
 			    const void *buffer, u32 length);
+int ath10k_bmi_read_soc_reg(struct ath10k *ar,
+			    u32 address, u32 *regval);
+int ath10k_bmi_write_soc_reg(struct ath10k *ar,
+			     u32 address, u32 regval);
 
 #define ath10k_bmi_read32(ar, item, val)				\
 	({								\
-- 
1.7.9.5
