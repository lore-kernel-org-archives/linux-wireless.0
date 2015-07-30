Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36497 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbbG3Kym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:42 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 01/19] wil6210: support boot loader struct v0 & v1
Date: Thu, 30 Jul 2015 13:51:49 +0300
Message-Id: <1438253527-3372-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125449_479421_724D02B9)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are 2 versions of boot loader struct: v0 and v1.
In the v1, boot loader build version added; as well as
RF status.

Support both versions.

Boot loader structure v1 has RF status; ignore RF error if firmware
not going to be loaded; driver can still be used to interact with the HW

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/boot_loader.h | 56 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c        | 85 ++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/wil6210.h     | 10 ---
 3 files changed, 124 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/boot_loader.h

diff --git a/drivers/net/wireless/ath/wil6210/boot_loader.h b/drivers/net/wireless/ath/wil6210/boot_loader.h
new file mode 100644
index 0000000..1b4fd40
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/boot_loader.h
@@ -0,0 +1,56 @@
+/* Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+/* This file contains the definitions for the boot loader
+ * for the Qualcomm "Sparrow" 60 Gigabit wireless solution.
+ */
+#ifndef BOOT_LOADER_EXPORT_H_
+#define BOOT_LOADER_EXPORT_H_
+
+struct bl_dedicated_registers_v1 {
+	__le32	boot_loader_ready;		/* 0x880A3C driver will poll
+						 * this Dword until BL will
+						 * set it to 1 (initial value
+						 * should be 0)
+						 */
+	__le32	boot_loader_struct_version;	/* 0x880A40 BL struct ver. */
+	__le16	rf_type;			/* 0x880A44 connected RF ID */
+	__le16	rf_status;			/* 0x880A46 RF status,
+						 * 0 is OK else error
+						 */
+	__le32	baseband_type;			/* 0x880A48 board type ID */
+	u8	mac_address[6];			/* 0x880A4c BL mac address */
+	u8	bl_version_major;		/* 0x880A52 BL ver. major */
+	u8	bl_version_minor;		/* 0x880A53 BL ver. minor */
+	__le16	bl_version_subminor;		/* 0x880A54 BL ver. subminor */
+	__le16	bl_version_build;		/* 0x880A56 BL ver. build */
+} __packed;
+
+/* the following struct is the version 0 struct */
+
+struct bl_dedicated_registers_v0 {
+	__le32	boot_loader_ready;		/* 0x880A3C driver will poll
+						 * this Dword until BL will
+						 * set it to 1 (initial value
+						 * should be 0)
+						 */
+#define BL_READY (1)	/* ready indication */
+	__le32	boot_loader_struct_version;	/* 0x880A40 BL struct ver. */
+	__le32	rf_type;			/* 0x880A44 connected RF ID */
+	__le32	baseband_type;			/* 0x880A48 board type ID */
+	u8	mac_address[6];			/* 0x880A4c BL mac address */
+} __packed;
+
+#endif /* BOOT_LOADER_EXPORT_H_ */
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6ca6193..ae0df35 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -21,6 +21,7 @@
 #include "wil6210.h"
 #include "txrx.h"
 #include "wmi.h"
+#include "boot_loader.h"
 
 #define WAIT_FOR_DISCONNECT_TIMEOUT_MS 2000
 #define WAIT_FOR_DISCONNECT_INTERVAL_MS 10
@@ -565,7 +566,8 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	wil_halt_cpu(wil);
 
 	/* clear all boot loader "ready" bits */
-	W(RGF_USER_BL + offsetof(struct RGF_BL, ready), 0);
+	W(RGF_USER_BL +
+	  offsetof(struct bl_dedicated_registers_v0, boot_loader_ready), 0);
 	/* Clear Fw Download notification */
 	C(RGF_USER_USAGE_6, BIT(0));
 
@@ -607,7 +609,8 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	/* wait until device ready. typical time is 20..80 msec */
 	do {
 		msleep(RST_DELAY);
-		x = R(RGF_USER_BL + offsetof(struct RGF_BL, ready));
+		x = R(RGF_USER_BL + offsetof(struct bl_dedicated_registers_v0,
+					     boot_loader_ready));
 		if (x1 != x) {
 			wil_dbg_misc(wil, "BL.ready 0x%08x => 0x%08x\n", x1, x);
 			x1 = x;
@@ -617,7 +620,7 @@ static int wil_target_reset(struct wil6210_priv *wil)
 				x);
 			return -ETIME;
 		}
-	} while (x != BIT_BL_READY);
+	} while (x != BL_READY);
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
 
