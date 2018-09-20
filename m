Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40754 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732112AbeITMGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:06:41 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 17/29] staging: wilc1000: refactor code to avoid static variables for config parameters
Date: Thu, 20 Sep 2018 11:53:28 +0530
Message-ID: <1537424620-6982-18-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_085419_743562_F2A24F73)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code in wilc_wlan_cfg.c file to avoid the use of static
variables. Move the static variables as part of wilc struct and also
dynamically allocating memory for keeping those variables.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  12 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   2 +
 drivers/staging/wilc1000/wilc_wlan.c          |  12 +-
 drivers/staging/wilc1000/wilc_wlan.h          |   3 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c      | 159 +++++++++++++++++---------
 drivers/staging/wilc1000/wilc_wlan_cfg.h      |  20 +++-
 6 files changed, 138 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d9f927e..8ecd664 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -161,7 +161,7 @@ void wilc_mac_indicate(struct wilc *wilc)
 {
 	s8 status;
 
-	wilc_wlan_cfg_get_val(WID_STATUS, &status, 1);
+	wilc_wlan_cfg_get_val(wilc, WID_STATUS, &status, 1);
 	if (wilc->mac_status == MAC_STATUS_INIT) {
 		wilc->mac_status = status;
 		complete(&wilc->sync_event);
@@ -677,7 +677,7 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 			int size;
 			char firmware_ver[20];
 
-			size = wilc_wlan_cfg_get_val(WID_FIRMWARE_VERSION,
+			size = wilc_wlan_cfg_get_val(wl, WID_FIRMWARE_VERSION,
 						     firmware_ver,
 						     sizeof(firmware_ver));
 			firmware_ver[size] = '\0';
@@ -1035,6 +1035,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 
 	flush_workqueue(wilc->hif_workqueue);
 	destroy_workqueue(wilc->hif_workqueue);
+	wilc_wlan_cfg_deinit(wilc);
 	kfree(wilc);
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
@@ -1060,6 +1061,9 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	if (!wl)
 		return -ENOMEM;
 
+	if (wilc_wlan_cfg_init(wl))
+		goto free_wl;
+
 	*wilc = wl;
 	wl->io_type = io_type;
 	wl->hif_func = ops;
@@ -1070,7 +1074,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	wl->hif_workqueue = create_singlethread_workqueue("WILC_wq");
 	if (!wl->hif_workqueue)
-		goto free_wl;
+		goto free_cfg;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1139,6 +1143,8 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	}
 	unregister_inetaddr_notifier(&g_dev_notifier);
 	destroy_workqueue(wl->hif_workqueue);
+free_cfg:
+	wilc_wlan_cfg_deinit(wl);
 free_wl:
 	kfree(wl);
 	return -ENOMEM;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 70bae3a..484c265 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -16,6 +16,7 @@
 
 #include "host_interface.h"
 #include "wilc_wlan.h"
+#include "wilc_wlan_cfg.h"
 
 #define FLOW_CONTROL_LOWER_THRESHOLD		128
 #define FLOW_CONTROL_UPPER_THRESHOLD		256
@@ -203,6 +204,7 @@ struct wilc {
 	int clients_count;
 	struct workqueue_struct *hif_workqueue;
 	enum chip_ps_states chip_ps_state;
+	struct wilc_cfg cfg;
 };
 
 struct wilc_wfi_mon_priv {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 88808d9..0ec0d9b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1194,9 +1194,9 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 	return ret_size;
 }
 
-int wilc_wlan_cfg_get_val(u16 wid, u8 *buffer, u32 buffer_size)
+int wilc_wlan_cfg_get_val(struct wilc *wl, u16 wid, u8 *buffer, u32 buffer_size)
 {
-	return wilc_wlan_cfg_get_wid_value(wid, buffer, buffer_size);
+	return wilc_wlan_cfg_get_wid_value(wl, wid, buffer, buffer_size);
 }
 
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
@@ -1216,7 +1216,8 @@ int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			}
 		}
 		for (i = 0; i < count; i++) {
-			wids[i].size = wilc_wlan_cfg_get_val(wids[i].id,
+			wids[i].size = wilc_wlan_cfg_get_val(vif->wilc,
+							     wids[i].id,
 							     wids[i].val,
 							     wids[i].size);
 		}
@@ -1315,11 +1316,6 @@ int wilc_wlan_init(struct net_device *dev)
 		goto fail;
 	}
 
