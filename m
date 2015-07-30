Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbbG3Kyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:51 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 19/19] wil6210: support future boot loaders
Date: Thu, 30 Jul 2015 13:52:07 +0300
Message-Id: <1438253527-3372-20-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125501_208990_FD2458C8)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boot loader versions as backward compatible,
starting from v1

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d11a147..2fb04c5 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -643,37 +643,26 @@ static int wil_get_bl_info(struct wil6210_priv *wil)
 	u8 *mac;
 	u16 rf_status;
 
-	bl_ver = wil_r(wil, RGF_USER_BL +
-		       offsetof(struct bl_dedicated_registers_v0,
-				boot_loader_struct_version));
-	switch (bl_ver) {
-	case 0:
-		wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
-				     sizeof(bl.bl0));
-		le32_to_cpus(&bl.bl0.boot_loader_ready);
-		le32_to_cpus(&bl.bl0.boot_loader_struct_version);
+	wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
+			     sizeof(bl));
+	bl_ver = le32_to_cpu(bl.bl0.boot_loader_struct_version);
+	mac = bl.bl0.mac_address;
+
+	if (bl_ver == 0) {
 		le32_to_cpus(&bl.bl0.rf_type);
 		le32_to_cpus(&bl.bl0.baseband_type);
-		mac = bl.bl0.mac_address;
 		rf_status = 0; /* actually, unknown */
 		wil_info(wil,
 			 "Boot Loader struct v%d: MAC = %pM RF = 0x%08x bband = 0x%08x\n",
 			 bl_ver, mac,
 			 bl.bl0.rf_type, bl.bl0.baseband_type);
 		wil_info(wil, "Boot Loader build unknown for struct v0\n");
-		break;
-	case 1:
-	case 2:
-		wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
-				     sizeof(bl.bl1));
-		le32_to_cpus(&bl.bl1.boot_loader_ready);
-		le32_to_cpus(&bl.bl1.boot_loader_struct_version);
+	} else {
 		le16_to_cpus(&bl.bl1.rf_type);
 		rf_status = le16_to_cpu(bl.bl1.rf_status);
 		le32_to_cpus(&bl.bl1.baseband_type);
 		le16_to_cpus(&bl.bl1.bl_version_subminor);
 		le16_to_cpus(&bl.bl1.bl_version_build);
-		mac = bl.bl1.mac_address;
 		wil_info(wil,
 			 "Boot Loader struct v%d: MAC = %pM RF = 0x%04x (status 0x%04x) bband = 0x%08x\n",
 			 bl_ver, mac,
@@ -682,10 +671,6 @@ static int wil_get_bl_info(struct wil6210_priv *wil)
 		wil_info(wil, "Boot Loader build %d.%d.%d.%d\n",
 			 bl.bl1.bl_version_major, bl.bl1.bl_version_minor,
 			 bl.bl1.bl_version_subminor, bl.bl1.bl_version_build);
-		break;
-	default:
-		wil_err(wil, "BL: unsupported struct version 0x%08x\n", bl_ver);
-		return -EINVAL;
 	}
 
 	if (!is_valid_ether_addr(mac)) {
-- 
2.1.4

