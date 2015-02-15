Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbBOMDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:00 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/9] wil6210: boot loader
Date: Sun, 15 Feb 2015 14:02:30 +0200
Message-Id: <1424001758-29529-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130316_914515_38B014EB)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce boot loader. Instead of the operational firmware,
very small boot loader is burned to the on-board flash. Boot loader
initializes hardware upon reset, and prepares for low power mode.
Boot loader reports MAC address and detects radio chip connected.

Driver loads firmware only when bringing up interface. All information
required to set up network interface, most important is MAC address,
reported by the boot loader

The firmware composed of 2 files:
- wil6210.fw - firmware itself (compiled code + data)
- wil6210.board - board file (various board and radio dependent
  calibrations and parameters)

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c  |   2 +-
 drivers/net/wireless/ath/wil6210/fw.c       |   3 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c   |   4 +-
 drivers/net/wireless/ath/wil6210/main.c     | 104 ++++++++++++++++++----------
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  16 ++++-
 drivers/net/wireless/ath/wil6210/wmi.c      |   7 +-
 7 files changed, 88 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 45c3558e..3ed16e7 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -549,7 +549,7 @@ static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
 	dev_close(ndev);
 	ndev->flags &= ~IFF_UP;
 	rtnl_unlock();
-	wil_reset(wil);
+	wil_reset(wil, true);
 
 	return len;
 }
diff --git a/drivers/net/wireless/ath/wil6210/fw.c b/drivers/net/wireless/ath/wil6210/fw.c
index 93c5cc1..4428345 100644
--- a/drivers/net/wireless/ath/wil6210/fw.c
+++ b/drivers/net/wireless/ath/wil6210/fw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -20,6 +20,7 @@
 #include "fw.h"
 
 MODULE_FIRMWARE(WIL_FW_NAME);
+MODULE_FIRMWARE(WIL_FW2_NAME);
 
 /* target operations */
 /* register read */
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index d4acf93..157f5ef 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -451,8 +451,6 @@ static int wil_fw_load(struct wil6210_priv *wil, const void *data, size_t size)
 		}
 		return -EINVAL;
 	}
-	/* Mark FW as loaded from host */
-	S(RGF_USER_USAGE_6, 1);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index b04e0af..acbbd27 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -29,10 +29,6 @@ bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_recovery, " disable automatic FW error recovery");
 
-static bool no_fw_load = true;
-module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(no_fw_load, " do not download FW, use one in on-card flash.");
-
 /* if not set via modparam, will be set to default value of 1/8 of
  * rx ring size during init flow
  */
@@ -532,6 +528,8 @@ static int wil_target_reset(struct wil6210_priv *wil)
 
 	wil_halt_cpu(wil);
 
+	/* clear all boot loader "ready" bits */
+	W(RGF_USER_BL + offsetof(struct RGF_BL, ready), 0);
 	/* Clear Fw Download notification */
 	C(RGF_USER_USAGE_6, BIT(0));
 
@@ -583,16 +581,16 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	/* TODO: check order here!!! Erez code is different */
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
-	/* wait until device ready. typical time is 200..250 msec */
+	/* wait until device ready. typical time is 20..80 msec */
 	do {
 		msleep(RST_DELAY);
-		x = R(RGF_USER_HW_MACHINE_STATE);
+		x = R(RGF_USER_BL + offsetof(struct RGF_BL, ready));
 		if (delay++ > RST_COUNT) {
-			wil_err(wil, "Reset not completed, hw_state 0x%08x\n",
+			wil_err(wil, "Reset not completed, bl.ready 0x%08x\n",
 				x);
 			return -ETIME;
 		}
-	} while (x != HW_MACHINE_BOOT_DONE);
+	} while (!(x & BIT_BL_READY));
 
 	if (!is_reset_v2)
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
@@ -603,11 +601,6 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	return 0;
 }
 
-#undef R
-#undef W
-#undef S
-#undef C
-
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 {
 	le32_to_cpus(&r->base);
@@ -617,6 +610,32 @@ void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 	le32_to_cpus(&r->head);
 }
 
