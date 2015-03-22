Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49322 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbbCVSbk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:31:40 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 06/18] ath9k: add new function ath9k_hw_read_array
Date: Sun, 22 Mar 2015 19:29:51 +0100
Message-Id: <1427049003-8443-7-git-send-email-linux@rempel-privat.de> (sfid-20150322_193145_678225_8310555F)
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

REG_READ generate most overhead on usb bus. It send and read micro packages
and reduce usb bandwidth. To reduce this overhead we should read in batches.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hw.c | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h |  3 +++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 60aa8d7..662ef3f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -121,6 +121,36 @@ void ath9k_hw_write_array(struct ath_hw *ah, const struct ar5416IniArray *array,
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
+void ath9k_hw_read_array(struct ath_hw *ah, u32 array[][2], int size)
+{
+	u32 *tmp_reg_list, *tmp_data;
+	int i;
+
+	tmp_reg_list = kmalloc(size * sizeof(u32), GFP_KERNEL);
+	if (!tmp_reg_list) {
+		dev_err(ah->dev, "%s: tmp_reg_list: alloc filed\n", __func__);
+		return;
+	}
+
+	tmp_data = kmalloc(size * sizeof(u32), GFP_KERNEL);
+	if (!tmp_data) {
+		dev_err(ah->dev, "%s tmp_data: alloc filed\n", __func__);
+		goto error_tmp_data;
+	}
+
+	for (i = 0; i < size; i++)
+		tmp_reg_list[i] = array[i][0];
+
+	REG_READ_MULTI(ah, tmp_reg_list, tmp_data, size);
+
+	for (i = 0; i < size; i++)
+		array[i][1] = tmp_data[i];
+
+	kfree(tmp_data);
+error_tmp_data:
+	kfree(tmp_reg_list);
+}
+
 u32 ath9k_hw_reverse_bits(u32 val, u32 n)
 {
 	u32 retval;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f1864cc..66aba10 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -138,6 +138,8 @@
 
 #define REG_WRITE_ARRAY(iniarray, column, regWr) \
 	ath9k_hw_write_array(ah, iniarray, column, &(regWr))
+#define REG_READ_ARRAY(ah, array, size) \
+	ath9k_hw_read_array(ah, array, size)
 
 #define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
 #define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
@@ -1020,6 +1022,7 @@ void ath9k_hw_synth_delay(struct ath_hw *ah, struct ath9k_channel *chan,
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
 void ath9k_hw_write_array(struct ath_hw *ah, const struct ar5416IniArray *array,
 			  int column, unsigned int *writecnt);
+void ath9k_hw_read_array(struct ath_hw *ah, u32 array[][2], int size);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
 u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 			   u8 phy, int kbps,
-- 
1.9.1