@@ -641,25 +644,71 @@ void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 static int wil_get_bl_info(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
-	struct RGF_BL bl;
-
-	wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL), sizeof(bl));
-	le32_to_cpus(&bl.ready);
-	le32_to_cpus(&bl.version);
-	le32_to_cpus(&bl.rf_type);
-	le32_to_cpus(&bl.baseband_type);
+	union {
+		struct bl_dedicated_registers_v0 bl0;
+		struct bl_dedicated_registers_v1 bl1;
+	} bl;
+	u32 bl_ver;
+	u8 *mac;
+	u16 rf_status;
+
+	bl_ver = R(RGF_USER_BL + offsetof(struct bl_dedicated_registers_v0,
+					  boot_loader_struct_version));
+	switch (bl_ver) {
+	case 0:
+		wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
+				     sizeof(bl.bl0));
+		le32_to_cpus(&bl.bl0.boot_loader_ready);
+		le32_to_cpus(&bl.bl0.boot_loader_struct_version);
+		le32_to_cpus(&bl.bl0.rf_type);
+		le32_to_cpus(&bl.bl0.baseband_type);
+		mac = bl.bl0.mac_address;
+		rf_status = 0; /* actually, unknown */
+		wil_info(wil,
+			 "Boot Loader struct v%d: MAC = %pM RF = 0x%08x bband = 0x%08x\n",
+			 bl_ver, mac,
+			 bl.bl0.rf_type, bl.bl0.baseband_type);
+		wil_info(wil, "Boot Loader build unknown for struct v0\n");
+		break;
+	case 1:
+		wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
+				     sizeof(bl.bl1));
+		le32_to_cpus(&bl.bl1.boot_loader_ready);
+		le32_to_cpus(&bl.bl1.boot_loader_struct_version);
+		le16_to_cpus(&bl.bl1.rf_type);
+		rf_status = le16_to_cpu(bl.bl1.rf_status);
+		le32_to_cpus(&bl.bl1.baseband_type);
+		le16_to_cpus(&bl.bl1.bl_version_subminor);
+		le16_to_cpus(&bl.bl1.bl_version_build);
+		mac = bl.bl1.mac_address;
+		wil_info(wil,
+			 "Boot Loader struct v%d: MAC = %pM RF = 0x%04x (status 0x%04x) bband = 0x%08x\n",
+			 bl_ver, mac,
+			 bl.bl1.rf_type, rf_status,
+			 bl.bl1.baseband_type);
+		wil_info(wil, "Boot Loader build %d.%d.%d.%d\n",
+			 bl.bl1.bl_version_major, bl.bl1.bl_version_minor,
+			 bl.bl1.bl_version_subminor, bl.bl1.bl_version_build);
+		break;
+	default:
+		wil_err(wil, "BL: unsupported struct version 0x%08x\n", bl_ver);
+		return -EINVAL;
+	}
 
-	if (!is_valid_ether_addr(bl.mac_address)) {
-		wil_err(wil, "BL: Invalid MAC %pM\n", bl.mac_address);
+	if (!is_valid_ether_addr(mac)) {
+		wil_err(wil, "BL: Invalid MAC %pM\n", mac);
 		return -EINVAL;
 	}
 
-	ether_addr_copy(ndev->perm_addr, bl.mac_address);
+	ether_addr_copy(ndev->perm_addr, mac);
 	if (!is_valid_ether_addr(ndev->dev_addr))
-		ether_addr_copy(ndev->dev_addr, bl.mac_address);
-	wil_info(wil,
-		 "Boot Loader: ver = %d MAC = %pM RF = 0x%08x bband = 0x%08x\n",
-		 bl.version, bl.mac_address, bl.rf_type, bl.baseband_type);
+		ether_addr_copy(ndev->dev_addr, mac);
+
+	if (rf_status) {/* bad RF cable? */
+		wil_err(wil, "RF communication error 0x%04x",
+			rf_status);
+		return -EAGAIN;
+	}
 
 	return 0;
 }
@@ -735,6 +784,8 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		return rc;
 
 	rc = wil_get_bl_info(wil);
+	if (rc == -EAGAIN && !load_fw) /* ignore RF error if not going up */
+		rc = 0;
 	if (rc)
 		return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c63e4a3..b79ba49 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -127,16 +127,6 @@ struct RGF_ICR {
 	u32 IMC; /* Mask Clear, write 1 to clear */
 } __packed;
 
-struct RGF_BL {
-	u32 ready;		/* 0x880A3C bit [0] */
-#define BIT_BL_READY	BIT(0)
-	u32 version;		/* 0x880A40 version of the BL struct */
-	u32 rf_type;		/* 0x880A44 ID of the connected RF */
-	u32 baseband_type;	/* 0x880A48 ID of the baseband */
-	u8  mac_address[ETH_ALEN]; /* 0x880A4C permanent MAC */
-	u8 pad[2];
-} __packed;
-
 /* registers - FW addresses */
 #define RGF_USER_USAGE_1		(0x880004)
 #define RGF_USER_USAGE_6		(0x880018)
-- 
2.1.4