+static int wil_get_bl_info(struct wil6210_priv *wil)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct RGF_BL bl;
+
+	wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL), sizeof(bl));
+	le32_to_cpus(&bl.ready);
+	le32_to_cpus(&bl.version);
+	le32_to_cpus(&bl.rf_type);
+	le32_to_cpus(&bl.baseband_type);
+
+	if (!is_valid_ether_addr(bl.mac_address)) {
+		wil_err(wil, "BL: Invalid MAC %pM\n", bl.mac_address);
+		return -EINVAL;
+	}
+
+	ether_addr_copy(ndev->perm_addr, bl.mac_address);
+	if (!is_valid_ether_addr(ndev->dev_addr))
+		ether_addr_copy(ndev->dev_addr, bl.mac_address);
+	wil_info(wil,
+		 "Boot Loader: ver = %d MAC = %pM RF = 0x%08x bband = 0x%08x\n",
+		 bl.version, bl.mac_address, bl.rf_type, bl.baseband_type);
+
+	return 0;
+}
+
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
 	ulong to = msecs_to_jiffies(1000);
@@ -637,7 +656,7 @@ static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
  * After calling this routine, you're expected to reload
  * the firmware.
  */
-int wil_reset(struct wil6210_priv *wil)
+int wil_reset(struct wil6210_priv *wil, bool load_fw)
 {
 	int rc;
 
@@ -675,30 +694,36 @@ int wil_reset(struct wil6210_priv *wil)
 	if (rc)
 		return rc;
 
-	if (!no_fw_load) {
-		wil_info(wil, "Use firmware <%s>\n", WIL_FW_NAME);
+	rc = wil_get_bl_info(wil);
+	if (rc)
+		return rc;
+
+	if (load_fw) {
+		wil_info(wil, "Use firmware <%s> + board <%s>\n", WIL_FW_NAME,
+			 WIL_FW2_NAME);
+
 		wil_halt_cpu(wil);
 		/* Loading f/w from the file */
 		rc = wil_request_firmware(wil, WIL_FW_NAME);
 		if (rc)
 			return rc;
+		rc = wil_request_firmware(wil, WIL_FW2_NAME);
+		if (rc)
+			return rc;
+
+		/* Mark FW as loaded from host */
+		S(RGF_USER_USAGE_6, 1);
 
-		/* clear any interrupts which on-card-firmware may have set */
+		/* clear any interrupts which on-card-firmware
+		 * may have set
+		 */
 		wil6210_clear_irq(wil);
-		{ /* CAF_ICR - clear and mask */
-			u32 a = HOSTADDR(RGF_CAF_ICR) +
-				offsetof(struct RGF_ICR, ICR);
-			u32 m = HOSTADDR(RGF_CAF_ICR) +
-				offsetof(struct RGF_ICR, IMV);
-			u32 icr = ioread32(wil->csr + a);
-
-			iowrite32(icr, wil->csr + a); /* W1C */
-			iowrite32(~0, wil->csr + m);
-			wmb(); /* wait for completion */
-		}
+		/* CAF_ICR - clear and mask */
+		/* it is W1C, clear by writing back same value */
+		S(RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
+		W(RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+
 		wil_release_cpu(wil);
-	} else {
-		wil_info(wil, "Use firmware from on-card flash\n");
 	}
 
 	/* init after reset */
@@ -706,15 +731,22 @@ int wil_reset(struct wil6210_priv *wil)
 	reinit_completion(&wil->wmi_ready);
 	reinit_completion(&wil->wmi_call);
 
-	wil_configure_interrupt_moderation(wil);
-	wil_unmask_irq(wil);
+	if (load_fw) {
+		wil_configure_interrupt_moderation(wil);
+		wil_unmask_irq(wil);
 
-	/* we just started MAC, wait for FW ready */
-	rc = wil_wait_for_fw_ready(wil);
+		/* we just started MAC, wait for FW ready */
+		rc = wil_wait_for_fw_ready(wil);
+	}
 
 	return rc;
 }
 
+#undef R
+#undef W
+#undef S
+#undef C
+
 void wil_fw_error_recovery(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "starting fw error recovery\n");
@@ -730,7 +762,7 @@ int __wil_up(struct wil6210_priv *wil)
 
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
-	rc = wil_reset(wil);
+	rc = wil_reset(wil, true);
 	if (rc)
 		return rc;
 
@@ -837,7 +869,7 @@ int __wil_down(struct wil6210_priv *wil)
 	if (!iter)
 		wil_err(wil, "timeout waiting for idle FW/HW\n");
 
-	wil_rx_fini(wil);
+	wil_reset(wil, false);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 3dd2670..f7c165d 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -150,7 +150,7 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 
 	/* need reset here to obtain MAC */
 	mutex_lock(&wil->mutex);
-	rc = wil_reset(wil);
+	rc = wil_reset(wil, false);
 	mutex_unlock(&wil->mutex);
 	if (debug_fw)
 		rc = 0;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9461156..cfe43d2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -29,7 +29,8 @@ extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
 
 #define WIL_NAME "wil6210"
-#define WIL_FW_NAME "wil6210.fw"
+#define WIL_FW_NAME "wil6210.fw" /* code */
+#define WIL_FW2_NAME "wil6210.board" /* board & radio parameters */
 
 #define WIL_MAX_BUS_REQUEST_KBPS 800000 /* ~6.1Gbps */
 
@@ -120,6 +121,16 @@ struct RGF_ICR {
 	u32 IMC; /* Mask Clear, write 1 to clear */
 } __packed;
 
+struct RGF_BL {
+	u32 ready;		/* 0x880A3C bit [0] */
+#define BIT_BL_READY	BIT(0)
+	u32 version;		/* 0x880A40 version of the BL struct */
+	u32 rf_type;		/* 0x880A44 ID of the connected RF */
+	u32 baseband_type;	/* 0x880A48 ID of the baseband */
+	u8  mac_address[ETH_ALEN]; /* 0x880A4C permanent MAC */
+	u8 pad[2];
+} __packed;
+
 /* registers - FW addresses */
 #define RGF_USER_USAGE_1		(0x880004)
 #define RGF_USER_USAGE_6		(0x880018)
@@ -130,6 +141,7 @@ struct RGF_ICR {
 #define RGF_USER_MAC_CPU_0		(0x8801fc)
 	#define BIT_USER_MAC_CPU_MAN_RST	BIT(1) /* mac_cpu_man_rst */
 #define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
+#define RGF_USER_BL			(0x880A3C) /* Boot Loader */
 #define RGF_USER_FW_REV_ID		(0x880a8c) /* chip revision */
 #define RGF_USER_CLKS_CTL_0		(0x880abc)
 	#define BIT_USER_CLKS_CAR_AHB_SW_SEL	BIT(1) /* ref clk/PLL */
@@ -658,7 +670,7 @@ int wil_if_add(struct wil6210_priv *wil);
 void wil_if_remove(struct wil6210_priv *wil);
 int wil_priv_init(struct wil6210_priv *wil);
 void wil_priv_deinit(struct wil6210_priv *wil);
-int wil_reset(struct wil6210_priv *wil);
+int wil_reset(struct wil6210_priv *wil, bool no_fw);
 void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_set_recovery_state(struct wil6210_priv *wil, int state);
 int wil_up(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0f3e433..e60186c 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -281,7 +281,6 @@ int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 /*=== Event handlers ===*/
 static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 {
-	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 	struct wmi_ready_event *evt = d;
 
@@ -290,11 +289,7 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 
 	wil_info(wil, "FW ver. %d; MAC %pM; %d MID's\n", wil->fw_version,
 		 evt->mac, wil->n_mids);
-
-	if (!is_valid_ether_addr(ndev->dev_addr)) {
-		memcpy(ndev->dev_addr, evt->mac, ETH_ALEN);
-		memcpy(ndev->perm_addr, evt->mac, ETH_ALEN);
-	}
+	/* ignore MAC address, we already have it from the boot loader */
 	snprintf(wdev->wiphy->fw_version, sizeof(wdev->wiphy->fw_version),
 		 "%d", wil->fw_version);
 }
-- 
2.1.0

