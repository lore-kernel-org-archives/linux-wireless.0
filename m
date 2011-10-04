Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51222 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751048Ab1JDENd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 00:13:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add support for Marvell pcie8766 chipset
Date: Mon,  3 Oct 2011 21:08:23 -0700
Message-Id: <1317701303-21871-2-git-send-email-bzhao@marvell.com> (sfid-20111004_061337_633342_2BA3ACF2)
In-Reply-To: <1317701303-21871-1-git-send-email-bzhao@marvell.com>
References: <1317701303-21871-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch supports 88W8766P chipset with a PCIe interface.

The corresponding firmware image file is located at:
"mrvl/pcie8766_uapsta.bin"

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Ramesh Radhakrishnan <rramesh@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c    |    3 +-
 drivers/net/wireless/mwifiex/Kconfig       |   11 +
 drivers/net/wireless/mwifiex/Makefile      |    3 +
 drivers/net/wireless/mwifiex/cmdevt.c      |   11 +-
 drivers/net/wireless/mwifiex/fw.h          |   30 +-
 drivers/net/wireless/mwifiex/init.c        |   17 +-
 drivers/net/wireless/mwifiex/main.c        |    4 +-
 drivers/net/wireless/mwifiex/main.h        |   20 +-
 drivers/net/wireless/mwifiex/pcie.c        | 1948 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/pcie.h        |  148 +++
 drivers/net/wireless/mwifiex/sdio.c        |   19 +-
 drivers/net/wireless/mwifiex/sdio.h        |   24 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   64 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +
 drivers/net/wireless/mwifiex/sta_tx.c      |    2 +-
 drivers/net/wireless/mwifiex/txrx.c        |    2 +-
 drivers/net/wireless/mwifiex/util.h        |    9 +-
 drivers/net/wireless/mwifiex/wmm.c         |    4 +-
 18 files changed, 2284 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/pcie.c
 create mode 100644 drivers/net/wireless/mwifiex/pcie.h

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 9e63d16..079e553 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -246,8 +246,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	tx_param.next_pkt_len = 0;
 
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					     skb_aggr->data,
-					     skb_aggr->len, &tx_param);
+					   skb_aggr, &tx_param);
 	switch (ret) {
 	case -EBUSY:
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 8696292..8f2797a 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -19,3 +19,14 @@ config MWIFIEX_SDIO
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_sdio.
+
+config MWIFIEX_PCIE
+	tristate "Marvell WiFi-Ex Driver for PCIE 8766"
+	depends on MWIFIEX && PCI
+	select FW_LOADER
+	---help---
+	  This adds support for wireless adapters based on Marvell
+	  8766 chipset with PCIe interface.
+
+	  If you choose to build it as a module, it will be called
+	  mwifiex_pcie.
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 42cb733..b0257ad 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -39,3 +39,6 @@ obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
 mwifiex_sdio-y += sdio.o
 obj-$(CONFIG_MWIFIEX_SDIO) += mwifiex_sdio.o
+
+mwifiex_pcie-y += pcie.o
+obj-$(CONFIG_MWIFIEX_PCIE) += mwifiex_pcie.o
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index aab805f..08f7096 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -99,7 +99,7 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 		skb_trim(cmd_node->cmd_skb, 0);
 
 	if (cmd_node->resp_skb) {
-		dev_kfree_skb_any(cmd_node->resp_skb);
+		adapter->if_ops.cmdrsp_complete(adapter, cmd_node->resp_skb);
 		cmd_node->resp_skb = NULL;
 	}
 }
@@ -181,8 +181,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
 
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
-					     cmd_node->cmd_skb->data,
-					     cmd_node->cmd_skb->len, NULL);
+					   cmd_node->cmd_skb, NULL);
 
 	skb_pull(cmd_node->cmd_skb, INTF_HEADER_LEN);
 