-	if (!wilc_wlan_cfg_init()) {
-		ret = -ENOBUFS;
-		goto fail;
-	}
-
 	if (!wilc->tx_buffer)
 		wilc->tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 8c49c0c..2766713 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -277,7 +277,8 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler);
-int wilc_wlan_cfg_get_val(u16 wid, u8 *buffer, u32 buffer_size);
+int wilc_wlan_cfg_get_val(struct wilc *wl, u16 wid, u8 *buffer,
+			  u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
 void wilc_chip_sleep_manually(struct wilc *wilc);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 4434976..8f1e962 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -8,6 +8,7 @@
 #include "wilc_wlan.h"
 #include "wilc_wlan_cfg.h"
 #include "coreconfigurator.h"
+#include "wilc_wfi_netdevice.h"
 
 enum cfg_cmd_type {
 	CFG_BYTE_CMD	= 0,
@@ -17,26 +18,18 @@ enum cfg_cmd_type {
 	CFG_BIN_CMD	= 4
 };
 
-struct wilc_mac_cfg {
-	u8 mac_address[7];
-	u8 firmware_version[129];
-	u8 assoc_rsp[256];
-};
-
-static struct wilc_mac_cfg g_mac;
-
-static struct wilc_cfg_byte g_cfg_byte[] = {
+static const struct wilc_cfg_byte g_cfg_byte[] = {
 	{WID_STATUS, 0},
 	{WID_RSSI, 0},
 	{WID_LINKSPEED, 0},
 	{WID_NIL, 0}
 };
 
-static struct wilc_cfg_hword g_cfg_hword[] = {
+static const struct wilc_cfg_hword g_cfg_hword[] = {
 	{WID_NIL, 0}
 };
 
-static struct wilc_cfg_word g_cfg_word[] = {
+static const struct wilc_cfg_word g_cfg_word[] = {
 	{WID_FAILED_COUNT, 0},
 	{WID_RECEIVED_FRAGMENT_COUNT, 0},
 	{WID_SUCCESS_FRAME_COUNT, 0},
@@ -45,10 +38,10 @@ static struct wilc_cfg_word g_cfg_word[] = {
 
 };
 
-static struct wilc_cfg_str g_cfg_str[] = {
-	{WID_FIRMWARE_VERSION, g_mac.firmware_version},
-	{WID_MAC_ADDR, g_mac.mac_address},
-	{WID_ASSOC_RES_INFO, g_mac.assoc_rsp},
+static const struct wilc_cfg_str g_cfg_str[] = {
+	{WID_FIRMWARE_VERSION, NULL},
+	{WID_MAC_ADDR, NULL},
+	{WID_ASSOC_RES_INFO, NULL},
 	{WID_NIL, NULL}
 };
 
@@ -169,7 +162,7 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
  ********************************************/
 
 #define GET_WID_TYPE(wid)		(((wid) >> 12) & 0x7)
-static void wilc_wlan_parse_response_frame(u8 *info, int size)
+static void wilc_wlan_parse_response_frame(struct wilc *wl, u8 *info, int size)
 {
 	u16 wid;
 	u32 len = 0, i = 0;
@@ -181,11 +174,11 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 		switch (GET_WID_TYPE(wid)) {
 		case WID_CHAR:
 			do {
-				if (g_cfg_byte[i].id == WID_NIL)
+				if (wl->cfg.b[i].id == WID_NIL)
 					break;
 
-				if (g_cfg_byte[i].id == wid) {
-					g_cfg_byte[i].val = info[4];
+				if (wl->cfg.b[i].id == wid) {
+					wl->cfg.b[i].val = info[4];
 					break;
 				}
 				i++;
@@ -195,12 +188,12 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 
 		case WID_SHORT:
 			do {
-				if (g_cfg_hword[i].id == WID_NIL)
+				if (wl->cfg.hw[i].id == WID_NIL)
 					break;
 
-				if (g_cfg_hword[i].id == wid) {
-					g_cfg_hword[i].val = (info[4] |
-							      (info[5] << 8));
+				if (wl->cfg.hw[i].id == wid) {
+					wl->cfg.hw[i].val = (info[4] |
+							     (info[5] << 8));
 					break;
 				}
 				i++;
@@ -210,14 +203,14 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 
 		case WID_INT:
 			do {
-				if (g_cfg_word[i].id == WID_NIL)
+				if (wl->cfg.w[i].id == WID_NIL)
 					break;
 
-				if (g_cfg_word[i].id == wid) {
-					g_cfg_word[i].val = (info[4] |
-							     (info[5] << 8) |
-							     (info[6] << 16) |
-							     (info[7] << 24));
+				if (wl->cfg.w[i].id == wid) {
+					wl->cfg.w[i].val = (info[4] |
+							    (info[5] << 8) |
+							    (info[6] << 16) |
+							    (info[7] << 24));
 					break;
 				}
 				i++;
@@ -227,11 +220,11 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 
 		case WID_STR:
 			do {
-				if (g_cfg_str[i].id == WID_NIL)
+				if (wl->cfg.s[i].id == WID_NIL)
 					break;
 
-				if (g_cfg_str[i].id == wid) {
-					memcpy(g_cfg_str[i].str, &info[2],
+				if (wl->cfg.s[i].id == wid) {
+					memcpy(wl->cfg.s[i].str, &info[2],
 					       (info[2] + 2));
 					break;
 				}
@@ -248,7 +241,7 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 	}
 }
 
-static void wilc_wlan_parse_info_frame(u8 *info)
+static void wilc_wlan_parse_info_frame(struct wilc *wl, u8 *info)
 {
 	u32 wid, len;
 
@@ -260,11 +253,11 @@ static void wilc_wlan_parse_info_frame(u8 *info)
 		int i = 0;
 
 		do {
-			if (g_cfg_byte[i].id == WID_NIL)
+			if (wl->cfg.b[i].id == WID_NIL)
 				break;
 
-			if (g_cfg_byte[i].id == wid) {
-				g_cfg_byte[i].val = info[3];
+			if (wl->cfg.b[i].id == wid) {
+				wl->cfg.b[i].val = info[3];
 				break;
 			}
 			i++;
@@ -328,7 +321,8 @@ int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
 	return 2;
 }
 
-int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
+int wilc_wlan_cfg_get_wid_value(struct wilc *wl, u16 wid, u8 *buffer,
+				u32 buffer_size)
 {
 	u32 type = (wid >> 12) & 0xf;
 	int i, ret = 0;
@@ -336,11 +330,11 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	i = 0;
 	if (type == CFG_BYTE_CMD) {
 		do {
-			if (g_cfg_byte[i].id == WID_NIL)
+			if (wl->cfg.b[i].id == WID_NIL)
 				break;
 
-			if (g_cfg_byte[i].id == wid) {
-				memcpy(buffer,  &g_cfg_byte[i].val, 1);
+			if (wl->cfg.b[i].id == wid) {
+				memcpy(buffer, &wl->cfg.b[i].val, 1);
 				ret = 1;
 				break;
 			}
@@ -348,11 +342,11 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 		} while (1);
 	} else if (type == CFG_HWORD_CMD) {
 		do {
-			if (g_cfg_hword[i].id == WID_NIL)
+			if (wl->cfg.hw[i].id == WID_NIL)
 				break;
 
-			if (g_cfg_hword[i].id == wid) {
-				memcpy(buffer,  &g_cfg_hword[i].val, 2);
+			if (wl->cfg.hw[i].id == wid) {
+				memcpy(buffer, &wl->cfg.hw[i].val, 2);
 				ret = 2;
 				break;
 			}
@@ -360,11 +354,11 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 		} while (1);
 	} else if (type == CFG_WORD_CMD) {
 		do {
-			if (g_cfg_word[i].id == WID_NIL)
+			if (wl->cfg.w[i].id == WID_NIL)
 				break;
 
-			if (g_cfg_word[i].id == wid) {
-				memcpy(buffer,  &g_cfg_word[i].val, 4);
+			if (wl->cfg.w[i].id == wid) {
+				memcpy(buffer, &wl->cfg.w[i].val, 4);
 				ret = 4;
 				break;
 			}
@@ -372,17 +366,17 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 		} while (1);
 	} else if (type == CFG_STR_CMD) {
 		do {
-			u32 id = g_cfg_str[i].id;
+			u32 id = wl->cfg.s[i].id;
 
 			if (id == WID_NIL)
 				break;
 
 			if (id == wid) {
-				u32 size = g_cfg_str[i].str[0] |
-						(g_cfg_str[i].str[1] << 8);
+				u32 size = (wl->cfg.s[i].str[0] |
+					    (wl->cfg.s[i].str[1] << 8));
 
 				if (buffer_size >= size) {
-					memcpy(buffer,  &g_cfg_str[i].str[2],
+					memcpy(buffer, &wl->cfg.s[i].str[2],
 					       size);
 					ret = size;
 				}
@@ -391,7 +385,6 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			i++;
 		} while (1);
 	}
-
 	return ret;
 }
 
@@ -416,13 +409,13 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 
 	switch (msg_type) {
 	case 'R':
-		wilc_wlan_parse_response_frame(frame, size);
+		wilc_wlan_parse_response_frame(wilc, frame, size);
 		rsp->type = WILC_CFG_RSP;
 		rsp->seq_no = msg_id;
 		break;
 
 	case 'I':
-		wilc_wlan_parse_info_frame(frame);
+		wilc_wlan_parse_info_frame(wilc, frame);
 		rsp->type = WILC_CFG_RSP_STATUS;
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
@@ -443,8 +436,62 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 	}
 }
 
-int wilc_wlan_cfg_init(void)
+int wilc_wlan_cfg_init(struct wilc *wl)
+{
+	struct wilc_mac_cfg *mac_cfg;
+	int i = 0;
+
+	wl->cfg.b = kmemdup(g_cfg_byte, sizeof(g_cfg_byte), GFP_KERNEL);
+	if (!wl->cfg.b)
+		return -ENOMEM;
+
+	wl->cfg.hw = kmemdup(g_cfg_hword, sizeof(g_cfg_hword), GFP_KERNEL);
+	if (!wl->cfg.hw)
+		goto out_b;
+
+	wl->cfg.w = kmemdup(g_cfg_word, sizeof(g_cfg_word), GFP_KERNEL);
+	if (!wl->cfg.w)
+		goto out_hw;
+
+	wl->cfg.s = kmemdup(g_cfg_str, sizeof(g_cfg_str), GFP_KERNEL);
+	if (!wl->cfg.s)
+		goto out_w;
+
+	mac_cfg = kzalloc(sizeof(mac_cfg), GFP_KERNEL);
+	if (!mac_cfg)
+		goto out_s;
+
+	wl->cfg.str_vals = mac_cfg;
+	/* store the string cfg parameters */
+	wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
+	wl->cfg.s[i].str = mac_cfg->firmware_version;
+	i++;
+	wl->cfg.s[i].id = WID_MAC_ADDR;
+	wl->cfg.s[i].str = mac_cfg->mac_address;
+	i++;
+	wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
+	wl->cfg.s[i].str = mac_cfg->assoc_rsp;
+	i++;
+	wl->cfg.s[i].id = WID_NIL;
+	wl->cfg.s[i].str = NULL;
+	return 0;
+
+out_s:
+	kfree(wl->cfg.s);
+out_w:
+	kfree(wl->cfg.w);
+out_hw:
+	kfree(wl->cfg.hw);
+out_b:
+	kfree(wl->cfg.b);
+	return -ENOMEM;
+}
+
+void wilc_wlan_cfg_deinit(struct wilc *wl)
 {
-	memset((void *)&g_mac, 0, sizeof(struct wilc_mac_cfg));
-	return 1;
+	kfree(wl->cfg.b);
+	kfree(wl->cfg.hw);
+	kfree(wl->cfg.w);
+	kfree(wl->cfg.s);
+	kfree(wl->cfg.str_vals);
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 082093f..176eef1 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -27,12 +27,28 @@ struct wilc_cfg_str {
 	u8 *str;
 };
 
+struct wilc_mac_cfg {
+	u8 mac_address[7];
+	u8 firmware_version[129];
+	u8 assoc_rsp[256];
+};
+
+struct wilc_cfg {
+	struct wilc_cfg_byte *b;
+	struct wilc_cfg_hword *hw;
+	struct wilc_cfg_word *w;
+	struct wilc_cfg_str *s;
+	struct wilc_mac_cfg *str_vals;
+};
+
 struct wilc;
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
-int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
+int wilc_wlan_cfg_get_wid_value(struct wilc *wl, u16 wid, u8 *buffer,
+				u32 buffer_size);
 void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 			       struct wilc_cfg_rsp *rsp);
-int wilc_wlan_cfg_init(void);
+int wilc_wlan_cfg_init(struct wilc *wl);
+void wilc_wlan_cfg_deinit(struct wilc *wl);
 
 #endif
-- 
2.7.4
