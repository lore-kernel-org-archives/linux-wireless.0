Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbbCLNGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:12 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/49] iwlwifi: trans: Take ownership on secure machine before FW load
Date: Thu, 12 Mar 2015 15:04:21 +0200
Message-Id: <1426165474-25586-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143417_557886_CE30C975)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

When we load the firmware for the 8000 B step device, it'll
verify its signature. In the current version of the
hardware, there can be a race between the WiFi firmware
being loaded and the Bluetooth firmware being loaded.

Check that WiFi is authenticated, if not, take ownership
on the authentication machine to make sure that the WiFi
firmware will be authenticated.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   | 10 ++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 42 +++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index aa6fb584..bc96288 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -381,6 +381,7 @@ enum secure_load_status_reg {
 #define WFPM_CTRL_REG			0xA03030
 enum {
 	ENABLE_WFPM = BIT(31),
+	WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK	= 0x80000000,
 };
 
 #define AUX_MISC_REG			0xA200B0
@@ -388,6 +389,15 @@ enum {
 	HW_STEP_LOCATION_BITS = 24,
 };
 
+#define AUX_MISC_MASTER1_EN		0xA20818
+enum aux_misc_master1_en {
+	AUX_MISC_MASTER1_EN_SBE_MSK	= 0x1,
+};
+
+#define AUX_MISC_MASTER1_SMPHR_STATUS	0xA20800
+#define RSA_ENABLE			0xA24B08
+#define PREG_AUX_BUS_WPROT_0		0xA04CC0
+
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
 enum {
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 421ef6b..9ce5e61 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -682,6 +682,43 @@ static int iwl_pcie_load_section(struct iwl_trans *trans, u8 section_num,
 	return ret;
 }
 
+/*
+ * Driver Takes the ownership on secure machine before FW load
+ * and prevent race with the BT load.
+ * W/A for ROM bug. (should be remove in the next Si step)
+ */
+static int iwl_pcie_rsa_race_bug_wa(struct iwl_trans *trans)
+{
+	u32 val, loop = 1000;
+
+	/* Check the RSA semaphore is accessible - if not, we are in trouble */
+	val = iwl_read_prph(trans, PREG_AUX_BUS_WPROT_0);
+	if (val & (BIT(1) | BIT(17))) {
+		IWL_ERR(trans,
+			"can't access the RSA semaphore it is write protected\n");
+		return 0;
+	}
+
+	/* take ownership on the AUX IF */
+	iwl_write_prph(trans, WFPM_CTRL_REG, WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK);
+	iwl_write_prph(trans, AUX_MISC_MASTER1_EN, AUX_MISC_MASTER1_EN_SBE_MSK);
+
+	do {
+		iwl_write_prph(trans, AUX_MISC_MASTER1_SMPHR_STATUS, 0x1);
+		val = iwl_read_prph(trans, AUX_MISC_MASTER1_SMPHR_STATUS);
+		if (val == 0x1) {
+			iwl_write_prph(trans, RSA_ENABLE, 0);
+			return 0;
+		}
+
+		udelay(10);
+		loop--;
+	} while (loop > 0);
+
+	IWL_ERR(trans, "Failed to take ownership on secure machine\n");
+	return -EIO;
+}
+
 static int iwl_pcie_load_cpu_sections_8000b(struct iwl_trans *trans,
 					    const struct fw_img *image,
 					    int cpu,
@@ -901,6 +938,11 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	if (trans->dbg_dest_tlv)
 		iwl_pcie_apply_destination(trans);
 
+	/* TODO: remove in the next Si step */
+	ret = iwl_pcie_rsa_race_bug_wa(trans);
+	if (ret)
+		return ret;
+
 	/* configure the ucode to be ready to get the secured image */
 	/* release CPU reset */
 	iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
-- 
1.9.1