@@ -243,8 +242,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 
 	skb_push(adapter->sleep_cfm, INTF_HEADER_LEN);
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
-					     adapter->sleep_cfm->data,
-					     adapter->sleep_cfm->len, NULL);
+					   adapter->sleep_cfm, NULL);
 	skb_pull(adapter->sleep_cfm, INTF_HEADER_LEN);
 
 	if (ret == -1) {
@@ -411,8 +409,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 
 	adapter->event_cause = 0;
 	adapter->event_skb = NULL;
-
-	dev_kfree_skb_any(skb);
+	adapter->if_ops.event_complete(adapter, skb);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index f23ec72..71c61b7 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -84,7 +84,8 @@ enum KEY_TYPE_ID {
 
 #define MAX_FIRMWARE_POLL_TRIES			100
 
-#define FIRMWARE_READY				0xfedc
+#define FIRMWARE_READY_SDIO				0xfedc
+#define FIRMWARE_READY_PCIE				0xfedcba00
 
 enum MWIFIEX_802_11_PRIVACY_FILTER {
 	MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL,
@@ -221,7 +222,7 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HostCmd_CMD_802_11_HS_CFG_ENH                 0x00e5
 #define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
-
+#define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
 
 enum ENH_PS_MODES {
 	EN_PS = 1,
@@ -1137,6 +1138,30 @@ struct host_cmd_ds_set_bss_mode {
 	u8 con_type;
 } __packed;
 
+struct host_cmd_ds_pcie_details {
+	/* TX buffer descriptor ring address */
+	u32 txbd_addr_lo;
+	u32 txbd_addr_hi;
+	/* TX buffer descriptor ring count */
+	u32 txbd_count;
+
+	/* RX buffer descriptor ring address */
+	u32 rxbd_addr_lo;
+	u32 rxbd_addr_hi;
+	/* RX buffer descriptor ring count */
+	u32 rxbd_count;
+
+	/* Event buffer descriptor ring address */
+	u32 evtbd_addr_lo;
+	u32 evtbd_addr_hi;
+	/* Event buffer descriptor ring count */
+	u32 evtbd_count;
+
+	/* Sleep cookie buffer physical address */
+	u32 sleep_cookie_addr_lo;
+	u32 sleep_cookie_addr_hi;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -1184,6 +1209,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_rf_reg_access rf_reg;
 		struct host_cmd_ds_pmic_reg_access pmic_reg;
 		struct host_cmd_ds_set_bss_mode bss_mode;
+		struct host_cmd_ds_pcie_details pcie_host_spec;
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
 	} params;
 } __packed;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e1076b4..0ce72fc 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -191,7 +191,12 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 						(adapter->sleep_cfm->data);
 
 	adapter->cmd_sent = false;
-	adapter->data_sent = true;
+
+	if (adapter->iface_type == MWIFIEX_PCIE)
+		adapter->data_sent = false;
+	else
+		adapter->data_sent = true;
+
 	adapter->cmd_resp_received = false;
 	adapter->event_received = false;
 	adapter->data_received = false;
@@ -581,11 +586,13 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		    struct mwifiex_fw_image *pmfw)
 {
-	int ret, winner;
+	int ret;
 	u32 poll_num = 1;
 
+	adapter->winner = 0;
+
 	/* Check if firmware is already running */
-	ret = adapter->if_ops.check_fw_status(adapter, poll_num, &winner);
+	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 	if (!ret) {
 		dev_notice(adapter->dev,
 				"WLAN FW already running! Skip FW download\n");
@@ -594,7 +601,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	poll_num = MAX_FIRMWARE_POLL_TRIES;
 
 	/* Check if we are the winner for downloading FW */
-	if (!winner) {
+	if (!adapter->winner) {
 		dev_notice(adapter->dev,
 				"Other interface already running!"
 				" Skip FW download\n");
@@ -612,7 +619,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 
 poll_fw:
 	/* Check if the firmware is downloaded successfully or not */
-	ret = adapter->if_ops.check_fw_status(adapter, poll_num, NULL);
+	ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 	if (ret) {
 		dev_err(adapter->dev, "FW failed to be active in time\n");
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 13264b8..7bee851 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -661,7 +661,7 @@ mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
  */
 int
 mwifiex_add_card(void *card, struct semaphore *sem,
-		 struct mwifiex_if_ops *if_ops)
+		 struct mwifiex_if_ops *if_ops, u8 iface_type)
 {
 	struct mwifiex_adapter *adapter;
 	char fmt[64];
@@ -675,6 +675,8 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto err_init_sw;
 	}
 
+	adapter->iface_type = iface_type;
+
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 	adapter->surprise_removed = false;
 	init_waitqueue_head(&adapter->init_wait_q);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 842ae6b..0b8c98d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -37,6 +37,7 @@
 #include "ioctl.h"
 #include "util.h"
 #include "fw.h"
+#include "pcie.h"
 
 extern const char driver_version[];
 
@@ -107,6 +108,8 @@ enum {
 
 #define MAX_FREQUENCY_BAND_BG   2484
 
+#define MWIFIEX_EVENT_HEADER_LEN           4
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
@@ -156,6 +159,11 @@ enum MWIFIEX_PS_STATE {
 	PS_STATE_SLEEP
 };
 
+enum mwifiex_iface_type {
+	MWIFIEX_SDIO,
+	MWIFIEX_PCIE,
+};
+
 struct mwifiex_add_ba_param {
 	u32 tx_win_size;
 	u32 rx_win_size;
@@ -518,27 +526,31 @@ struct cmd_ctrl_node {
 struct mwifiex_if_ops {
 	int (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
-	int (*check_fw_status) (struct mwifiex_adapter *, u32, int *);
+	int (*check_fw_status) (struct mwifiex_adapter *, u32);
 	int (*prog_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	int (*register_dev) (struct mwifiex_adapter *);
 	void (*unregister_dev) (struct mwifiex_adapter *);
 	int (*enable_int) (struct mwifiex_adapter *);
 	int (*process_int_status) (struct mwifiex_adapter *);
-	int (*host_to_card) (struct mwifiex_adapter *, u8,
-			     u8 *payload, u32 pkt_len,
+	int (*host_to_card) (struct mwifiex_adapter *, u8, struct sk_buff *,
 			     struct mwifiex_tx_param *);
 	int (*wakeup) (struct mwifiex_adapter *);
 	int (*wakeup_complete) (struct mwifiex_adapter *);
 
+	/* Interface specific functions */
 	void (*update_mp_end_port) (struct mwifiex_adapter *, u16);
 	void (*cleanup_mpa_buf) (struct mwifiex_adapter *);
+	int (*cmdrsp_complete) (struct mwifiex_adapter *, struct sk_buff *);
+	int (*event_complete) (struct mwifiex_adapter *, struct sk_buff *);
 };
 
 struct mwifiex_adapter {
+	u8 iface_type;
 	struct mwifiex_private *priv[MWIFIEX_MAX_BSS_NUM];
 	u8 priv_num;
 	const struct firmware *firmware;
 	char fw_name[32];
+	int winner;
 	struct device *dev;
 	bool surprise_removed;
 	u32 fw_release_number;
@@ -876,7 +888,7 @@ struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
 						*adapter, u8 bss_index);
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
-int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *);
+int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
 int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
 
 void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
new file mode 100644
index 0000000..602c254
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -0,0 +1,1948 @@
+/*
+ * Marvell Wireless LAN device driver: PCIE specific handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include <linux/firmware.h>
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+#include "pcie.h"
+
+#define PCIE_VERSION	"1.0"
+#define DRV_NAME        "Marvell mwifiex PCIe"
+
+static u8 user_rmmod;
+
+static struct mwifiex_if_ops pcie_ops;
+
+static struct semaphore add_remove_card_sem;
+static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter);
+static int mwifiex_pcie_resume(struct pci_dev *pdev);
+
+/*
+ * This function is called after skb allocation to update
+ * "skb->cb" with physical address of data pointer.
+ */
+static phys_addr_t *mwifiex_update_sk_buff_pa(struct sk_buff *skb)
+{
+	phys_addr_t *buf_pa = MWIFIEX_SKB_PACB(skb);
+
+	*buf_pa = (phys_addr_t)virt_to_phys(skb->data);
+
+	return buf_pa;
+}
+
+/*
+ * This function reads sleep cookie and checks if FW is ready
+ */
+static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
+{
+	u32 *cookie_addr;
+	struct pcie_service_card *card = adapter->card;
+
+	if (card->sleep_cookie) {
+		cookie_addr = (u32 *)card->sleep_cookie->data;
+		dev_dbg(adapter->dev, "info: ACCESS_HW: sleep cookie=0x%x\n",
+			*cookie_addr);
+		if (*cookie_addr == FW_AWAKE_COOKIE)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * This function probes an mwifiex device and registers it. It allocates
+ * the card structure, enables PCIE function number and initiates the
+ * device registration and initialization procedure by adding a logical
+ * interface.
+ */
+static int __devinit mwifiex_pcie_probe(struct pci_dev *pdev,
+					const struct pci_device_id *ent)
+{
+	struct pcie_service_card *card;
+
+	pr_debug("info: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
+				pdev->vendor, pdev->device, pdev->revision);
+
+	card = kzalloc(sizeof(struct pcie_service_card), GFP_KERNEL);
+	if (!card) {
+		pr_err("%s: failed to alloc memory\n", __func__);
+		return -ENOMEM;
+	}
+
+	card->dev = pdev;
+
+	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
+			     MWIFIEX_PCIE)) {
+		pr_err("%s failed\n", __func__);
+		kfree(card);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This function removes the interface and frees up the card structure.
+ */
+static void mwifiex_pcie_remove(struct pci_dev *pdev)
+{
+	struct pcie_service_card *card;
+	struct mwifiex_adapter *adapter;
+	int i;
+
+	card = pci_get_drvdata(pdev);
+	if (!card)
+		return;
+
+	adapter = card->adapter;
+	if (!adapter || !adapter->priv_num)
+		return;
+
+	if (user_rmmod) {
+#ifdef CONFIG_PM
+		if (adapter->is_suspended)
+			mwifiex_pcie_resume(pdev);
+#endif
+
+		for (i = 0; i < adapter->priv_num; i++)
+			if ((GET_BSS_ROLE(adapter->priv[i]) ==
+						MWIFIEX_BSS_ROLE_STA) &&
+					adapter->priv[i]->media_connected)
+				mwifiex_deauthenticate(adapter->priv[i], NULL);
+
+		mwifiex_disable_auto_ds(mwifiex_get_priv(adapter,
+						 MWIFIEX_BSS_ROLE_ANY));
+
+		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
+						MWIFIEX_BSS_ROLE_ANY),
+					 MWIFIEX_FUNC_SHUTDOWN);
+	}
+
+	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
+	kfree(card);
+}
+
+/*
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not suspended, this function allocates and sends a host
+ * sleep activate request to the firmware and turns off the traffic.
+ */
+static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mwifiex_adapter *adapter;
+	struct pcie_service_card *card;
+	int hs_actived, i;
+
+	if (pdev) {
+		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
+		if (!card || card->adapter) {
+			pr_err("Card or adapter structure is not valid\n");
+			return 0;
+		}
+	} else {
+		pr_err("PCIE device is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	hs_actived = mwifiex_enable_hs(adapter);
+
+	/* Indicate device suspended */
+	adapter->is_suspended = true;
+
+	for (i = 0; i < adapter->priv_num; i++)
+		netif_carrier_off(adapter->priv[i]->netdev);
+
+	return 0;
+}
+
+/*
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not resumed, this function turns on the traffic and
+ * sends a host sleep cancel request to the firmware.
+ */
+static int mwifiex_pcie_resume(struct pci_dev *pdev)
+{
+	struct mwifiex_adapter *adapter;
+	struct pcie_service_card *card;
+	int i;
+
+	if (pdev) {
+		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
+		if (!card || !card->adapter) {
+			pr_err("Card or adapter structure is not valid\n");
+			return 0;
+		}
+	} else {
+		pr_err("PCIE device is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	if (!adapter->is_suspended) {
+		dev_warn(adapter->dev, "Device already resumed\n");
+		return 0;
+	}
+
+	adapter->is_suspended = false;
+
+	for (i = 0; i < adapter->priv_num; i++)
+		if (adapter->priv[i]->media_connected)
+			netif_carrier_on(adapter->priv[i]->netdev);
+
+	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
+			      MWIFIEX_ASYNC_CMD);
+
+	return 0;
+}
+
+#define PCIE_VENDOR_ID_MARVELL              (0x11ab)
+#define PCIE_DEVICE_ID_MARVELL_88W8766P		(0x2b30)
+
+static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
+	{
+		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(pci, mwifiex_ids);
+
+/* PCI Device Driver */
+static struct pci_driver mwifiex_pcie = {
+	.name     = "mwifiex_pcie",
+	.id_table = mwifiex_ids,
+	.probe    = mwifiex_pcie_probe,
+	.remove   = mwifiex_pcie_remove,
+#ifdef CONFIG_PM
+	/* Power Management Hooks */
+	.suspend  = mwifiex_pcie_suspend,
+	.resume   = mwifiex_pcie_resume,
+#endif
+};
+
+/*
+ * This function writes data into PCIE card register.
+ */
+static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	iowrite32(data, card->pci_mmap1 + reg);
+
+	return 0;
+}
+
+/*
+ * This function reads data from PCIE card register.
+ */
+static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	*data = ioread32(card->pci_mmap1 + reg);
+
+	return 0;
+}
+
+/*
+ * This function wakes up the card.
+ *
+ * A host power up command is written to the card configuration
+ * register to wake up the card.
+ */
+static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
+{
+	int i = 0;
+
+	while (mwifiex_pcie_ok_to_access_hw(adapter)) {
+		i++;
+		udelay(10);
+		/* 50ms max wait */
+		if (i == 50000)
+			break;
+	}
+
+	dev_dbg(adapter->dev, "event: Wakeup device...\n");
+
+	/* Enable interrupts or any chip access will wakeup device */
+	if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK, HOST_INTR_MASK)) {
+		dev_warn(adapter->dev, "Enable host interrupt failed\n");
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "PCIE wakeup: Setting PS_STATE_AWAKE\n");
+	adapter->ps_state = PS_STATE_AWAKE;
+
+	return 0;
+}
+
+/*
+ * This function is called after the card has woken up.
+ *
+ * The card configuration register is reset.
+ */
+static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
+{
+	dev_dbg(adapter->dev, "cmd: Wakeup device completed\n");
+
+	return 0;
+}
+
+/*
+ * This function disables the host interrupt.
+ *
+ * The host interrupt mask is read, the disable bit is reset and
+ * written back to the card host interrupt mask register.
+ */
+static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
+{
+	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
+		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK,
+				      0x00000000)) {
+			dev_warn(adapter->dev, "Disable host interrupt failed\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This function enables the host interrupt.
+ *
+ * The host interrupt enable mask is written to the card
+ * host interrupt mask register.
+ */
+static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
+{
+	if (mwifiex_pcie_ok_to_access_hw(adapter)) {
+		/* Simply write the mask to the register */
+		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK,
+				      HOST_INTR_MASK)) {
+			dev_warn(adapter->dev, "Enable host interrupt failed\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This function creates buffer descriptor ring for TX
+ */
+static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
+	int i;
+	phys_addr_t *buf_pa;
+
+	/*
+	 * driver maintaines the write pointer and firmware maintaines the read
+	 * pointer. The write pointer starts at 0 (zero) while the read pointer
+	 * starts at zero with rollover bit set
+	 */
+	card->txbd_wrptr = 0;
+	card->txbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
+
+	/* allocate shared memory for the BD ring and divide the same in to
+	   several descriptors */
+	card->txbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
+				MWIFIEX_MAX_TXRX_BD;
+	dev_dbg(adapter->dev, "info: txbd_ring: Allocating %d bytes\n",
+				card->txbd_ring_size);
+	card->txbd_ring_vbase = kzalloc(card->txbd_ring_size, GFP_KERNEL);
+	if (!card->txbd_ring_vbase) {
+		dev_err(adapter->dev, "Unable to allocate buffer for txbd ring.\n");
+		kfree(card->txbd_ring_vbase);
+		return -1;
+	}
+	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
+
+	dev_dbg(adapter->dev, "info: txbd_ring - base: %p, pbase: %#x:%x,"
+			"len: %x\n", card->txbd_ring_vbase,
+			(u32)card->txbd_ring_pbase,
+			(u32)((u64)card->txbd_ring_pbase >> 32),
+			card->txbd_ring_size);
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		card->txbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
+				(card->txbd_ring_vbase +
+				(sizeof(struct mwifiex_pcie_buf_desc) * i));
+
+		/* Allocate buffer here so that firmware can DMA data from it */
+		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
+		if (!skb) {
+			dev_err(adapter->dev, "Unable to allocate skb for TX ring.\n");
+			kfree(card->txbd_ring_vbase);
+			return -ENOMEM;
+		}
+		buf_pa = mwifiex_update_sk_buff_pa(skb);
+
+		skb_put(skb, MWIFIEX_RX_DATA_BUF_SIZE);
+		dev_dbg(adapter->dev, "info: TX ring: add new skb base: %p, "
+				"buf_base: %p, buf_pbase: %#x:%x, "
+				"buf_len: %#x\n", skb, skb->data,
+				(u32)*buf_pa, (u32)(((u64)*buf_pa >> 32)),
+				skb->len);
+
+		card->tx_buf_list[i] = skb;
+		card->txbd_ring[i]->paddr = *buf_pa;
+		card->txbd_ring[i]->len = (u16)skb->len;
+		card->txbd_ring[i]->flags = 0;
+	}
+
+	return 0;
+}
+
+static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		if (card->tx_buf_list[i])
+			dev_kfree_skb_any(card->tx_buf_list[i]);
+		card->tx_buf_list[i] = NULL;
+		card->txbd_ring[i]->paddr = 0;
+		card->txbd_ring[i]->len = 0;
+		card->txbd_ring[i]->flags = 0;
+		card->txbd_ring[i] = NULL;
+	}
+
+	kfree(card->txbd_ring_vbase);
+	card->txbd_ring_size = 0;
+	card->txbd_wrptr = 0;
+	card->txbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->txbd_ring_vbase = NULL;
+
+	return 0;
+}
+
+/*
+ * This function creates buffer descriptor ring for RX
+ */
+static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
+	int i;
+	phys_addr_t *buf_pa;
+
+	/*
+	 * driver maintaines the read pointer and firmware maintaines the write
+	 * pointer. The write pointer starts at 0 (zero) while the read pointer
+	 * starts at zero with rollover bit set
+	 */
+	card->rxbd_wrptr = 0;
+	card->rxbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
+
+	card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
+				MWIFIEX_MAX_TXRX_BD;
+	dev_dbg(adapter->dev, "info: rxbd_ring: Allocating %d bytes\n",
+				card->rxbd_ring_size);
+	card->rxbd_ring_vbase = kzalloc(card->rxbd_ring_size, GFP_KERNEL);
+	if (!card->rxbd_ring_vbase) {
+		dev_err(adapter->dev, "Unable to allocate buffer for "
+				"rxbd_ring.\n");
+		return -1;
+	}
+	card->rxbd_ring_pbase = virt_to_phys(card->rxbd_ring_vbase);
+
+	dev_dbg(adapter->dev, "info: rxbd_ring - base: %p, pbase: %#x:%x,"
+			"len: %#x\n", card->rxbd_ring_vbase,
+			(u32)card->rxbd_ring_pbase,
+			(u32)((u64)card->rxbd_ring_pbase >> 32),
+			card->rxbd_ring_size);
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		card->rxbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
+				(card->rxbd_ring_vbase +
+				(sizeof(struct mwifiex_pcie_buf_desc) * i));
+
+		/* Allocate skb here so that firmware can DMA data from it */
+		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
+		if (!skb) {
+			dev_err(adapter->dev, "Unable to allocate skb for RX ring.\n");
+			kfree(card->rxbd_ring_vbase);
+			return -ENOMEM;
+		}
+		buf_pa = mwifiex_update_sk_buff_pa(skb);
+		skb_put(skb, MWIFIEX_RX_DATA_BUF_SIZE);
+
+		dev_dbg(adapter->dev, "info: RX ring: add new skb base: %p, "
+				"buf_base: %p, buf_pbase: %#x:%x, "
+				"buf_len: %#x\n", skb, skb->data,
+				(u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
+				skb->len);
+
+		card->rx_buf_list[i] = skb;
+		card->rxbd_ring[i]->paddr = *buf_pa;
+		card->rxbd_ring[i]->len = (u16)skb->len;
+		card->rxbd_ring[i]->flags = 0;
+	}
+
+	return 0;
+}
+
+/*
+ * This function deletes Buffer descriptor ring for RX
+ */
+static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		if (card->rx_buf_list[i])
+			dev_kfree_skb_any(card->rx_buf_list[i]);
+		card->rx_buf_list[i] = NULL;
+		card->rxbd_ring[i]->paddr = 0;
+		card->rxbd_ring[i]->len = 0;
+		card->rxbd_ring[i]->flags = 0;
+		card->rxbd_ring[i] = NULL;
+	}
+
+	kfree(card->rxbd_ring_vbase);
+	card->rxbd_ring_size = 0;
+	card->rxbd_wrptr = 0;
+	card->rxbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->rxbd_ring_vbase = NULL;
+
+	return 0;
+}
+
+/*
+ * This function creates buffer descriptor ring for Events
+ */
+static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
+	int i;
+	phys_addr_t *buf_pa;
+
+	/*
+	 * driver maintaines the read pointer and firmware maintaines the write
+	 * pointer. The write pointer starts at 0 (zero) while the read pointer
+	 * starts at zero with rollover bit set
+	 */
+	card->evtbd_wrptr = 0;
+	card->evtbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
+
+	card->evtbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
+				MWIFIEX_MAX_EVT_BD;
+	dev_dbg(adapter->dev, "info: evtbd_ring: Allocating %d bytes\n",
+				card->evtbd_ring_size);
+	card->evtbd_ring_vbase = kzalloc(card->evtbd_ring_size, GFP_KERNEL);
+	if (!card->evtbd_ring_vbase) {
+		dev_err(adapter->dev, "Unable to allocate buffer. "
+				"Terminating download\n");
+		return -1;
+	}
+	card->evtbd_ring_pbase = virt_to_phys(card->evtbd_ring_vbase);
+
+	dev_dbg(adapter->dev, "info: CMDRSP/EVT bd_ring - base: %p, "
+		       "pbase: %#x:%x, len: %#x\n", card->evtbd_ring_vbase,
+		       (u32)card->evtbd_ring_pbase,
+		       (u32)((u64)card->evtbd_ring_pbase >> 32),
+		       card->evtbd_ring_size);
+
+	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
+		card->evtbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
+				(card->evtbd_ring_vbase +
+				(sizeof(struct mwifiex_pcie_buf_desc) * i));
+
+		/* Allocate skb here so that firmware can DMA data from it */
+		skb = dev_alloc_skb(MAX_EVENT_SIZE);
+		if (!skb) {
+			dev_err(adapter->dev, "Unable to allocate skb for EVENT buf.\n");
+			kfree(card->evtbd_ring_vbase);
+			return -ENOMEM;
+		}
+		buf_pa = mwifiex_update_sk_buff_pa(skb);
+		skb_put(skb, MAX_EVENT_SIZE);
+
+		dev_dbg(adapter->dev, "info: Evt ring: add new skb. base: %p, "
+			       "buf_base: %p, buf_pbase: %#x:%x, "
+			       "buf_len: %#x\n", skb, skb->data,
+			       (u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
+			       skb->len);
+
+		card->evt_buf_list[i] = skb;
+		card->evtbd_ring[i]->paddr = *buf_pa;
+		card->evtbd_ring[i]->len = (u16)skb->len;
+		card->evtbd_ring[i]->flags = 0;
+	}
+
+	return 0;
+}
+
+/*
+ * This function deletes Buffer descriptor ring for Events
+ */
+static int mwifiex_pcie_delete_evtbd_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
+		if (card->evt_buf_list[i])
+			dev_kfree_skb_any(card->evt_buf_list[i]);
+		card->evt_buf_list[i] = NULL;
+		card->evtbd_ring[i]->paddr = 0;
+		card->evtbd_ring[i]->len = 0;
+		card->evtbd_ring[i]->flags = 0;
+		card->evtbd_ring[i] = NULL;
+	}
+
+	kfree(card->evtbd_ring_vbase);
+	card->evtbd_wrptr = 0;
+	card->evtbd_rdptr = 0 | MWIFIEX_BD_FLAG_ROLLOVER_IND;
+	card->evtbd_ring_size = 0;
+	card->evtbd_ring_vbase = NULL;
+
+	return 0;
+}
+
+/*
+ * This function allocates a buffer for CMDRSP
+ */
+static int mwifiex_pcie_alloc_cmdrsp_buf(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
+
+	/* Allocate memory for receiving command response data */
+	skb = dev_alloc_skb(MWIFIEX_UPLD_SIZE);
+	if (!skb) {
+		dev_err(adapter->dev, "Unable to allocate skb for command "
+				      "response data.\n");
+		return -ENOMEM;
+	}
+	mwifiex_update_sk_buff_pa(skb);
+	skb_put(skb, MWIFIEX_UPLD_SIZE);
+	card->cmdrsp_buf = skb;
+
+	skb = NULL;
+	/* Allocate memory for sending command to firmware */
+	skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
+	if (!skb) {
+		dev_err(adapter->dev, "Unable to allocate skb for command "
+				      "data.\n");
+		return -ENOMEM;
+	}
+	mwifiex_update_sk_buff_pa(skb);
+	skb_put(skb, MWIFIEX_SIZE_OF_CMD_BUFFER);
+	card->cmd_buf = skb;
+
+	return 0;
+}
+
+/*
+ * This function deletes a buffer for CMDRSP
+ */
+static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card;
+
+	if (!adapter)
+		return 0;
+
+	card = adapter->card;
+
+	if (card && card->cmdrsp_buf)
+		dev_kfree_skb_any(card->cmdrsp_buf);
+
+	if (card && card->cmd_buf)
+		dev_kfree_skb_any(card->cmd_buf);
+
+	return 0;
+}
+
+/*
+ * This function allocates a buffer for sleep cookie
+ */
+static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
+{
+	struct sk_buff *skb;
+	struct pcie_service_card *card = adapter->card;
+
+	/* Allocate memory for sleep cookie */
+	skb = dev_alloc_skb(sizeof(u32));
+	if (!skb) {
+		dev_err(adapter->dev, "Unable to allocate skb for sleep "
+				      "cookie!\n");
+		return -ENOMEM;
+	}
+	mwifiex_update_sk_buff_pa(skb);
+	skb_put(skb, sizeof(u32));
+
+	/* Init val of Sleep Cookie */
+	*(u32 *)skb->data = FW_AWAKE_COOKIE;
+
+	dev_dbg(adapter->dev, "alloc_scook: sleep cookie=0x%x\n",
+				*((u32 *)skb->data));
+
+	/* Save the sleep cookie */
+	card->sleep_cookie = skb;
+
+	return 0;
+}
+
+/*
+ * This function deletes buffer for sleep cookie
+ */
+static int mwifiex_pcie_delete_sleep_cookie_buf(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card;
+
+	if (!adapter)
+		return 0;
+
+	card = adapter->card;
+
+	if (card && card->sleep_cookie) {
+		dev_kfree_skb_any(card->sleep_cookie);
+		card->sleep_cookie = NULL;
+	}
+
+	return 0;
+}
+
+/*
+ * This function sends data buffer to device
+ */
+static int
+mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+{
+	struct pcie_service_card *card = adapter->card;
+	u32 wrindx, rdptr;
+	phys_addr_t *buf_pa;
+	__le16 *tmp;
+
+	if (!mwifiex_pcie_ok_to_access_hw(adapter))
+		mwifiex_pm_wakeup_card(adapter);
+
+	/* Read the TX ring read pointer set by firmware */
+	if (mwifiex_read_reg(adapter, REG_TXBD_RDPTR, &rdptr)) {
+		dev_err(adapter->dev, "SEND DATA: failed to read "
+				      "REG_TXBD_RDPTR\n");
+		return -1;
+	}
+
+	wrindx = card->txbd_wrptr & MWIFIEX_TXBD_MASK;
+
+	dev_dbg(adapter->dev, "info: SEND DATA: <Rd: %#x, Wr: %#x>\n", rdptr,
+				card->txbd_wrptr);
+	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) !=
+			(rdptr & MWIFIEX_TXBD_MASK)) ||
+	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
+			(rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
+		struct sk_buff *skb_data;
+		u8 *payload;
+
+		adapter->data_sent = true;
+		skb_data = card->tx_buf_list[wrindx];
+		memcpy(skb_data->data, skb->data, skb->len);
+		payload = skb_data->data;
+		tmp = (__le16 *)&payload[0];
+		*tmp = cpu_to_le16((u16)skb->len);
+		tmp = (__le16 *)&payload[2];
+		*tmp = cpu_to_le16(MWIFIEX_TYPE_DATA);
+		skb_put(skb_data, MWIFIEX_RX_DATA_BUF_SIZE - skb_data->len);
+		skb_trim(skb_data, skb->len);
+		buf_pa = MWIFIEX_SKB_PACB(skb_data);
+		card->txbd_ring[wrindx]->paddr = *buf_pa;
+		card->txbd_ring[wrindx]->len = (u16)skb_data->len;
+		card->txbd_ring[wrindx]->flags = MWIFIEX_BD_FLAG_FIRST_DESC |
+						MWIFIEX_BD_FLAG_LAST_DESC;
+
+		if ((++card->txbd_wrptr & MWIFIEX_TXBD_MASK) ==
+							MWIFIEX_MAX_TXRX_BD)
+			card->txbd_wrptr = ((card->txbd_wrptr &
+						MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
+						MWIFIEX_BD_FLAG_ROLLOVER_IND);
+
+		/* Write the TX ring write pointer in to REG_TXBD_WRPTR */
+		if (mwifiex_write_reg(adapter, REG_TXBD_WRPTR,
+							card->txbd_wrptr)) {
+			dev_err(adapter->dev, "SEND DATA: failed to write "
+					      "REG_TXBD_WRPTR\n");
+			return 0;
+		}
+
+		/* Send the TX ready interrupt */
+		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+				      CPU_INTR_DNLD_RDY)) {
+			dev_err(adapter->dev, "SEND DATA: failed to assert "
+					      "door-bell interrupt.\n");
+			return -1;
+		}
+		dev_dbg(adapter->dev, "info: SEND DATA: Updated <Rd: %#x, Wr: "
+				      "%#x> and sent packet to firmware "
+				      "successfully\n", rdptr,
+				      card->txbd_wrptr);
+	} else {
+		dev_dbg(adapter->dev, "info: TX Ring full, can't send anymore "
+				      "packets to firmware\n");
+		adapter->data_sent = true;
+		/* Send the TX ready interrupt */
+		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+				      CPU_INTR_DNLD_RDY))
+			dev_err(adapter->dev, "SEND DATA: failed to assert "
+					      "door-bell interrupt\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles received buffer ring and
+ * dispatches packets to upper
+ */
+static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	u32 wrptr, rd_index;
+	int ret = 0;
+	struct sk_buff *skb_tmp = NULL;
+
+	/* Read the RX ring Write pointer set by firmware */
+	if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
+		dev_err(adapter->dev, "RECV DATA: failed to read "
+				      "REG_TXBD_RDPTR\n");
+		ret = -1;
+		goto done;
+	}
+
+	while (((wrptr & MWIFIEX_RXBD_MASK) !=
+		(card->rxbd_rdptr & MWIFIEX_RXBD_MASK)) ||
+	       ((wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) ==
+		(card->rxbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
+		struct sk_buff *skb_data;
+		u16 rx_len;
+
+		rd_index = card->rxbd_rdptr & MWIFIEX_RXBD_MASK;
+		skb_data = card->rx_buf_list[rd_index];
+
+		/* Get data length from interface header -
+		   first byte is len, second byte is type */
+		rx_len = *((u16 *)skb_data->data);
+		dev_dbg(adapter->dev, "info: RECV DATA: Rd=%#x, Wr=%#x, "
+				"Len=%d\n", card->rxbd_rdptr, wrptr, rx_len);
+		skb_tmp = dev_alloc_skb(rx_len);
+		if (!skb_tmp) {
+			dev_dbg(adapter->dev, "info: Failed to alloc skb "
+					      "for RX\n");
+			ret = -EBUSY;
+			goto done;
+		}
+
+		skb_put(skb_tmp, rx_len);
+
+		memcpy(skb_tmp->data, skb_data->data + INTF_HEADER_LEN, rx_len);
+		if ((++card->rxbd_rdptr & MWIFIEX_RXBD_MASK) ==
+							MWIFIEX_MAX_TXRX_BD) {
+			card->rxbd_rdptr = ((card->rxbd_rdptr &
+					     MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
+					    MWIFIEX_BD_FLAG_ROLLOVER_IND);
+		}
+		dev_dbg(adapter->dev, "info: RECV DATA: <Rd: %#x, Wr: %#x>\n",
+				card->rxbd_rdptr, wrptr);
+
+		/* Write the RX ring read pointer in to REG_RXBD_RDPTR */
+		if (mwifiex_write_reg(adapter, REG_RXBD_RDPTR,
+				      card->rxbd_rdptr)) {
+			dev_err(adapter->dev, "RECV DATA: failed to "
+					      "write REG_RXBD_RDPTR\n");
+			ret = -1;
+			goto done;
+		}
+
+		/* Read the RX ring Write pointer set by firmware */
+		if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
+			dev_err(adapter->dev, "RECV DATA: failed to read "
+					      "REG_TXBD_RDPTR\n");
+			ret = -1;
+			goto done;
+		}
+		dev_dbg(adapter->dev, "info: RECV DATA: Received packet from "
+				      "firmware successfully\n");
+		mwifiex_handle_rx_packet(adapter, skb_tmp);
+	}
+
+done:
+	if (ret && skb_tmp)
+		dev_kfree_skb_any(skb_tmp);
+	return ret;
+}
+
+/*
+ * This function downloads the boot command to device
+ */
+static int
+mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+{
+	phys_addr_t *buf_pa = MWIFIEX_SKB_PACB(skb);
+
+	if (!(skb->data && skb->len && *buf_pa)) {
+		dev_err(adapter->dev, "Invalid parameter in %s <%p, %#x:%x, "
+				"%x>\n", __func__, skb->data, skb->len,
+				(u32)*buf_pa, (u32)((u64)*buf_pa >> 32));
+		return -1;
+	}
+
+	/* Write the lower 32bits of the physical address to scratch
+	 * register 0 */
+	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_0_REG, (u32)*buf_pa)) {
+		dev_err(adapter->dev, "%s: failed to write download command "
+				      "to boot code.\n", __func__);
+		return -1;
+	}
+
+	/* Write the upper 32bits of the physical address to scratch
+	 * register 1 */
+	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_1_REG,
+			      (u32)((u64)*buf_pa >> 32))) {
+		dev_err(adapter->dev, "%s: failed to write download command "
+				      "to boot code.\n", __func__);
+		return -1;
+	}
+
+	/* Write the command length to scratch register 2 */
+	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_2_REG, skb->len)) {
+		dev_err(adapter->dev, "%s: failed to write command length to "
+				      "scratch register 2\n", __func__);
+		return -1;
+	}
+
+	/* Ring the door bell */
+	if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+			      CPU_INTR_DOOR_BELL)) {
+		dev_err(adapter->dev, "%s: failed to assert door-bell "
+				      "interrupt.\n", __func__);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This function downloads commands to the device
+ */
+static int
+mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+{
+	struct pcie_service_card *card = adapter->card;
+	int ret = 0;
+	phys_addr_t *cmd_buf_pa;
+	phys_addr_t *cmdrsp_buf_pa;
+
+	if (!(skb->data && skb->len)) {
+		dev_err(adapter->dev, "Invalid parameter in %s <%p, %#x>\n",
+				      __func__, skb->data, skb->len);
+		return -1;
+	}
+
+	/* Make sure a command response buffer is available */
+	if (!card->cmdrsp_buf) {
+		dev_err(adapter->dev, "No response buffer available, send "
+				      "command failed\n");
+		return -EBUSY;
+	}
+
+	/* Make sure a command buffer is available */
+	if (!card->cmd_buf) {
+		dev_err(adapter->dev, "Command buffer not available\n");
+		return -EBUSY;
+	}
+
+	adapter->cmd_sent = true;
+	/* Copy the given skb in to DMA accessable shared buffer */
+	skb_put(card->cmd_buf, MWIFIEX_SIZE_OF_CMD_BUFFER - card->cmd_buf->len);
+	skb_trim(card->cmd_buf, skb->len);
+	memcpy(card->cmd_buf->data, skb->data, skb->len);
+
+	/* To send a command, the driver will:
+		1. Write the 64bit physical address of the data buffer to
+		   SCRATCH1 + SCRATCH0
+		2. Ring the door bell (i.e. set the door bell interrupt)
+
+		In response to door bell interrupt, the firmware will perform
+		the DMA of the command packet (first header to obtain the total
+		length and then rest of the command).
+	*/
+
+	if (card->cmdrsp_buf) {
+		cmdrsp_buf_pa = MWIFIEX_SKB_PACB(card->cmdrsp_buf);
+		/* Write the lower 32bits of the cmdrsp buffer physical
+		   address */
+		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_LO,
+					(u32)*cmdrsp_buf_pa)) {
+			dev_err(adapter->dev, "Failed to write download command to boot code.\n");
+			ret = -1;
+			goto done;
+		}
+		/* Write the upper 32bits of the cmdrsp buffer physical
+		   address */
+		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_HI,
+					(u32)((u64)*cmdrsp_buf_pa >> 32))) {
+			dev_err(adapter->dev, "Failed to write download command"
+					      " to boot code.\n");
+			ret = -1;
+			goto done;
+		}
+	}
+
+	cmd_buf_pa = MWIFIEX_SKB_PACB(card->cmd_buf);
+	/* Write the lower 32bits of the physical address to REG_CMD_ADDR_LO */
+	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_LO,
+				(u32)*cmd_buf_pa)) {
+		dev_err(adapter->dev, "Failed to write download command "
+				      "to boot code.\n");
+		ret = -1;
+		goto done;
+	}
+	/* Write the upper 32bits of the physical address to REG_CMD_ADDR_HI */
+	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_HI,
+				(u32)((u64)*cmd_buf_pa >> 32))) {
+		dev_err(adapter->dev, "Failed to write download command "
+				      "to boot code.\n");
+		ret = -1;
+		goto done;
+	}
+
+	/* Write the command length to REG_CMD_SIZE */
+	if (mwifiex_write_reg(adapter, REG_CMD_SIZE,
+				card->cmd_buf->len)) {
+		dev_err(adapter->dev, "Failed to write command length to "
+				      "REG_CMD_SIZE\n");
+		ret = -1;
+		goto done;
+	}
+
+	/* Ring the door bell */
+	if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+			      CPU_INTR_DOOR_BELL)) {
+		dev_err(adapter->dev, "Failed to assert door-bell "
+				      "interrupt.\n");
+		ret = -1;
+		goto done;
+	}
+
+done:
+	if (ret)
+		adapter->cmd_sent = false;
+
+	return 0;
+}
+
+/*
+ * This function handles command complete interrupt
+ */
+static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	int count = 0;
+
+	dev_dbg(adapter->dev, "info: Rx CMD Response\n");
+
+	if (!adapter->curr_cmd) {
+		skb_pull(card->cmdrsp_buf, INTF_HEADER_LEN);
+		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
+			mwifiex_process_sleep_confirm_resp(adapter,
+					card->cmdrsp_buf->data,
+					card->cmdrsp_buf->len);
+			while (mwifiex_pcie_ok_to_access_hw(adapter) &&
+							(count++ < 10))
+				udelay(50);
+		} else {
+			dev_err(adapter->dev, "There is no command but "
+					      "got cmdrsp\n");
+		}
+		memcpy(adapter->upld_buf, card->cmdrsp_buf->data,
+		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER,
+			     card->cmdrsp_buf->len));
+		skb_push(card->cmdrsp_buf, INTF_HEADER_LEN);
+	} else if (mwifiex_pcie_ok_to_access_hw(adapter)) {
+		skb_pull(card->cmdrsp_buf, INTF_HEADER_LEN);
+		adapter->curr_cmd->resp_skb = card->cmdrsp_buf;
+		adapter->cmd_resp_received = true;
+		/* Take the pointer and set it to CMD node and will
+		   return in the response complete callback */
+		card->cmdrsp_buf = NULL;
+
+		/* Clear the cmd-rsp buffer address in scratch registers. This
+		   will prevent firmware from writing to the same response
+		   buffer again. */
+		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_LO, 0)) {
+			dev_err(adapter->dev, "cmd_done: failed to clear "
+					      "cmd_rsp address.\n");
+			return -1;
+		}
+		/* Write the upper 32bits of the cmdrsp buffer physical
+		   address */
+		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_HI, 0)) {
+			dev_err(adapter->dev, "cmd_done: failed to clear "
+					      "cmd_rsp address.\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Command Response processing complete handler
+ */
+static int mwifiex_pcie_cmdrsp_complete(struct mwifiex_adapter *adapter,
+					struct sk_buff *skb)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	if (skb) {
+		card->cmdrsp_buf = skb;
+		skb_push(card->cmdrsp_buf, INTF_HEADER_LEN);
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles firmware event ready interrupt
+ */
+static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
+	u32 wrptr, event;
+
+	if (adapter->event_received) {
+		dev_dbg(adapter->dev, "info: Event being processed, "\
+				"do not process this interrupt just yet\n");
+		return 0;
+	}
+
+	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
+		dev_dbg(adapter->dev, "info: Invalid read pointer...\n");
+		return -1;
+	}
+
+	/* Read the event ring write pointer set by firmware */
+	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
+		dev_err(adapter->dev, "EventReady: failed to read REG_EVTBD_WRPTR\n");
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "info: EventReady: Initial <Rd: 0x%x, Wr: 0x%x>",
+			card->evtbd_rdptr, wrptr);
+	if (((wrptr & MWIFIEX_EVTBD_MASK) !=
+	     (card->evtbd_rdptr & MWIFIEX_EVTBD_MASK)) ||
+	    ((wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) ==
+	     (card->evtbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
+		struct sk_buff *skb_cmd;
+		__le16 data_len = 0;
+		u16 evt_len;
+
+		dev_dbg(adapter->dev, "info: Read Index: %d\n", rdptr);
+		skb_cmd = card->evt_buf_list[rdptr];
+		/* Take the pointer and set it to event pointer in adapter
+		   and will return back after event handling callback */
+		card->evt_buf_list[rdptr] = NULL;
+		card->evtbd_ring[rdptr]->paddr = 0;
+		card->evtbd_ring[rdptr]->len = 0;
+		card->evtbd_ring[rdptr]->flags = 0;
+
+		event = *(u32 *) &skb_cmd->data[INTF_HEADER_LEN];
+		adapter->event_cause = event;
+		/* The first 4bytes will be the event transfer header
+		   len is 2 bytes followed by type which is 2 bytes */
+		memcpy(&data_len, skb_cmd->data, sizeof(__le16));
+		evt_len = le16_to_cpu(data_len);
+
+		skb_pull(skb_cmd, INTF_HEADER_LEN);
+		dev_dbg(adapter->dev, "info: Event length: %d\n", evt_len);
+
+		if ((evt_len > 0) && (evt_len  < MAX_EVENT_SIZE))
+			memcpy(adapter->event_body, skb_cmd->data +
+			       MWIFIEX_EVENT_HEADER_LEN, evt_len -
+			       MWIFIEX_EVENT_HEADER_LEN);
+
+		adapter->event_received = true;
+		adapter->event_skb = skb_cmd;
+
+		/* Do not update the event read pointer here, wait till the
+		   buffer is released. This is just to make things simpler,
+		   we need to find a better method of managing these buffers.
+		*/
+	}
+
+	return 0;
+}
+
+/*
+ * Event processing complete handler
+ */
+static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
+				       struct sk_buff *skb)
+{
+	struct pcie_service_card *card = adapter->card;
+	int ret = 0;
+	u32 rdptr = card->evtbd_rdptr & MWIFIEX_EVTBD_MASK;
+	u32 wrptr;
+	phys_addr_t *buf_pa;
+
+	if (!skb)
+		return 0;
+
+	if (rdptr >= MWIFIEX_MAX_EVT_BD)
+		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
+					rdptr);
+
+	/* Read the event ring write pointer set by firmware */
+	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
+		dev_err(adapter->dev, "event_complete: failed to read REG_EVTBD_WRPTR\n");
+		ret = -1;
+		goto done;
+	}
+
+	if (!card->evt_buf_list[rdptr]) {
+		skb_push(skb, INTF_HEADER_LEN);
+		card->evt_buf_list[rdptr] = skb;
+		buf_pa = MWIFIEX_SKB_PACB(skb);
+		card->evtbd_ring[rdptr]->paddr = *buf_pa;
+		card->evtbd_ring[rdptr]->len = (u16)skb->len;
+		card->evtbd_ring[rdptr]->flags = 0;
+		skb = NULL;
+	} else {
+		dev_dbg(adapter->dev, "info: ERROR: Buffer is still valid at "
+				      "index %d, <%p, %p>\n", rdptr,
+				      card->evt_buf_list[rdptr], skb);
+	}
+
+	if ((++card->evtbd_rdptr & MWIFIEX_EVTBD_MASK) == MWIFIEX_MAX_EVT_BD) {
+		card->evtbd_rdptr = ((card->evtbd_rdptr &
+					MWIFIEX_BD_FLAG_ROLLOVER_IND) ^
+					MWIFIEX_BD_FLAG_ROLLOVER_IND);
+	}
+
+	dev_dbg(adapter->dev, "info: Updated <Rd: 0x%x, Wr: 0x%x>",
+				card->evtbd_rdptr, wrptr);
+
+	/* Write the event ring read pointer in to REG_EVTBD_RDPTR */
+	if (mwifiex_write_reg(adapter, REG_EVTBD_RDPTR, card->evtbd_rdptr)) {
+		dev_err(adapter->dev, "event_complete: failed to read REG_EVTBD_RDPTR\n");
+		ret = -1;
+		goto done;
+	}
+
+done:
+	/* Free the buffer for failure case */
+	if (ret && skb)
+		dev_kfree_skb_any(skb);
+
+	dev_dbg(adapter->dev, "info: Check Events Again\n");
+	ret = mwifiex_pcie_process_event_ready(adapter);
+
+	return ret;
+}
+
+/*
+ * This function downloads the firmware to the card.
+ *
+ * Firmware is downloaded to the card in blocks. Every block download
+ * is tested for CRC errors, and retried a number of times before
+ * returning failure.
+ */
+static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
+				    struct mwifiex_fw_image *fw)
+{
+	int ret;
+	u8 *firmware = fw->fw_buf;
+	u32 firmware_len = fw->fw_len;
+	u32 offset = 0;
+	struct sk_buff *skb;
+	u32 txlen, tx_blocks = 0, tries, len;
+	u32 block_retry_cnt = 0;
+
+	if (!adapter) {
+		pr_err("adapter structure is not valid\n");
+		return -1;
+	}
+
+	if (!firmware || !firmware_len) {
+		dev_err(adapter->dev, "No firmware image found! "
+				      "Terminating download\n");
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "info: Downloading FW image (%d bytes)\n",
+				firmware_len);
+
+	if (mwifiex_pcie_disable_host_int(adapter)) {
+		dev_err(adapter->dev, "%s: Disabling interrupts"
+				      " failed.\n", __func__);
+		return -1;
+	}
+
+	skb = dev_alloc_skb(MWIFIEX_UPLD_SIZE);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	mwifiex_update_sk_buff_pa(skb);
+
+	/* Perform firmware data transfer */
+	do {
+		u32 ireg_intr = 0;
+
+		/* More data? */
+		if (offset >= firmware_len)
+			break;
+
+		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+			ret = mwifiex_read_reg(adapter, PCIE_SCRATCH_2_REG,
+					       &len);
+			if (ret) {
+				dev_warn(adapter->dev, "Failed reading length from boot code\n");
+				goto done;
+			}
+			if (len)
+				break;
+			udelay(10);
+		}
+
+		if (!len) {
+			break;
+		} else if (len > MWIFIEX_UPLD_SIZE) {
+			pr_err("FW download failure @ %d, invalid length %d\n",
+				offset, len);
+			ret = -1;
+			goto done;
+		}
+
+		txlen = len;
+
+		if (len & BIT(0)) {
+			block_retry_cnt++;
+			if (block_retry_cnt > MAX_WRITE_IOMEM_RETRY) {
+				pr_err("FW download failure @ %d, over max "
+				       "retry count\n", offset);
+				ret = -1;
+				goto done;
+			}
+			dev_err(adapter->dev, "FW CRC error indicated by the "
+					      "helper: len = 0x%04X, txlen = "
+					      "%d\n", len, txlen);
+			len &= ~BIT(0);
+			/* Setting this to 0 to resend from same offset */
+			txlen = 0;
+		} else {
+			block_retry_cnt = 0;
+			/* Set blocksize to transfer - checking for
+			   last block */
+			if (firmware_len - offset < txlen)
+				txlen = firmware_len - offset;
+
+			dev_dbg(adapter->dev, ".");
+
+			tx_blocks =
+				(txlen + MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD - 1) /
+				MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD;
+
+			/* Copy payload to buffer */
+			memmove(skb->data, &firmware[offset], txlen);
+		}
+
+		skb_put(skb, MWIFIEX_UPLD_SIZE - skb->len);
+		skb_trim(skb, tx_blocks * MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD);
+
+		/* Send the boot command to device */
+		if (mwifiex_pcie_send_boot_cmd(adapter, skb)) {
+			dev_err(adapter->dev, "Failed to send firmware download command\n");
+			ret = -1;
+			goto done;
+		}
+		/* Wait for the command done interrupt */
+		do {
+			if (mwifiex_read_reg(adapter, PCIE_CPU_INT_STATUS,
+					     &ireg_intr)) {
+				dev_err(adapter->dev, "%s: Failed to read "
+						      "interrupt status during "
+						      "fw dnld.\n", __func__);
+				ret = -1;
+				goto done;
+			}
+		} while ((ireg_intr & CPU_INTR_DOOR_BELL) ==
+			 CPU_INTR_DOOR_BELL);
+		offset += txlen;
+	} while (true);
+
+	dev_dbg(adapter->dev, "info:\nFW download over, size %d bytes\n",
+				offset);
+
+	ret = 0;
+
+done:
+	dev_kfree_skb_any(skb);
+	return ret;
+}
+
+/*
+ * This function checks the firmware status in card.
+ *
+ * The winner interface is also determined by this function.
+ */
+static int
+mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
+{
+	int ret = 0;
+	u32 firmware_stat, winner_status;
+	u32 tries;
+
+	/* Mask spurios interrupts */
+	if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS_MASK,
+				HOST_INTR_MASK)) {
+		dev_warn(adapter->dev, "Write register failed\n");
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "Setting driver ready signature\n");
+	if (mwifiex_write_reg(adapter, REG_DRV_READY, FIRMWARE_READY_PCIE)) {
+		dev_err(adapter->dev, "Failed to write driver ready signature\n");
+		return -1;
+	}
+
+	/* Wait for firmware initialization event */
+	for (tries = 0; tries < poll_num; tries++) {
+		if (mwifiex_read_reg(adapter, PCIE_SCRATCH_3_REG,
+				     &firmware_stat))
+			ret = -1;
+		else
+			ret = 0;
+		if (ret)
+			continue;
+		if (firmware_stat == FIRMWARE_READY_PCIE) {
+			ret = 0;
+			break;
+		} else {
+			mdelay(100);
+			ret = -1;
+		}
+	}
+
+	if (ret) {
+		if (mwifiex_read_reg(adapter, PCIE_SCRATCH_3_REG,
+				     &winner_status))
+			ret = -1;
+		else if (!winner_status) {
+			dev_err(adapter->dev, "PCI-E is the winner\n");
+			adapter->winner = 1;
+			ret = -1;
+		} else {
+			dev_err(adapter->dev, "PCI-E is not the winner <%#x, %d>, exit download\n",
+					ret, adapter->winner);
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function reads the interrupt status from card.
+ */
+static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
+{
+	u32 pcie_ireg;
+	unsigned long flags;
+
+	if (!mwifiex_pcie_ok_to_access_hw(adapter))
+		return;
+
+	if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS, &pcie_ireg)) {
+		dev_warn(adapter->dev, "Read register failed\n");
+		return;
+	}
+
+	if ((pcie_ireg != 0xFFFFFFFF) && (pcie_ireg)) {
+
+		mwifiex_pcie_disable_host_int(adapter);
+
+		/* Clear the pending interrupts */
+		if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS,
+				      ~pcie_ireg)) {
+			dev_warn(adapter->dev, "Write register failed\n");
+			return;
+		}
+		spin_lock_irqsave(&adapter->int_lock, flags);
+		adapter->int_status |= pcie_ireg;
+		spin_unlock_irqrestore(&adapter->int_lock, flags);
+
+		if (pcie_ireg & HOST_INTR_CMD_DONE) {
+			if ((adapter->ps_state == PS_STATE_SLEEP_CFM) ||
+			    (adapter->ps_state == PS_STATE_SLEEP)) {
+				mwifiex_pcie_enable_host_int(adapter);
+				if (mwifiex_write_reg(adapter,
+						PCIE_CPU_INT_EVENT,
+						CPU_INTR_SLEEP_CFM_DONE)) {
+					dev_warn(adapter->dev, "Write register"
+							       " failed\n");
+					return;
+
+				}
+			}
+		} else if (!adapter->pps_uapsd_mode &&
+			   adapter->ps_state == PS_STATE_SLEEP) {
+				/* Potentially for PCIe we could get other
+				 * interrupts like shared. Don't change power
+				 * state until cookie is set */
+				if (mwifiex_pcie_ok_to_access_hw(adapter))
+					adapter->ps_state = PS_STATE_AWAKE;
+		}
+	}
+}
+
+/*
+ * Interrupt handler for PCIe root port
+ *
+ * This function reads the interrupt status from firmware and assigns
+ * the main process in workqueue which will handle the interrupt.
+ */
+static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
+{
+	struct pci_dev *pdev = (struct pci_dev *)context;
+	struct pcie_service_card *card;
+	struct mwifiex_adapter *adapter;
+
+	if (!pdev) {
+		pr_debug("info: %s: pdev is NULL\n", (u8 *)pdev);
+		goto exit;
+	}
+
+	card = (struct pcie_service_card *) pci_get_drvdata(pdev);
+	if (!card || !card->adapter) {
+		pr_debug("info: %s: card=%p adapter=%p\n", __func__, card,
+						card ? card->adapter : NULL);
+		goto exit;
+	}
+	adapter = card->adapter;
+
+	if (adapter->surprise_removed)
+		goto exit;
+
+	mwifiex_interrupt_status(adapter);
+	queue_work(adapter->workqueue, &adapter->main_work);
+
+exit:
+	return IRQ_HANDLED;
+}
+
+/*
+ * This function checks the current interrupt status.
+ *
+ * The following interrupts are checked and handled by this function -
+ *      - Data sent
+ *      - Command sent
+ *      - Command received
+ *      - Packets received
+ *      - Events received
+ *
+ * In case of Rx packets received, the packets are uploaded from card to
+ * host and processed accordingly.
+ */
+static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
+{
+	int ret;
+	u32 pcie_ireg = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->int_lock, flags);
+	/* Clear out unused interrupts */
+	adapter->int_status &= HOST_INTR_MASK;
+	spin_unlock_irqrestore(&adapter->int_lock, flags);
+
+	while (adapter->int_status & HOST_INTR_MASK) {
+		if (adapter->int_status & HOST_INTR_DNLD_DONE) {
+			adapter->int_status &= ~HOST_INTR_DNLD_DONE;
+			if (adapter->data_sent) {
+				dev_dbg(adapter->dev, "info: DATA sent Interrupt\n");
+				adapter->data_sent = false;
+			}
+		}
+		if (adapter->int_status & HOST_INTR_UPLD_RDY) {
+			adapter->int_status &= ~HOST_INTR_UPLD_RDY;
+			dev_dbg(adapter->dev, "info: Rx DATA\n");
+			ret = mwifiex_pcie_process_recv_data(adapter);
+			if (ret)
+				return ret;
+		}
+		if (adapter->int_status & HOST_INTR_EVENT_RDY) {
+			adapter->int_status &= ~HOST_INTR_EVENT_RDY;
+			dev_dbg(adapter->dev, "info: Rx EVENT\n");
+			ret = mwifiex_pcie_process_event_ready(adapter);
+			if (ret)
+				return ret;
+		}
+
+		if (adapter->int_status & HOST_INTR_CMD_DONE) {
+			adapter->int_status &= ~HOST_INTR_CMD_DONE;
+			if (adapter->cmd_sent) {
+				dev_dbg(adapter->dev, "info: CMD sent Interrupt\n");
+				adapter->cmd_sent = false;
+			}
+			/* Handle command response */
+			ret = mwifiex_pcie_process_cmd_complete(adapter);
+			if (ret)
+				return ret;
+		}
+
+		if (mwifiex_pcie_ok_to_access_hw(adapter)) {
+			if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS,
+					     &pcie_ireg)) {
+				dev_warn(adapter->dev, "Read register failed\n");
+				return -1;
+			}
+
+			if ((pcie_ireg != 0xFFFFFFFF) && (pcie_ireg)) {
+				if (mwifiex_write_reg(adapter,
+					PCIE_HOST_INT_STATUS, ~pcie_ireg)) {
+					dev_warn(adapter->dev, "Write register"
+							       " failed\n");
+					return -1;
+				}
+				adapter->int_status |= pcie_ireg;
+				adapter->int_status &= HOST_INTR_MASK;
+			}
+
+		}
+	}
+	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
+	       adapter->cmd_sent, adapter->data_sent);
+	mwifiex_pcie_enable_host_int(adapter);
+
+	return 0;
+}
+
+/*
+ * This function downloads data from driver to card.
+ *
+ * Both commands and data packets are transferred to the card by this
+ * function.
+ *
+ * This function adds the PCIE specific header to the front of the buffer
+ * before transferring. The header contains the length of the packet and
+ * the type. The firmware handles the packets based upon this set type.
+ */
+static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
+				     struct sk_buff *skb,
+				     struct mwifiex_tx_param *tx_param)
+{
+	if (!adapter || !skb) {
+		dev_err(adapter->dev, "Invalid parameter in %s <%p, %p>\n",
+				__func__, adapter, skb);
+		return -1;
+	}
+
+	if (type == MWIFIEX_TYPE_DATA)
+		return mwifiex_pcie_send_data(adapter, skb);
+	else if (type == MWIFIEX_TYPE_CMD)
+		return mwifiex_pcie_send_cmd(adapter, skb);
+
+	return 0;
+}
+
+/*
+ * This function initializes the PCI-E host memory space, WCB rings, etc.
+ *
+ * The following initializations steps are followed -
+ *      - Allocate TXBD ring buffers
+ *      - Allocate RXBD ring buffers
+ *      - Allocate event BD ring buffers
+ *      - Allocate command response ring buffer
+ *      - Allocate sleep cookie buffer
+ */
+static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	int ret;
+	struct pci_dev *pdev = card->dev;
+
+	pci_set_drvdata(pdev, card);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto err_enable_dev;
+
+	pci_set_master(pdev);
+
+	dev_dbg(adapter->dev, "try set_consistent_dma_mask(32)\n");
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(adapter->dev, "set_dma_mask(32) failed\n");
+		goto err_set_dma_mask;
+	}
+
+	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(adapter->dev, "set_consistent_dma_mask(64) failed\n");
+		goto err_set_dma_mask;
+	}
+
+	ret = pci_request_region(pdev, 0, DRV_NAME);
+	if (ret) {
+		dev_err(adapter->dev, "req_reg(0) error\n");
+		goto err_req_region0;
+	}
+	card->pci_mmap = pci_iomap(pdev, 0, 0);
+	if (!card->pci_mmap) {
+		dev_err(adapter->dev, "iomap(0) error\n");
+		goto err_iomap0;
+	}
+	ret = pci_request_region(pdev, 2, DRV_NAME);
+	if (ret) {
+		dev_err(adapter->dev, "req_reg(2) error\n");
+		goto err_req_region2;
+	}
+	card->pci_mmap1 = pci_iomap(pdev, 2, 0);
+	if (!card->pci_mmap1) {
+		dev_err(adapter->dev, "iomap(2) error\n");
+		goto err_iomap2;
+	}
+
+	dev_dbg(adapter->dev, "PCI memory map Virt0: %p PCI memory map Virt2: "
+			      "%p\n", card->pci_mmap, card->pci_mmap1);
+
+	card->cmdrsp_buf = NULL;
+	ret = mwifiex_pcie_create_txbd_ring(adapter);
+	if (ret)
+		goto err_cre_txbd;
+	ret = mwifiex_pcie_create_rxbd_ring(adapter);
+	if (ret)
+		goto err_cre_rxbd;
+	ret = mwifiex_pcie_create_evtbd_ring(adapter);
+	if (ret)
+		goto err_cre_evtbd;
+	ret = mwifiex_pcie_alloc_cmdrsp_buf(adapter);
+	if (ret)
+		goto err_alloc_cmdbuf;
+	ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
+	if (ret)
+		goto err_alloc_cookie;
+
+	return ret;
+
+err_alloc_cookie:
+	mwifiex_pcie_delete_cmdrsp_buf(adapter);
+err_alloc_cmdbuf:
+	mwifiex_pcie_delete_evtbd_ring(adapter);
+err_cre_evtbd:
+	mwifiex_pcie_delete_rxbd_ring(adapter);
+err_cre_rxbd:
+	mwifiex_pcie_delete_txbd_ring(adapter);
+err_cre_txbd:
+	pci_iounmap(pdev, card->pci_mmap1);
+err_iomap2:
+	pci_release_region(pdev, 2);
+err_req_region2:
+	pci_iounmap(pdev, card->pci_mmap);
+err_iomap0:
+	pci_release_region(pdev, 0);
+err_req_region0:
+err_set_dma_mask:
+	pci_disable_device(pdev);
+err_enable_dev:
+	pci_set_drvdata(pdev, NULL);
+	return ret;
+}
+
+/*
+ * This function cleans up the allocated card buffers.
+ *
+ * The following are freed by this function -
+ *      - TXBD ring buffers
+ *      - RXBD ring buffers
+ *      - Event BD ring buffers
+ *      - Command response ring buffer
+ *      - Sleep cookie buffer
+ */
+static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct pci_dev *pdev = card->dev;
+
+	mwifiex_pcie_delete_sleep_cookie_buf(adapter);
+	mwifiex_pcie_delete_cmdrsp_buf(adapter);
+	mwifiex_pcie_delete_evtbd_ring(adapter);
+	mwifiex_pcie_delete_rxbd_ring(adapter);
+	mwifiex_pcie_delete_txbd_ring(adapter);
+	card->cmdrsp_buf = NULL;
+
+	dev_dbg(adapter->dev, "Clearing driver ready signature\n");
+	if (user_rmmod) {
+		if (mwifiex_write_reg(adapter, REG_DRV_READY, 0x00000000))
+			dev_err(adapter->dev, "Failed to write driver not-ready signature\n");
+	}
+
+	if (pdev) {
+		pci_iounmap(pdev, card->pci_mmap);
+		pci_iounmap(pdev, card->pci_mmap1);
+
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+		pci_set_drvdata(pdev, NULL);
+	}
+}
+
+/*
+ * This function registers the PCIE device.
+ *
+ * PCIE IRQ is claimed, block size is set and driver data is initialized.
+ */
+static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
+{
+	int ret;
+	struct pcie_service_card *card = adapter->card;
+	struct pci_dev *pdev = card->dev;
+
+	/* save adapter pointer in card */
+	card->adapter = adapter;
+
+	ret = request_irq(pdev->irq, mwifiex_pcie_interrupt, IRQF_SHARED,
+			  "MRVL_PCIE", pdev);
+	if (ret) {
+		pr_err("request_irq failed: ret=%d\n", ret);
+		adapter->card = NULL;
+		return -1;
+	}
+
+	adapter->dev = &pdev->dev;
+	strcpy(adapter->fw_name, PCIE8766_DEFAULT_FW_NAME);
+
+	return 0;
+}
+
+/*
+ * This function unregisters the PCIE device.
+ *
+ * The PCIE IRQ is released, the function is disabled and driver
+ * data is set to null.
+ */
+static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	if (card) {
+		dev_dbg(adapter->dev, "%s(): calling free_irq()\n", __func__);
+		free_irq(card->dev->irq, card->dev);
+	}
+}
+
+static struct mwifiex_if_ops pcie_ops = {
+	.init_if =			mwifiex_pcie_init,
+	.cleanup_if =			mwifiex_pcie_cleanup,
+	.check_fw_status =		mwifiex_check_fw_status,
+	.prog_fw =			mwifiex_prog_fw_w_helper,
+	.register_dev =			mwifiex_register_dev,
+	.unregister_dev =		mwifiex_unregister_dev,
+	.enable_int =			mwifiex_pcie_enable_host_int,
+	.process_int_status =		mwifiex_process_int_status,
+	.host_to_card =			mwifiex_pcie_host_to_card,
+	.wakeup =			mwifiex_pm_wakeup_card,
+	.wakeup_complete =		mwifiex_pm_wakeup_card_complete,
+
+	/* PCIE specific */
+	.cmdrsp_complete =		mwifiex_pcie_cmdrsp_complete,
+	.event_complete =		mwifiex_pcie_event_complete,
+	.update_mp_end_port =		NULL,
+	.cleanup_mpa_buf =		NULL,
+};
+
+/*
+ * This function initializes the PCIE driver module.
+ *
+ * This initiates the semaphore and registers the device with
+ * PCIE bus.
+ */
+static int mwifiex_pcie_init_module(void)
+{
+	int ret;
+
+	pr_debug("Marvell 8766 PCIe Driver\n");
+
+	sema_init(&add_remove_card_sem, 1);
+
+	/* Clear the flag in case user removes the card. */
+	user_rmmod = 0;
+
+	ret = pci_register_driver(&mwifiex_pcie);
+	if (ret)
+		pr_err("Driver register failed!\n");
+	else
+		pr_debug("info: Driver registered successfully!\n");
+
+	return ret;
+}
+
+/*
+ * This function cleans up the PCIE driver.
+ *
+ * The following major steps are followed for cleanup -
+ *      - Resume the device if its suspended
+ *      - Disconnect the device if connected
+ *      - Shutdown the firmware
+ *      - Unregister the device from PCIE bus.
+ */
+static void mwifiex_pcie_cleanup_module(void)
+{
+	if (!down_interruptible(&add_remove_card_sem))
+		up(&add_remove_card_sem);
+
+	/* Set the flag as user is removing this module. */
+	user_rmmod = 1;
+
+	pci_unregister_driver(&mwifiex_pcie);
+}
+
+module_init(mwifiex_pcie_init_module);
+module_exit(mwifiex_pcie_cleanup_module);
+
+MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_DESCRIPTION("Marvell WiFi-Ex PCI-Express Driver version " PCIE_VERSION);
+MODULE_VERSION(PCIE_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE("mrvl/pcie8766_uapsta.bin");
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
new file mode 100644
index 0000000..445ff21
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -0,0 +1,148 @@
+/* @file mwifiex_pcie.h
+ *
+ * @brief This file contains definitions for PCI-E interface.
+ * driver.
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef	_MWIFIEX_PCIE_H
+#define	_MWIFIEX_PCIE_H
+
+#include    <linux/pci.h>
+#include    <linux/pcieport_if.h>
+#include    <linux/interrupt.h>
+
+#include    "main.h"
+
+#define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
+
+/* Constants for Buffer Descriptor (BD) rings */
+#define MWIFIEX_MAX_TXRX_BD			0x20
+#define MWIFIEX_TXBD_MASK			0x3F
+#define MWIFIEX_RXBD_MASK			0x3F
+
+#define MWIFIEX_MAX_EVT_BD			0x04
+#define MWIFIEX_EVTBD_MASK			0x07
+
+/* PCIE INTERNAL REGISTERS */
+#define PCIE_SCRATCH_0_REG				0xC10
+#define PCIE_SCRATCH_1_REG				0xC14
+#define PCIE_CPU_INT_EVENT				0xC18
+#define PCIE_CPU_INT_STATUS				0xC1C
+#define PCIE_HOST_INT_STATUS				0xC30
+#define PCIE_HOST_INT_MASK				0xC34
+#define PCIE_HOST_INT_STATUS_MASK			0xC3C
+#define PCIE_SCRATCH_2_REG				0xC40
+#define PCIE_SCRATCH_3_REG				0xC44
+#define PCIE_SCRATCH_4_REG				0xCC0
+#define PCIE_SCRATCH_5_REG				0xCC4
+#define PCIE_SCRATCH_6_REG				0xCC8
+#define PCIE_SCRATCH_7_REG				0xCCC
+#define PCIE_SCRATCH_8_REG				0xCD0
+#define PCIE_SCRATCH_9_REG				0xCD4
+#define PCIE_SCRATCH_10_REG				0xCD8
+#define PCIE_SCRATCH_11_REG				0xCDC
+#define PCIE_SCRATCH_12_REG				0xCE0
+
+#define CPU_INTR_DNLD_RDY				BIT(0)
+#define CPU_INTR_DOOR_BELL				BIT(1)
+#define CPU_INTR_SLEEP_CFM_DONE			BIT(2)
+#define CPU_INTR_RESET					BIT(3)
+
+#define HOST_INTR_DNLD_DONE				BIT(0)
+#define HOST_INTR_UPLD_RDY				BIT(1)
+#define HOST_INTR_CMD_DONE				BIT(2)
+#define HOST_INTR_EVENT_RDY				BIT(3)
+#define HOST_INTR_MASK					(HOST_INTR_DNLD_DONE | \
+							 HOST_INTR_UPLD_RDY  | \
+							 HOST_INTR_CMD_DONE  | \
+							 HOST_INTR_EVENT_RDY)
+
+#define MWIFIEX_BD_FLAG_ROLLOVER_IND			BIT(7)
+#define MWIFIEX_BD_FLAG_FIRST_DESC			BIT(0)
+#define MWIFIEX_BD_FLAG_LAST_DESC			BIT(1)
+#define REG_CMD_ADDR_LO					PCIE_SCRATCH_0_REG
+#define REG_CMD_ADDR_HI					PCIE_SCRATCH_1_REG
+#define REG_CMD_SIZE					PCIE_SCRATCH_2_REG
+
+#define REG_CMDRSP_ADDR_LO				PCIE_SCRATCH_4_REG
+#define REG_CMDRSP_ADDR_HI				PCIE_SCRATCH_5_REG
+
+/* TX buffer description read pointer */
+#define REG_TXBD_RDPTR					PCIE_SCRATCH_6_REG
+/* TX buffer description write pointer */
+#define REG_TXBD_WRPTR					PCIE_SCRATCH_7_REG
+/* RX buffer description read pointer */
+#define REG_RXBD_RDPTR					PCIE_SCRATCH_8_REG
+/* RX buffer description write pointer */
+#define REG_RXBD_WRPTR					PCIE_SCRATCH_9_REG
+/* Event buffer description read pointer */
+#define REG_EVTBD_RDPTR					PCIE_SCRATCH_10_REG
+/* Event buffer description write pointer */
+#define REG_EVTBD_WRPTR					PCIE_SCRATCH_11_REG
+/* Driver ready signature write pointer */
+#define REG_DRV_READY					PCIE_SCRATCH_12_REG
+
+/* Max retry number of command write */
+#define MAX_WRITE_IOMEM_RETRY				2
+/* Define PCIE block size for firmware download */
+#define MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD		256
+/* FW awake cookie after FW ready */
+#define FW_AWAKE_COOKIE						(0xAA55AA55)
+
+struct mwifiex_pcie_buf_desc {
+	u64 paddr;
+	u16 len;
+	u16 flags;
+} __packed;
+
+struct pcie_service_card {
+	struct pci_dev *dev;
+	struct mwifiex_adapter *adapter;
+
+	u32 txbd_wrptr;
+	u32 txbd_rdptr;
+	u32 txbd_ring_size;
+	u8 *txbd_ring_vbase;
+	phys_addr_t txbd_ring_pbase;
+	struct mwifiex_pcie_buf_desc *txbd_ring[MWIFIEX_MAX_TXRX_BD];
+	struct sk_buff *tx_buf_list[MWIFIEX_MAX_TXRX_BD];
+
+	u32 rxbd_wrptr;
+	u32 rxbd_rdptr;
+	u32 rxbd_ring_size;
+	u8 *rxbd_ring_vbase;
+	phys_addr_t rxbd_ring_pbase;
+	struct mwifiex_pcie_buf_desc *rxbd_ring[MWIFIEX_MAX_TXRX_BD];
+	struct sk_buff *rx_buf_list[MWIFIEX_MAX_TXRX_BD];
+
+	u32 evtbd_wrptr;
+	u32 evtbd_rdptr;
+	u32 evtbd_ring_size;
+	u8 *evtbd_ring_vbase;
+	phys_addr_t evtbd_ring_pbase;
+	struct mwifiex_pcie_buf_desc *evtbd_ring[MWIFIEX_MAX_EVT_BD];
+	struct sk_buff *evt_buf_list[MWIFIEX_MAX_EVT_BD];
+
+	struct sk_buff *cmd_buf;
+	struct sk_buff *cmdrsp_buf;
+	struct sk_buff *sleep_cookie;
+	void __iomem *pci_mmap;
+	void __iomem *pci_mmap1;
+};
+
+#endif /* _MWIFIEX_PCIE_H */
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 82098ac..283171b 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -89,7 +89,8 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		return -EIO;
 	}
 
-	if (mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops)) {
+	if (mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops,
+			     MWIFIEX_SDIO)) {
 		pr_err("%s: add card failed\n", __func__);
 		kfree(card);
 		sdio_claim_host(func);
@@ -830,7 +831,7 @@ done:
  * The winner interface is also determined by this function.
  */
 static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
-				   u32 poll_num, int *winner)
+				   u32 poll_num)
 {
 	int ret = 0;
 	u16 firmware_stat;
@@ -842,7 +843,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
 		if (ret)
 			continue;
-		if (firmware_stat == FIRMWARE_READY) {
+		if (firmware_stat == FIRMWARE_READY_SDIO) {
 			ret = 0;
 			break;
 		} else {
@@ -851,15 +852,15 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 		}
 	}
 
-	if (winner && ret) {
+	if (ret) {
 		if (mwifiex_read_reg
 		    (adapter, CARD_FW_STATUS0_REG, &winner_status))
 			winner_status = 0;
 
 		if (winner_status)
-			*winner = 0;
+			adapter->winner = 0;
 		else
-			*winner = 1;
+			adapter->winner = 1;
 	}
 	return ret;
 }
@@ -1413,7 +1414,7 @@ tx_curr_single:
  * the type. The firmware handles the packets based upon this set type.
  */
 static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
-				     u8 type, u8 *payload, u32 pkt_len,
+				     u8 type, struct sk_buff *skb,
 				     struct mwifiex_tx_param *tx_param)
 {
 	struct sdio_mmc_card *card = adapter->card;
@@ -1421,6 +1422,8 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	u32 buf_block_len;
 	u32 blk_size;
 	u8 port = CTRL_PORT;
+	u8 *payload = (u8 *)skb->data;
+	u32 pkt_len = skb->len;
 
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
@@ -1722,6 +1725,8 @@ static struct mwifiex_if_ops sdio_ops = {
 	/* SDIO specific */
 	.update_mp_end_port = mwifiex_update_mp_end_port,
 	.cleanup_mpa_buf = mwifiex_cleanup_mpa_buf,
+	.cmdrsp_complete = mwifiex_sdio_cmdrsp_complete,
+	.event_complete = mwifiex_sdio_event_complete,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 524f78f..3f71180 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -169,9 +169,6 @@
 /* Rx unit register */
 #define CARD_RX_UNIT_REG		0x63
 
-/* Event header len w/o 4 bytes of interface header */
-#define MWIFIEX_EVENT_HEADER_LEN           4
-
 /* Max retry number of CMD53 write */
 #define MAX_WRITE_IOMEM_RETRY		2
 
@@ -304,4 +301,25 @@ struct sdio_mmc_card {
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
 };
+
+/*
+ * .cmdrsp_complete handler
+ */
+static inline int mwifiex_sdio_cmdrsp_complete(struct mwifiex_adapter *adapter,
+					       struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+	return 0;
+}
+
+/*
+ * .event_complete handler
+ */
+static inline int mwifiex_sdio_event_complete(struct mwifiex_adapter *adapter,
+					      struct sk_buff *skb)
+{
+	dev_kfree_skb_any(skb);
+	return 0;
+}
+
 #endif /* _MWIFIEX_SDIO_H */
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index c54ee28..ea6518d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -902,6 +902,59 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 }
 
 /*
+ * This function prepares command to set PCI-Express
+ * host buffer configuration
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting host buffer configuration
+ *      - Ensuring correct endian-ness
+ */
+static int
+mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd, u16 action)
+{
+	struct host_cmd_ds_pcie_details *host_spec =
+					&cmd->params.pcie_host_spec;
+	struct pcie_service_card *card = priv->adapter->card;
+	phys_addr_t *buf_pa;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_PCIE_DESC_DETAILS);
+	cmd->size = cpu_to_le16(sizeof(struct
+					host_cmd_ds_pcie_details) + S_DS_GEN);
+	cmd->result = 0;
+
+	memset(host_spec, 0, sizeof(struct host_cmd_ds_pcie_details));
+
+	if (action == HostCmd_ACT_GEN_SET) {
+		/* Send the ring base addresses and count to firmware */
+		host_spec->txbd_addr_lo = (u32)(card->txbd_ring_pbase);
+		host_spec->txbd_addr_hi =
+				(u32)(((u64)card->txbd_ring_pbase)>>32);
+		host_spec->txbd_count = MWIFIEX_MAX_TXRX_BD;
+		host_spec->rxbd_addr_lo = (u32)(card->rxbd_ring_pbase);
+		host_spec->rxbd_addr_hi =
+				(u32)(((u64)card->rxbd_ring_pbase)>>32);
+		host_spec->rxbd_count = MWIFIEX_MAX_TXRX_BD;
+		host_spec->evtbd_addr_lo =
+				(u32)(card->evtbd_ring_pbase);
+		host_spec->evtbd_addr_hi =
+				(u32)(((u64)card->evtbd_ring_pbase)>>32);
+		host_spec->evtbd_count = MWIFIEX_MAX_EVT_BD;
+		if (card->sleep_cookie) {
+			buf_pa = MWIFIEX_SKB_PACB(card->sleep_cookie);
+			host_spec->sleep_cookie_addr_lo = (u32) *buf_pa;
+			host_spec->sleep_cookie_addr_hi =
+						(u32) (((u64)*buf_pa) >> 32);
+			dev_dbg(priv->adapter->dev, "sleep_cook_lo phy addr: "
+				 "0x%x\n", host_spec->sleep_cookie_addr_lo);
+		}
+	}
+
+	return 0;
+}
+
+/*
  * This function prepares the commands before sending them to the firmware.
  *
  * This is a generic function which calls specific command preparation
@@ -1079,6 +1132,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 				host_cmd_ds_set_bss_mode) + S_DS_GEN);
 		ret = 0;
 		break;
+	case HostCmd_CMD_PCIE_DESC_DETAILS:
+		ret = mwifiex_cmd_pcie_host_spec(priv, cmd_ptr, cmd_action);
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
@@ -1095,6 +1151,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
  * working state.
  *
  * The following commands are issued sequentially -
+ *      - Set PCI-Express host buffer configuration (PCIE only)
  *      - Function init (for first interface only)
  *      - Read MAC address (for first interface only)
  *      - Reconfigure Tx buffer size (for first interface only)
@@ -1116,6 +1173,13 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	struct mwifiex_ds_11n_tx_cfg tx_cfg;
 
 	if (first_sta) {
+		if (priv->adapter->iface_type == MWIFIEX_PCIE) {
+			ret = mwifiex_send_cmd_async(priv,
+					HostCmd_CMD_PCIE_DESC_DETAILS,
+					HostCmd_ACT_GEN_SET, 0, NULL);
+			if (ret)
+				return -1;
+		}
 
 		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_FUNC_INIT,
 					     HostCmd_ACT_GEN_SET, 0, NULL);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 066f204..1382f69 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -952,6 +952,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_11N_CFG:
 		ret = mwifiex_ret_11n_cfg(resp, data_buf);
 		break;
+	case HostCmd_CMD_PCIE_DESC_DETAILS:
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 		       resp->command);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 1822bfa..d97facd 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -151,7 +151,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	skb_push(skb, INTF_HEADER_LEN);
 
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					     skb->data, skb->len, NULL);
+					   skb, NULL);
 	switch (ret) {
 	case -EBUSY:
 		adapter->data_sent = true;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 6190b2f..c3fe88a 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -78,7 +78,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 				(struct txpd *) (head_ptr + INTF_HEADER_LEN);
 
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					     skb->data, skb->len, tx_param);
+						   skb, tx_param);
 	}
 
 	switch (ret) {
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index 9506afc..f6d36b9 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -22,11 +22,16 @@
 
 static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
 {
-	return (struct mwifiex_rxinfo *)skb->cb;
+	return (struct mwifiex_rxinfo *)(skb->cb + sizeof(phys_addr_t));
 }
 
 static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
 {
-	return (struct mwifiex_txinfo *)skb->cb;
+	return (struct mwifiex_txinfo *)(skb->cb + sizeof(phys_addr_t));
+}
+
+static inline phys_addr_t *MWIFIEX_SKB_PACB(struct sk_buff *skb)
+{
+	return (phys_addr_t *)skb->cb;
 }
 #endif /* !_MWIFIEX_UTIL_H_ */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index eda2447..6c239c3 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1125,8 +1125,8 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	tx_param.next_pkt_len =
 		((skb_next) ? skb_next->len +
 		 sizeof(struct txpd) : 0);
-	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-					   skb->data, skb->len, &tx_param);
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA, skb,
+					   &tx_param);
 	switch (ret) {
 	case -EBUSY:
 		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
-- 
1.7.0.2

