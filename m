Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2DJRfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:19 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 04/18] NFC: HCI support
Date: Tue, 10 Apr 2012 19:43:06 +0200
Message-Id: <1334079800-10671-5-git-send-email-sameo@linux.intel.com> (sfid-20120410_193524_824346_0F328BD6)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

This is an implementation of ETSI TS 102 622 specification.
Many NFC chipsets use HCI as the host <-> target protocol on top of a
serial link like i2c.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/hci.h |  198 ++++++++++++
 include/net/nfc/nfc.h |    1 +
 net/nfc/Kconfig       |    1 +
 net/nfc/Makefile      |    1 +
 net/nfc/hci/Kconfig   |    8 +
 net/nfc/hci/Makefile  |    7 +
 net/nfc/hci/command.c |  354 +++++++++++++++++++++
 net/nfc/hci/core.c    |  830 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/hci/hci.h     |  139 ++++++++
 net/nfc/hci/hcp.c     |  156 +++++++++
 10 files changed, 1695 insertions(+), 0 deletions(-)
 create mode 100644 include/net/nfc/hci.h
 create mode 100644 net/nfc/hci/Kconfig
 create mode 100644 net/nfc/hci/Makefile
 create mode 100644 net/nfc/hci/command.c
 create mode 100644 net/nfc/hci/core.c
 create mode 100644 net/nfc/hci/hci.h
 create mode 100644 net/nfc/hci/hcp.c

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
new file mode 100644
index 0000000..aca65a5
--- /dev/null
+++ b/include/net/nfc/hci.h
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2011  Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __NET_HCI_H
+#define __NET_HCI_H
+
+#include <linux/skbuff.h>
+
+#include <net/nfc/nfc.h>
+
+struct nfc_hci_dev;
+
+struct nfc_hci_ops {
+	int (*open) (struct nfc_hci_dev *hdev);
+	void (*close) (struct nfc_hci_dev *hdev);
+	int (*hci_ready) (struct nfc_hci_dev *hdev);
+	int (*xmit) (struct nfc_hci_dev *hdev, struct sk_buff *skb);
+	int (*start_poll) (struct nfc_hci_dev *hdev, u32 protocols);
+	int (*target_from_gate) (struct nfc_hci_dev *hdev, u8 gate,
+				 struct nfc_target *target);
+	int (*complete_target_discovered) (struct nfc_hci_dev *hdev, u8 gate,
+					   struct nfc_target *target);
+	int (*data_exchange) (struct nfc_hci_dev *hdev,
+			      struct nfc_target *target,
+			      struct sk_buff *skb, struct sk_buff **res_skb);
+};
+
+#define NFC_HCI_MAX_CUSTOM_GATES	15
+struct nfc_hci_init_data {
+	u8 gate_count;
+	u8 gates[NFC_HCI_MAX_CUSTOM_GATES];
+	char session_id[9];
+};
+
+typedef int (*xmit) (struct sk_buff *skb, void *cb_data);
+
+#define NFC_HCI_MAX_GATES		256
+
+struct nfc_hci_dev {
+	struct nfc_dev *ndev;
+
+	u32 max_data_link_payload;
+
+	struct mutex msg_tx_mutex;
+
+	struct list_head msg_tx_queue;
+
+	struct workqueue_struct *msg_tx_wq;
+	struct work_struct msg_tx_work;
+
+	struct timer_list cmd_timer;
+	struct hci_msg *cmd_pending_msg;
+
+	struct sk_buff_head rx_hcp_frags;
+
+	struct workqueue_struct *msg_rx_wq;
+	struct work_struct msg_rx_work;
+
+	struct sk_buff_head msg_rx_queue;
+
+	struct nfc_hci_ops *ops;
+
+	struct nfc_hci_init_data init_data;
+
+	void *clientdata;
+
+	u8 gate2pipe[NFC_HCI_MAX_GATES];
+
+	bool poll_started;
+	struct nfc_target *targets;
+	int target_count;
+
+	u8 sw_romlib;
+	u8 sw_patch;
+	u8 sw_flashlib_major;
+	u8 sw_flashlib_minor;
+
+	u8 hw_derivative;
+	u8 hw_version;
+	u8 hw_mpw;
+	u8 hw_software;
+	u8 hw_bsid;
+};
+
+/* hci device allocation */
+struct nfc_hci_dev *nfc_hci_allocate_device(struct nfc_hci_ops *ops,
+					    struct nfc_hci_init_data *init_data,
+					    u32 protocols,
+					    int tx_headroom,
+					    int tx_tailroom,
+					    int max_link_payload);
+void nfc_hci_free_device(struct nfc_hci_dev *hdev);
+
+int nfc_hci_register_device(struct nfc_hci_dev *hdev);
+void nfc_hci_unregister_device(struct nfc_hci_dev *hdev);
+
+void nfc_hci_set_clientdata(struct nfc_hci_dev *hdev, void *clientdata);
+void *nfc_hci_get_clientdata(struct nfc_hci_dev *hdev);
+
+/* Host IDs */
+#define NFC_HCI_HOST_CONTROLLER_ID	0x00
+#define NFC_HCI_TERMINAL_HOST_ID	0x01
+#define NFC_HCI_UICC_HOST_ID		0x02
+
+/* Host Controller Gates and registry indexes */
+#define NFC_HCI_ADMIN_GATE 0x00
+#define NFC_HCI_ADMIN_SESSION_IDENTITY	0x01
+#define NFC_HCI_ADMIN_MAX_PIPE		0x02
+#define NFC_HCI_ADMIN_WHITELIST		0x03
+#define NFC_HCI_ADMIN_HOST_LIST		0x04
+
+#define NFC_HCI_LOOPBACK_GATE		0x04
+
+#define NFC_HCI_ID_MGMT_GATE		0x05
+#define NFC_HCI_ID_MGMT_VERSION_SW	0x01
+#define NFC_HCI_ID_MGMT_VERSION_HW	0x03
+#define NFC_HCI_ID_MGMT_VENDOR_NAME	0x04
+#define NFC_HCI_ID_MGMT_MODEL_ID	0x05
+#define NFC_HCI_ID_MGMT_HCI_VERSION	0x02
+#define NFC_HCI_ID_MGMT_GATES_LIST	0x06
+
+#define NFC_HCI_LINK_MGMT_GATE		0x06
+#define NFC_HCI_LINK_MGMT_REC_ERROR	0x01
+
+#define NFC_HCI_RF_READER_B_GATE			0x11
+#define NFC_HCI_RF_READER_B_PUPI			0x03
+#define NFC_HCI_RF_READER_B_APPLICATION_DATA		0x04
+#define NFC_HCI_RF_READER_B_AFI				0x02
+#define NFC_HCI_RF_READER_B_HIGHER_LAYER_RESPONSE	0x01
+#define NFC_HCI_RF_READER_B_HIGHER_LAYER_DATA		0x05
+
+#define NFC_HCI_RF_READER_A_GATE		0x13
+#define NFC_HCI_RF_READER_A_UID			0x02
+#define NFC_HCI_RF_READER_A_ATQA		0x04
+#define NFC_HCI_RF_READER_A_APPLICATION_DATA	0x05
+#define NFC_HCI_RF_READER_A_SAK			0x03
+#define NFC_HCI_RF_READER_A_FWI_SFGT		0x06
+#define NFC_HCI_RF_READER_A_DATARATE_MAX	0x01
+
+#define NFC_HCI_TYPE_A_SEL_PROT(x)		(((x) & 0x60) >> 5)
+#define NFC_HCI_TYPE_A_SEL_PROT_MIFARE		0
+#define NFC_HCI_TYPE_A_SEL_PROT_ISO14443	1
+#define NFC_HCI_TYPE_A_SEL_PROT_DEP		2
+#define NFC_HCI_TYPE_A_SEL_PROT_ISO14443_DEP	3
+
+/* Generic events */
+#define NFC_HCI_EVT_HCI_END_OF_OPERATION	0x01
+#define NFC_HCI_EVT_POST_DATA			0x02
+#define NFC_HCI_EVT_HOT_PLUG			0x03
+
+/* Reader RF gates events */
+#define NFC_HCI_EVT_READER_REQUESTED	0x10
+#define NFC_HCI_EVT_END_OPERATION	0x11
+
+/* Reader Application gate events */
+#define NFC_HCI_EVT_TARGET_DISCOVERED	0x10
+
+/* receiving messages from lower layer */
+void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
+			   struct sk_buff *skb);
+void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
+			  struct sk_buff *skb);
+void nfc_hci_event_received(struct nfc_hci_dev *hdev, u8 pipe, u8 event,
+			    struct sk_buff *skb);
+void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb);
+
+/* connecting to gates and sending hci instructions */
+int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate);
+int nfc_hci_disconnect_gate(struct nfc_hci_dev *hdev, u8 gate);
+int nfc_hci_disconnect_all_gates(struct nfc_hci_dev *hdev);
+int nfc_hci_get_param(struct nfc_hci_dev *hdev, u8 gate, u8 idx,
+		      struct sk_buff **skb);
+int nfc_hci_set_param(struct nfc_hci_dev *hdev, u8 gate, u8 idx,
+		      const u8 *param, size_t param_len);
+int nfc_hci_send_cmd(struct nfc_hci_dev *hdev, u8 gate, u8 cmd,
+		     const u8 *param, size_t param_len, struct sk_buff **skb);
+int nfc_hci_send_response(struct nfc_hci_dev *hdev, u8 gate, u8 response,
+			  const u8 *param, size_t param_len);
+int nfc_hci_send_event(struct nfc_hci_dev *hdev, u8 gate, u8 event,
+		       const u8 *param, size_t param_len);
+
+#endif /* __NET_HCI_H */
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 57ea095..431a6c5 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -78,6 +78,7 @@ struct nfc_target {
 	u8 sensb_res[NFC_SENSB_RES_MAXSIZE];
 	u8 sensf_res_len;
 	u8 sensf_res[NFC_SENSF_RES_MAXSIZE];
+	u8 hci_reader_gate;
 };
 
 struct nfc_genl_data {
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 44c865b..8d8d9bc 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -14,6 +14,7 @@ menuconfig NFC
 	  be called nfc.
 
 source "net/nfc/nci/Kconfig"
+source "net/nfc/hci/Kconfig"
 source "net/nfc/llcp/Kconfig"
 
 source "drivers/nfc/Kconfig"
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index 7b4a6dc..d1a117c 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_NFC) += nfc.o
 obj-$(CONFIG_NFC_NCI) += nci/
+obj-$(CONFIG_NFC_HCI) += hci/
 
 nfc-objs := core.o netlink.o af_nfc.o rawsock.o
 nfc-$(CONFIG_NFC_LLCP)	+= llcp/llcp.o llcp/commands.o llcp/sock.o
diff --git a/net/nfc/hci/Kconfig b/net/nfc/hci/Kconfig
new file mode 100644
index 0000000..c32d2d4
--- /dev/null
+++ b/net/nfc/hci/Kconfig
@@ -0,0 +1,8 @@
+config NFC_HCI
+       depends on NFC
+       tristate "NFC HCI implementation"
+       default n
+       help
+	 Say Y here if you want to build support for a kernel NFC HCI
+	 implementation. This is mostly needed for devices that only process
+	 HCI frames, like for example the NXP pn544.
diff --git a/net/nfc/hci/Makefile b/net/nfc/hci/Makefile
new file mode 100644
index 0000000..af17c7b
--- /dev/null
+++ b/net/nfc/hci/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux NFC HCI layer.
+#
+
+obj-$(CONFIG_NFC_HCI) += hci.o
+
+hci-y			:= core.o hcp.o command.o
diff --git a/net/nfc/hci/command.c b/net/nfc/hci/command.c
new file mode 100644
index 0000000..8729abf
--- /dev/null
+++ b/net/nfc/hci/command.c
@@ -0,0 +1,354 @@
+/*
+ * Copyright (C) 2012  Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#define pr_fmt(fmt) "hci: %s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+#include <net/nfc/hci.h>
+
+#include "hci.h"
+
+static int nfc_hci_result_to_errno(u8 result)
+{
+	switch (result) {
+	case NFC_HCI_ANY_OK:
+		return 0;
+	case NFC_HCI_ANY_E_TIMEOUT:
+		return -ETIMEDOUT;
+	default:
+		return -1;
+	}
+}
+
+static void nfc_hci_execute_cb(struct nfc_hci_dev *hdev, u8 result,
+			       struct sk_buff *skb, void *cb_data)
+{
+	struct hcp_exec_waiter *hcp_ew = (struct hcp_exec_waiter *)cb_data;
+
+	pr_debug("HCI Cmd completed with HCI result=%d\n", result);
+
+	hcp_ew->exec_result = nfc_hci_result_to_errno(result);
+	if (hcp_ew->exec_result == 0)
+		hcp_ew->result_skb = skb;
+	else
+		kfree_skb(skb);
+	hcp_ew->exec_complete = true;
+
+	wake_up(hcp_ew->wq);
+}
+
+static int nfc_hci_execute_cmd(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
+			       const u8 *param, size_t param_len,
+			       struct sk_buff **skb)
+{
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(ew_wq);
+	struct hcp_exec_waiter hcp_ew;
+	hcp_ew.wq = &ew_wq;
+	hcp_ew.exec_complete = false;
+	hcp_ew.result_skb = NULL;
+
+	pr_debug("through pipe=%d, cmd=%d, plen=%zd\n", pipe, cmd, param_len);
+
+	/* TODO: Define hci cmd execution delay. Should it be the same
+	 * for all commands?
+	 */
+	hcp_ew.exec_result = nfc_hci_hcp_message_tx(hdev, pipe,
+						    NFC_HCI_HCP_COMMAND, cmd,
+						    param, param_len,
+						    nfc_hci_execute_cb, &hcp_ew,
+						    3000);
+	if (hcp_ew.exec_result < 0)
+		return hcp_ew.exec_result;
+
+	wait_event(ew_wq, hcp_ew.exec_complete == true);
+
+	if (hcp_ew.exec_result == 0) {
+		if (skb)
+			*skb = hcp_ew.result_skb;
+		else
+			kfree_skb(hcp_ew.result_skb);
+	}
+
+	return hcp_ew.exec_result;
+}
+
+int nfc_hci_send_event(struct nfc_hci_dev *hdev, u8 gate, u8 event,
+		       const u8 *param, size_t param_len)
+{
+	u8 pipe;
+
+	pr_debug("%d to gate %d\n", event, gate);
+
+	pipe = hdev->gate2pipe[gate];
+	if (pipe == NFC_HCI_INVALID_PIPE)
+		return -EADDRNOTAVAIL;
+
+	return nfc_hci_hcp_message_tx(hdev, pipe, NFC_HCI_HCP_EVENT, event,
+				      param, param_len, NULL, NULL, 0);
+}
+EXPORT_SYMBOL(nfc_hci_send_event);
+
+int nfc_hci_send_response(struct nfc_hci_dev *hdev, u8 gate, u8 response,
+			  const u8 *param, size_t param_len)
+{
+	u8 pipe;
+
+	pr_debug("\n");
+
+	pipe = hdev->gate2pipe[gate];
+	if (pipe == NFC_HCI_INVALID_PIPE)
+		return -EADDRNOTAVAIL;
+
+	return nfc_hci_hcp_message_tx(hdev, pipe, NFC_HCI_HCP_RESPONSE,
+				      response, param, param_len, NULL, NULL,
+				      0);
+}
+EXPORT_SYMBOL(nfc_hci_send_response);
+
+/*
+ * Execute an hci command sent to gate.
+ * skb will contain response data if success. skb can be NULL if you are not
+ * interested by the response.
+ */
+int nfc_hci_send_cmd(struct nfc_hci_dev *hdev, u8 gate, u8 cmd,
+		     const u8 *param, size_t param_len, struct sk_buff **skb)
+{
+	u8 pipe;
+
+	pr_debug("\n");
+
+	pipe = hdev->gate2pipe[gate];
+	if (pipe == NFC_HCI_INVALID_PIPE)
+		return -EADDRNOTAVAIL;
+
+	return nfc_hci_execute_cmd(hdev, pipe, cmd, param, param_len, skb);
+}
+EXPORT_SYMBOL(nfc_hci_send_cmd);
+
+int nfc_hci_set_param(struct nfc_hci_dev *hdev, u8 gate, u8 idx,
+		      const u8 *param, size_t param_len)
+{
+	int r;
+	u8 *tmp;
+
+	/* TODO ELa: reg idx must be inserted before param, but we don't want
+	 * to ask the caller to do it to keep a simpler API.
+	 * For now, just create a new temporary param buffer. This is far from
+	 * optimal though, and the plan is to modify APIs to pass idx down to
+	 * nfc_hci_hcp_message_tx where the frame is actually built, thereby
+	 * eliminating the need for the temp allocation-copy here.
+	 */
+
+	pr_debug("idx=%d to gate %d\n", idx, gate);
+
+	tmp = kmalloc(1 + param_len, GFP_KERNEL);
+	if (tmp == NULL)
+		return -ENOMEM;
+
+	*tmp = idx;
+	memcpy(tmp + 1, param, param_len);
+
+	r = nfc_hci_send_cmd(hdev, gate, NFC_HCI_ANY_SET_PARAMETER,
+			     tmp, param_len + 1, NULL);
+
+	kfree(tmp);
+
+	return r;
+}
+EXPORT_SYMBOL(nfc_hci_set_param);
+
+int nfc_hci_get_param(struct nfc_hci_dev *hdev, u8 gate, u8 idx,
+		      struct sk_buff **skb)
+{
+	pr_debug("gate=%d regidx=%d\n", gate, idx);
+
+	return nfc_hci_send_cmd(hdev, gate, NFC_HCI_ANY_GET_PARAMETER,
+				&idx, 1, skb);
+}
+EXPORT_SYMBOL(nfc_hci_get_param);
+
+static int nfc_hci_open_pipe(struct nfc_hci_dev *hdev, u8 pipe)
+{
+	struct sk_buff *skb;
+	int r;
+
+	pr_debug("pipe=%d\n", pipe);
+
+	r = nfc_hci_execute_cmd(hdev, pipe, NFC_HCI_ANY_OPEN_PIPE,
+				NULL, 0, &skb);
+	if (r == 0) {
+		/* dest host other than host controller will send
+		 * number of pipes already open on this gate before
+		 * execution. The number can be found in skb->data[0]
+		 */
+		kfree_skb(skb);
+	}
+
+	return r;
+}
+
+static int nfc_hci_close_pipe(struct nfc_hci_dev *hdev, u8 pipe)
+{
+	pr_debug("\n");
+
+	return nfc_hci_execute_cmd(hdev, pipe, NFC_HCI_ANY_CLOSE_PIPE,
+				   NULL, 0, NULL);
+}
+
+static u8 nfc_hci_create_pipe(struct nfc_hci_dev *hdev, u8 dest_host,
+			      u8 dest_gate, int *result)
+{
+	struct sk_buff *skb;
+	struct hci_create_pipe_params params;
+	struct hci_create_pipe_resp *resp;
+	u8 pipe;
+
+	pr_debug("gate=%d\n", dest_gate);
+
+	params.src_gate = NFC_HCI_ADMIN_GATE;
+	params.dest_host = dest_host;
+	params.dest_gate = dest_gate;
+
+	*result = nfc_hci_execute_cmd(hdev, NFC_HCI_ADMIN_PIPE,
+				      NFC_HCI_ADM_CREATE_PIPE,
+				      (u8 *) &params, sizeof(params), &skb);
+	if (*result == 0) {
+		resp = (struct hci_create_pipe_resp *)skb->data;
+		pipe = resp->pipe;
+		kfree_skb(skb);
+
+		pr_debug("pipe created=%d\n", pipe);
+
+		return pipe;
+	} else
+		return NFC_HCI_INVALID_PIPE;
+}
+
+static int nfc_hci_delete_pipe(struct nfc_hci_dev *hdev, u8 pipe)
+{
+	pr_debug("\n");
+
+	return nfc_hci_execute_cmd(hdev, NFC_HCI_ADMIN_PIPE,
+				   NFC_HCI_ADM_DELETE_PIPE, &pipe, 1, NULL);
+}
+
+static int nfc_hci_clear_all_pipes(struct nfc_hci_dev *hdev)
+{
+	int r;
+
+	u8 param[2];
+
+	/* TODO: Find out what the identity reference data is
+	 * and fill param with it. HCI spec 6.1.3.5 */
+
+	pr_debug("\n");
+
+	r = nfc_hci_execute_cmd(hdev, NFC_HCI_ADMIN_PIPE,
+				NFC_HCI_ADM_CLEAR_ALL_PIPE, param, 2, NULL);
+
+	return 0;
+}
+
+int nfc_hci_disconnect_gate(struct nfc_hci_dev *hdev, u8 gate)
+{
+	int r;
+	u8 pipe = hdev->gate2pipe[gate];
+
+	pr_debug("\n");
+
+	if (pipe == NFC_HCI_INVALID_PIPE)
+		return -EADDRNOTAVAIL;
+
+	r = nfc_hci_close_pipe(hdev, pipe);
+	if (r < 0)
+		return r;
+
+	if (pipe != NFC_HCI_LINK_MGMT_PIPE && pipe != NFC_HCI_ADMIN_PIPE) {
+		r = nfc_hci_delete_pipe(hdev, pipe);
+		if (r < 0)
+			return r;
+	}
+
+	hdev->gate2pipe[gate] = NFC_HCI_INVALID_PIPE;
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_hci_disconnect_gate);
+
+int nfc_hci_disconnect_all_gates(struct nfc_hci_dev *hdev)
+{
+	int r;
+
+	pr_debug("\n");
+
+	r = nfc_hci_clear_all_pipes(hdev);
+	if (r < 0)
+		return r;
+
+	memset(hdev->gate2pipe, NFC_HCI_INVALID_PIPE, sizeof(hdev->gate2pipe));
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_hci_disconnect_all_gates);
+
+int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate)
+{
+	u8 pipe = NFC_HCI_INVALID_PIPE;
+	bool pipe_created = false;
+	int r;
+
+	pr_debug("\n");
+
+	if (hdev->gate2pipe[dest_gate] != NFC_HCI_INVALID_PIPE)
+		return -EADDRINUSE;
+
+	switch (dest_gate) {
+	case NFC_HCI_LINK_MGMT_GATE:
+		pipe = NFC_HCI_LINK_MGMT_PIPE;
+		break;
+	case NFC_HCI_ADMIN_GATE:
+		pipe = NFC_HCI_ADMIN_PIPE;
+		break;
+	default:
+		pipe = nfc_hci_create_pipe(hdev, dest_host, dest_gate, &r);
+		if (pipe == NFC_HCI_INVALID_PIPE)
+			return r;
+		pipe_created = true;
+		break;
+	}
+
+	r = nfc_hci_open_pipe(hdev, pipe);
+	if (r < 0) {
+		if (pipe_created)
+			if (nfc_hci_delete_pipe(hdev, pipe) < 0) {
+				/* TODO: Cannot clean by deleting pipe...
+				 * -> inconsistent state */
+			}
+		return r;
+	}
+
+	hdev->gate2pipe[dest_gate] = pipe;
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_hci_connect_gate);
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
new file mode 100644
index 0000000..86fd00d
--- /dev/null
+++ b/net/nfc/hci/core.c
@@ -0,0 +1,830 @@
+/*
+ * Copyright (C) 2012  Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#define pr_fmt(fmt) "hci: %s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nfc.h>
+
+#include <net/nfc/nfc.h>
+#include <net/nfc/hci.h>
+
+#include "hci.h"
+
+/* Largest headroom needed for outgoing HCI commands */
+#define HCI_CMDS_HEADROOM 1
+
+static void nfc_hci_msg_tx_work(struct work_struct *work)
+{
+	struct nfc_hci_dev *hdev = container_of(work, struct nfc_hci_dev,
+						msg_tx_work);
+	struct hci_msg *msg;
+	struct sk_buff *skb;
+	int r = 0;
+
+	mutex_lock(&hdev->msg_tx_mutex);
+
+	if (hdev->cmd_pending_msg) {
+		if (timer_pending(&hdev->cmd_timer) == 0) {
+			if (hdev->cmd_pending_msg->cb)
+				hdev->cmd_pending_msg->cb(hdev,
+							  NFC_HCI_ANY_E_TIMEOUT,
+							  NULL,
+							  hdev->
+							  cmd_pending_msg->
+							  cb_context);
+			kfree(hdev->cmd_pending_msg);
+			hdev->cmd_pending_msg = NULL;
+		} else
+			goto exit;
+	}
+
+next_msg:
+	if (list_empty(&hdev->msg_tx_queue))
+		goto exit;
+
+	msg = list_first_entry(&hdev->msg_tx_queue, struct hci_msg, msg_l);
+	list_del(&msg->msg_l);
+
+	pr_debug("msg_tx_queue has a cmd to send\n");
+	while ((skb = skb_dequeue(&msg->msg_frags)) != NULL) {
+		r = hdev->ops->xmit(hdev, skb);
+		if (r < 0) {
+			kfree_skb(skb);
+			skb_queue_purge(&msg->msg_frags);
+			if (msg->cb)
+				msg->cb(hdev, NFC_HCI_ANY_E_NOK, NULL,
+					msg->cb_context);
+			kfree(msg);
+			break;
+		}
+	}
+
+	if (r)
+		goto next_msg;
+
+	if (msg->wait_response == false) {
+		kfree(msg);
+		goto next_msg;
+	}
+
+	hdev->cmd_pending_msg = msg;
+	mod_timer(&hdev->cmd_timer, jiffies +
+		  msecs_to_jiffies(hdev->cmd_pending_msg->completion_delay));
+
+exit:
+	mutex_unlock(&hdev->msg_tx_mutex);
+}
+
+static void nfc_hci_msg_rx_work(struct work_struct *work)
+{
+	struct nfc_hci_dev *hdev = container_of(work, struct nfc_hci_dev,
+						msg_rx_work);
+	struct sk_buff *skb;
+	struct hcp_message *message;
+	u8 pipe;
+	u8 type;
+	u8 instruction;
+
+	while ((skb = skb_dequeue(&hdev->msg_rx_queue)) != NULL) {
+		pipe = skb->data[0];
+		skb_pull(skb, NFC_HCI_HCP_PACKET_HEADER_LEN);
+		message = (struct hcp_message *)skb->data;
+		type = HCP_MSG_GET_TYPE(message->header);
+		instruction = HCP_MSG_GET_CMD(message->header);
+		skb_pull(skb, NFC_HCI_HCP_MESSAGE_HEADER_LEN);
+
+		nfc_hci_hcp_message_rx(hdev, pipe, type, instruction, skb);
+	}
+}
+
+void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
+			   struct sk_buff *skb)
+{
+	mutex_lock(&hdev->msg_tx_mutex);
+
+	if (hdev->cmd_pending_msg == NULL) {
+		kfree_skb(skb);
+		goto exit;
+	}
+
+	del_timer_sync(&hdev->cmd_timer);
+
+	if (hdev->cmd_pending_msg->cb)
+		hdev->cmd_pending_msg->cb(hdev, result, skb,
+					  hdev->cmd_pending_msg->cb_context);
+	else
+		kfree_skb(skb);
+
+	kfree(hdev->cmd_pending_msg);
+	hdev->cmd_pending_msg = NULL;
+
+	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+
+exit:
+	mutex_unlock(&hdev->msg_tx_mutex);
+}
+
+void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
+			  struct sk_buff *skb)
+{
+	kfree_skb(skb);
+}
+
+static u32 nfc_hci_sak_to_protocol(u8 sak)
+{
+	switch (NFC_HCI_TYPE_A_SEL_PROT(sak)) {
+	case NFC_HCI_TYPE_A_SEL_PROT_MIFARE:
+		return NFC_PROTO_MIFARE_MASK;
+	case NFC_HCI_TYPE_A_SEL_PROT_ISO14443:
+		return NFC_PROTO_ISO14443_MASK;
+	case NFC_HCI_TYPE_A_SEL_PROT_DEP:
+		return NFC_PROTO_NFC_DEP_MASK;
+	case NFC_HCI_TYPE_A_SEL_PROT_ISO14443_DEP:
+		return NFC_PROTO_ISO14443_MASK | NFC_PROTO_NFC_DEP_MASK;
+	default:
+		return 0xffffffff;
+	}
+}
+
+static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
+{
+	struct nfc_target *targets;
+	struct sk_buff *atqa_skb = NULL;
+	struct sk_buff *sak_skb = NULL;
+	int r;
+
+	pr_debug("from gate %d\n", gate);
+
+	targets = kzalloc(sizeof(struct nfc_target), GFP_KERNEL);
+	if (targets == NULL)
+		return -ENOMEM;
+
+	switch (gate) {
+	case NFC_HCI_RF_READER_A_GATE:
+		r = nfc_hci_get_param(hdev, NFC_HCI_RF_READER_A_GATE,
+				      NFC_HCI_RF_READER_A_ATQA, &atqa_skb);
+		if (r < 0)
+			goto exit;
+
+		r = nfc_hci_get_param(hdev, NFC_HCI_RF_READER_A_GATE,
+				      NFC_HCI_RF_READER_A_SAK, &sak_skb);
+		if (r < 0)
+			goto exit;
+
+		if (atqa_skb->len != 2 || sak_skb->len != 1) {
+			r = -EPROTO;
+			goto exit;
+		}
+
+		targets->supported_protocols =
+				nfc_hci_sak_to_protocol(sak_skb->data[0]);
+		if (targets->supported_protocols == 0xffffffff) {
+			r = -EPROTO;
+			goto exit;
+		}
+
+		targets->sens_res = be16_to_cpu(*(u16 *)atqa_skb->data);
+		targets->sel_res = sak_skb->data[0];
+
+		if (hdev->ops->complete_target_discovered) {
+			r = hdev->ops->complete_target_discovered(hdev, gate,
+								  targets);
+			if (r < 0)
+				goto exit;
+		}
+		break;
+	case NFC_HCI_RF_READER_B_GATE:
+		targets->supported_protocols = NFC_PROTO_ISO14443_MASK;
+		break;
+	default:
+		if (hdev->ops->target_from_gate)
+			r = hdev->ops->target_from_gate(hdev, gate, targets);
+		else
+			r = -EPROTO;
+		if (r < 0)
+			goto exit;
+
+		if (hdev->ops->complete_target_discovered) {
+			r = hdev->ops->complete_target_discovered(hdev, gate,
+								  targets);
+			if (r < 0)
+				goto exit;
+		}
+		break;
+	}
+
+	targets->hci_reader_gate = gate;
+
+	r = nfc_targets_found(hdev->ndev, targets, 1);
+	if (r < 0)
+		goto exit;
+
+	kfree(hdev->targets);
+	hdev->targets = targets;
+	targets = NULL;
+	hdev->target_count = 1;
+
+exit:
+	kfree(targets);
+	kfree_skb(atqa_skb);
+	kfree_skb(sak_skb);
+
+	return r;
+}
+
+void nfc_hci_event_received(struct nfc_hci_dev *hdev, u8 pipe, u8 event,
+			    struct sk_buff *skb)
+{
+	int r = 0;
+
+	switch (event) {
+	case NFC_HCI_EVT_TARGET_DISCOVERED:
+		if (hdev->poll_started == false) {
+			r = -EPROTO;
+			goto exit;
+		}
+
+		if (skb->len < 1) {	/* no status data? */
+			r = -EPROTO;
+			goto exit;
+		}
+
+		if (skb->data[0] == 3) {
+			/* TODO: Multiple targets in field, none activated
+			 * poll is supposedly stopped, but there is no
+			 * single target to activate, so nothing to report
+			 * up.
+			 * if we need to restart poll, we must save the
+			 * protocols from the initial poll and reuse here.
+			 */
+		}
+
+		if (skb->data[0] != 0) {
+			r = -EPROTO;
+			goto exit;
+		}
+
+		r = nfc_hci_target_discovered(hdev,
+					      nfc_hci_pipe2gate(hdev, pipe));
+		break;
+	default:
+		/* TODO: Unknown events are hardware specific
+		 * pass them to the driver (needs a new hci_ops) */
+		break;
+	}
+
+exit:
+	kfree_skb(skb);
+
+	if (r) {
+		/* TODO: There was an error dispatching the event,
+		 * how to propagate up to nfc core?
+		 */
+	}
+}
+
+static void nfc_hci_cmd_timeout(unsigned long data)
+{
+	struct nfc_hci_dev *hdev = (struct nfc_hci_dev *)data;
+
+	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+}
+
+static int hci_dev_connect_gates(struct nfc_hci_dev *hdev, u8 gate_count,
+				 u8 gates[])
+{
+	int r;
+	u8 *p = gates;
+	while (gate_count--) {
+		r = nfc_hci_connect_gate(hdev, NFC_HCI_HOST_CONTROLLER_ID, *p);
+		if (r < 0)
+			return r;
+		p++;
+	}
+
+	return 0;
+}
+
+static int hci_dev_session_init(struct nfc_hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+	int r;
+	u8 hci_gates[] = {	/* NFC_HCI_ADMIN_GATE MUST be first */
+		NFC_HCI_ADMIN_GATE, NFC_HCI_LOOPBACK_GATE,
+		NFC_HCI_ID_MGMT_GATE, NFC_HCI_LINK_MGMT_GATE,
+		NFC_HCI_RF_READER_B_GATE, NFC_HCI_RF_READER_A_GATE
+	};
+
+	r = nfc_hci_connect_gate(hdev, NFC_HCI_HOST_CONTROLLER_ID,
+				 NFC_HCI_ADMIN_GATE);
+	if (r < 0)
+		goto exit;
+
+	r = nfc_hci_get_param(hdev, NFC_HCI_ADMIN_GATE,
+			      NFC_HCI_ADMIN_SESSION_IDENTITY, &skb);
+	if (r < 0)
+		goto disconnect_all;
+
+	if (skb->len && skb->len == strlen(hdev->init_data.session_id))
+		if (memcmp(hdev->init_data.session_id, skb->data,
+			   skb->len) == 0) {
+			/* TODO ELa: restore gate<->pipe table from
+			 * some TBD location.
+			 * note: it doesn't seem possible to get the chip
+			 * currently open gate/pipe table.
+			 * It is only possible to obtain the supported
+			 * gate list.
+			 */
+
+			/* goto exit
+			 * For now, always do a full initialization */
+		}
+
+	r = nfc_hci_disconnect_all_gates(hdev);
+	if (r < 0)
+		goto exit;
+
+	r = hci_dev_connect_gates(hdev, sizeof(hci_gates), hci_gates);
+	if (r < 0)
+		goto disconnect_all;
+
+	r = hci_dev_connect_gates(hdev, hdev->init_data.gate_count,
+				  hdev->init_data.gates);
+	if (r < 0)
+		goto disconnect_all;
+
+	r = nfc_hci_set_param(hdev, NFC_HCI_ADMIN_GATE,
+			      NFC_HCI_ADMIN_SESSION_IDENTITY,
+			      hdev->init_data.session_id,
+			      strlen(hdev->init_data.session_id));
+	if (r == 0)
+		goto exit;
+
+disconnect_all:
+	nfc_hci_disconnect_all_gates(hdev);
+
+exit:
+	if (skb)
+		kfree_skb(skb);
+
+	return r;
+}
+
+static int hci_dev_version(struct nfc_hci_dev *hdev)
+{
+	int r;
+	struct sk_buff *skb;
+
+	r = nfc_hci_get_param(hdev, NFC_HCI_ID_MGMT_GATE,
+			      NFC_HCI_ID_MGMT_VERSION_SW, &skb);
+	if (r < 0)
+		return r;
+
+	if (skb->len != 3) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	hdev->sw_romlib = (skb->data[0] & 0xf0) >> 4;
+	hdev->sw_patch = skb->data[0] & 0x0f;
+	hdev->sw_flashlib_major = skb->data[1];
+	hdev->sw_flashlib_minor = skb->data[2];
+
+	kfree_skb(skb);
+
+	r = nfc_hci_get_param(hdev, NFC_HCI_ID_MGMT_GATE,
+			      NFC_HCI_ID_MGMT_VERSION_HW, &skb);
+	if (r < 0)
+		return r;
+
+	if (skb->len != 3) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	hdev->hw_derivative = (skb->data[0] & 0xe0) >> 5;
+	hdev->hw_version = skb->data[0] & 0x1f;
+	hdev->hw_mpw = (skb->data[1] & 0xc0) >> 6;
+	hdev->hw_software = skb->data[1] & 0x3f;
+	hdev->hw_bsid = skb->data[2];
+
+	kfree_skb(skb);
+
+	pr_info("SOFTWARE INFO:\n");
+	pr_info("RomLib         : %d\n", hdev->sw_romlib);
+	pr_info("Patch          : %d\n", hdev->sw_patch);
+	pr_info("FlashLib Major : %d\n", hdev->sw_flashlib_major);
+	pr_info("FlashLib Minor : %d\n", hdev->sw_flashlib_minor);
+	pr_info("HARDWARE INFO:\n");
+	pr_info("Derivative     : %d\n", hdev->hw_derivative);
+	pr_info("HW Version     : %d\n", hdev->hw_version);
+	pr_info("#MPW           : %d\n", hdev->hw_mpw);
+	pr_info("Software       : %d\n", hdev->hw_software);
+	pr_info("BSID Version   : %d\n", hdev->hw_bsid);
+
+	return 0;
+}
+
+static int hci_dev_up(struct nfc_dev *nfc_dev)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+	int r = 0;
+
+	if (hdev->ops->open) {
+		r = hdev->ops->open(hdev);
+		if (r < 0)
+			return r;
+	}
+
+	r = hci_dev_session_init(hdev);
+	if (r < 0)
+		goto exit;
+
+	r = nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
+			       NFC_HCI_EVT_END_OPERATION, NULL, 0);
+	if (r < 0)
+		goto exit;
+
+	if (hdev->ops->hci_ready) {
+		r = hdev->ops->hci_ready(hdev);
+		if (r < 0)
+			goto exit;
+	}
+
+	r = hci_dev_version(hdev);
+	if (r < 0)
+		goto exit;
+
+exit:
+	if (r < 0)
+		if (hdev->ops->close)
+			hdev->ops->close(hdev);
+	return r;
+}
+
+static int hci_dev_down(struct nfc_dev *nfc_dev)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+
+	if (hdev->ops->close)
+		hdev->ops->close(hdev);
+
+	memset(hdev->gate2pipe, NFC_HCI_INVALID_PIPE, sizeof(hdev->gate2pipe));
+
+	return 0;
+}
+
+static int hci_start_poll(struct nfc_dev *nfc_dev, u32 protocols)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+	int r;
+
+	if (hdev->ops->start_poll)
+		r = hdev->ops->start_poll(hdev, protocols);
+	else
+		r = nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
+				       NFC_HCI_EVT_READER_REQUESTED, NULL, 0);
+	if (r == 0)
+		hdev->poll_started = true;
+
+	return r;
+}
+
+static void hci_stop_poll(struct nfc_dev *nfc_dev)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+
+	if (hdev->poll_started) {
+		nfc_hci_send_event(hdev, NFC_HCI_RF_READER_A_GATE,
+				   NFC_HCI_EVT_END_OPERATION, NULL, 0);
+		hdev->poll_started = false;
+	}
+}
+
+static struct nfc_target *hci_find_target(struct nfc_hci_dev *hdev,
+					  u32 target_idx)
+{
+	int i;
+	if (hdev->poll_started == false || hdev->targets == NULL)
+		return NULL;
+
+	for (i = 0; i < hdev->target_count; i++) {
+		if (hdev->targets[i].idx == target_idx)
+			return &hdev->targets[i];
+	}
+
+	return NULL;
+}
+
+static int hci_activate_target(struct nfc_dev *nfc_dev, u32 target_idx,
+			       u32 protocol)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+
+	if (hci_find_target(hdev, target_idx) == NULL)
+		return -ENOMEDIUM;
+
+	return 0;
+}
+
+static void hci_deactivate_target(struct nfc_dev *nfc_dev, u32 target_idx)
+{
+}
+
+static int hci_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
+			     struct sk_buff *skb, data_exchange_cb_t cb,
+			     void *cb_context)
+{
+	struct nfc_hci_dev *hdev = nfc_get_drvdata(nfc_dev);
+	int r;
+	struct nfc_target *target;
+	struct sk_buff *res_skb = NULL;
+
+	pr_debug("target_idx=%d\n", target_idx);
+
+	target = hci_find_target(hdev, target_idx);
+	if (target == NULL)
+		return -ENOMEDIUM;
+
+	switch (target->hci_reader_gate) {
+	case NFC_HCI_RF_READER_A_GATE:
+	case NFC_HCI_RF_READER_B_GATE:
+		if (hdev->ops->data_exchange) {
+			r = hdev->ops->data_exchange(hdev, target, skb,
+						     &res_skb);
+			if (r <= 0)	/* handled */
+				break;
+		}
+
+		*skb_push(skb, 1) = 0;	/* CTR, see spec:10.2.2.1 */
+		r = nfc_hci_send_cmd(hdev, target->hci_reader_gate,
+				     NFC_HCI_WR_XCHG_DATA,
+				     skb->data, skb->len, &res_skb);
+		/*
+		 * TODO: Check RF Error indicator to make sure data is valid.
+		 * It seems that HCI cmd can complete without error, but data
+		 * can be invalid if an RF error occured? Ignore for now.
+		 */
+		if (r == 0)
+			skb_trim(res_skb, res_skb->len - 1); /* RF Err ind */
+		break;
+	default:
+		if (hdev->ops->data_exchange) {
+			r = hdev->ops->data_exchange(hdev, target, skb,
+						     &res_skb);
+			if (r == 1)
+				r = -ENOTSUPP;
+		}
+		else
+			r = -ENOTSUPP;
+	}
+
+	kfree_skb(skb);
+
+	cb(cb_context, res_skb, r);
+
+	return 0;
+}
+
+struct nfc_ops hci_nfc_ops = {
+	.dev_up = hci_dev_up,
+	.dev_down = hci_dev_down,
+	.start_poll = hci_start_poll,
+	.stop_poll = hci_stop_poll,
+	.activate_target = hci_activate_target,
+	.deactivate_target = hci_deactivate_target,
+	.data_exchange = hci_data_exchange,
+};
+
+struct nfc_hci_dev *nfc_hci_allocate_device(struct nfc_hci_ops *ops,
+					    struct nfc_hci_init_data *init_data,
+					    u32 protocols,
+					    int tx_headroom,
+					    int tx_tailroom,
+					    int max_link_payload)
+{
+	struct nfc_hci_dev *hdev;
+
+	if (ops->xmit == NULL)
+		return NULL;
+
+	if (protocols == 0)
+		return NULL;
+
+	hdev = kzalloc(sizeof(struct nfc_hci_dev), GFP_KERNEL);
+	if (hdev == NULL)
+		return NULL;
+
+	hdev->ndev = nfc_allocate_device(&hci_nfc_ops, protocols,
+					 tx_headroom + HCI_CMDS_HEADROOM,
+					 tx_tailroom);
+	if (!hdev->ndev) {
+		kfree(hdev);
+		return NULL;
+	}
+
+	hdev->ops = ops;
+	hdev->max_data_link_payload = max_link_payload;
+	hdev->init_data = *init_data;
+
+	nfc_set_drvdata(hdev->ndev, hdev);
+
+	memset(hdev->gate2pipe, NFC_HCI_INVALID_PIPE, sizeof(hdev->gate2pipe));
+
+	return hdev;
+}
+EXPORT_SYMBOL(nfc_hci_allocate_device);
+
+void nfc_hci_free_device(struct nfc_hci_dev *hdev)
+{
+	nfc_free_device(hdev->ndev);
+	kfree(hdev);
+}
+EXPORT_SYMBOL(nfc_hci_free_device);
+
+int nfc_hci_register_device(struct nfc_hci_dev *hdev)
+{
+	struct device *dev = &hdev->ndev->dev;
+	const char *devname = dev_name(dev);
+	char name[32];
+	int r = 0;
+
+	mutex_init(&hdev->msg_tx_mutex);
+
+	INIT_LIST_HEAD(&hdev->msg_tx_queue);
+
+	INIT_WORK(&hdev->msg_tx_work, nfc_hci_msg_tx_work);
+	snprintf(name, sizeof(name), "%s_hci_msg_tx_wq", devname);
+	hdev->msg_tx_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
+					  WQ_MEM_RECLAIM, 1);
+	if (hdev->msg_tx_wq == NULL) {
+		r = -ENOMEM;
+		goto exit;
+	}
+
+	init_timer(&hdev->cmd_timer);
+	hdev->cmd_timer.data = (unsigned long)hdev;
+	hdev->cmd_timer.function = nfc_hci_cmd_timeout;
+
+	skb_queue_head_init(&hdev->rx_hcp_frags);
+
+	INIT_WORK(&hdev->msg_rx_work, nfc_hci_msg_rx_work);
+	snprintf(name, sizeof(name), "%s_hci_msg_rx_wq", devname);
+	hdev->msg_rx_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
+					  WQ_MEM_RECLAIM, 1);
+	if (hdev->msg_rx_wq == NULL) {
+		r = -ENOMEM;
+		goto exit;
+	}
+
+	skb_queue_head_init(&hdev->msg_rx_queue);
+
+	r = nfc_register_device(hdev->ndev);
+
+exit:
+	if (r < 0) {
+		if (hdev->msg_tx_wq)
+			destroy_workqueue(hdev->msg_tx_wq);
+		if (hdev->msg_rx_wq)
+			destroy_workqueue(hdev->msg_rx_wq);
+	}
+
+	return r;
+}
+EXPORT_SYMBOL(nfc_hci_register_device);
+
+void nfc_hci_unregister_device(struct nfc_hci_dev *hdev)
+{
+	struct hci_msg *msg;
+
+	skb_queue_purge(&hdev->rx_hcp_frags);
+	skb_queue_purge(&hdev->msg_rx_queue);
+
+	while ((msg = list_first_entry(&hdev->msg_tx_queue, struct hci_msg,
+				       msg_l)) != NULL) {
+		list_del(&msg->msg_l);
+		skb_queue_purge(&msg->msg_frags);
+		kfree(msg);
+	}
+
+	del_timer_sync(&hdev->cmd_timer);
+
+	nfc_unregister_device(hdev->ndev);
+
+	destroy_workqueue(hdev->msg_tx_wq);
+
+	destroy_workqueue(hdev->msg_rx_wq);
+}
+EXPORT_SYMBOL(nfc_hci_unregister_device);
+
+void nfc_hci_set_clientdata(struct nfc_hci_dev *hdev, void *clientdata)
+{
+	hdev->clientdata = clientdata;
+}
+EXPORT_SYMBOL(nfc_hci_set_clientdata);
+
+void *nfc_hci_get_clientdata(struct nfc_hci_dev *hdev)
+{
+	return hdev->clientdata;
+}
+EXPORT_SYMBOL(nfc_hci_get_clientdata);
+
+void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb)
+{
+	struct hcp_packet *packet;
+	u8 type;
+	u8 instruction;
+	struct sk_buff *hcp_skb;
+	u8 pipe;
+	struct sk_buff *frag_skb;
+	int msg_len;
+
+	if (skb == NULL) {
+		/* TODO ELa: lower layer had permanent failure, need to
+		 * propagate that up
+		 */
+
+		skb_queue_purge(&hdev->rx_hcp_frags);
+
+		return;
+	}
+
+	packet = (struct hcp_packet *)skb->data;
+	if ((packet->header & ~NFC_HCI_FRAGMENT) == 0) {
+		skb_queue_tail(&hdev->rx_hcp_frags, skb);
+		return;
+	}
+
+	/* it's the last fragment. Does it need re-aggregation? */
+	if (skb_queue_len(&hdev->rx_hcp_frags)) {
+		pipe = packet->header & NFC_HCI_FRAGMENT;
+		skb_queue_tail(&hdev->rx_hcp_frags, skb);
+
+		msg_len = 0;
+		skb_queue_walk(&hdev->rx_hcp_frags, frag_skb) {
+			msg_len += (frag_skb->len -
+				    NFC_HCI_HCP_PACKET_HEADER_LEN);
+		}
+
+		hcp_skb = nfc_alloc_recv_skb(NFC_HCI_HCP_PACKET_HEADER_LEN +
+					     msg_len, GFP_KERNEL);
+		if (hcp_skb == NULL) {
+			/* TODO ELa: cannot deliver HCP message. How to
+			 * propagate error up?
+			 */
+		}
+
+		*skb_put(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN) = pipe;
+
+		skb_queue_walk(&hdev->rx_hcp_frags, frag_skb) {
+			msg_len = frag_skb->len - NFC_HCI_HCP_PACKET_HEADER_LEN;
+			memcpy(skb_put(hcp_skb, msg_len),
+			       frag_skb->data + NFC_HCI_HCP_PACKET_HEADER_LEN,
+			       msg_len);
+		}
+
+		skb_queue_purge(&hdev->rx_hcp_frags);
+	} else {
+		packet->header &= NFC_HCI_FRAGMENT;
+		hcp_skb = skb;
+	}
+
+	/* if this is a response, dispatch immediately to
+	 * unblock waiting cmd context. Otherwise, enqueue to dispatch
+	 * in separate context where handler can also execute command.
+	 */
+	packet = (struct hcp_packet *)hcp_skb->data;
+	type = HCP_MSG_GET_TYPE(packet->message.header);
+	if (type == NFC_HCI_HCP_RESPONSE) {
+		pipe = packet->header;
+		instruction = HCP_MSG_GET_CMD(packet->message.header);
+		skb_pull(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN +
+			 NFC_HCI_HCP_MESSAGE_HEADER_LEN);
+		nfc_hci_hcp_message_rx(hdev, pipe, type, instruction, hcp_skb);
+	} else {
+		skb_queue_tail(&hdev->msg_rx_queue, hcp_skb);
+		queue_work(hdev->msg_rx_wq, &hdev->msg_rx_work);
+	}
+}
+EXPORT_SYMBOL(nfc_hci_recv_frame);
+
+MODULE_LICENSE("GPL");
diff --git a/net/nfc/hci/hci.h b/net/nfc/hci/hci.h
new file mode 100644
index 0000000..45f2fe4
--- /dev/null
+++ b/net/nfc/hci/hci.h
@@ -0,0 +1,139 @@
+/*
+ * Copyright (C) 2012  Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __LOCAL_HCI_H
+#define __LOCAL_HCI_H
+
+struct gate_pipe_map {
+	u8 gate;
+	u8 pipe;
+};
+
+struct hcp_message {
+	u8 header;		/* type -cmd,evt,rsp- + instruction */
+	u8 data[];
+} __packed;
+
+struct hcp_packet {
+	u8 header;		/* cbit+pipe */
+	struct hcp_message message;
+} __packed;
+
+/*
+ * HCI command execution completion callback.
+ * result will be one of the HCI response codes.
+ * skb contains the response data and must be disposed.
+ */
+typedef void (*hci_cmd_cb_t) (struct nfc_hci_dev *hdev, u8 result,
+			      struct sk_buff *skb, void *cb_data);
+
+struct hcp_exec_waiter {
+	wait_queue_head_t *wq;
+	bool exec_complete;
+	int exec_result;
+	struct sk_buff *result_skb;
+};
+
+struct hci_msg {
+	struct list_head msg_l;
+	struct sk_buff_head msg_frags;
+	bool wait_response;
+	hci_cmd_cb_t cb;
+	void *cb_context;
+	unsigned long completion_delay;
+};
+
+struct hci_create_pipe_params {
+	u8 src_gate;
+	u8 dest_host;
+	u8 dest_gate;
+} __packed;
+
+struct hci_create_pipe_resp {
+	u8 src_host;
+	u8 src_gate;
+	u8 dest_host;
+	u8 dest_gate;
+	u8 pipe;
+} __packed;
+
+#define NFC_HCI_FRAGMENT	0x7f
+
+#define HCP_HEADER(type, instr) ((((type) & 0x03) << 6) | ((instr) & 0x3f))
+#define HCP_MSG_GET_TYPE(header) ((header & 0xc0) >> 6)
+#define HCP_MSG_GET_CMD(header) (header & 0x3f)
+
+int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
+			   u8 type, u8 instruction,
+			   const u8 *payload, size_t payload_len,
+			   hci_cmd_cb_t cb, void *cb_data,
+			   unsigned long completion_delay);
+
+u8 nfc_hci_pipe2gate(struct nfc_hci_dev *hdev, u8 pipe);
+
+void nfc_hci_hcp_message_rx(struct nfc_hci_dev *hdev, u8 pipe, u8 type,
+			    u8 instruction, struct sk_buff *skb);
+
+/* HCP headers */
+#define NFC_HCI_HCP_PACKET_HEADER_LEN	1
+#define NFC_HCI_HCP_MESSAGE_HEADER_LEN	1
+#define NFC_HCI_HCP_HEADER_LEN		2
+
+/* HCP types */
+#define NFC_HCI_HCP_COMMAND	0x00
+#define NFC_HCI_HCP_EVENT	0x01
+#define NFC_HCI_HCP_RESPONSE	0x02
+
+/* Generic commands */
+#define NFC_HCI_ANY_SET_PARAMETER	0x01
+#define NFC_HCI_ANY_GET_PARAMETER	0x02
+#define NFC_HCI_ANY_OPEN_PIPE		0x03
+#define NFC_HCI_ANY_CLOSE_PIPE		0x04
+
+/* Reader RF commands */
+#define NFC_HCI_WR_XCHG_DATA		0x10
+
+/* Admin commands */
+#define NFC_HCI_ADM_CREATE_PIPE			0x10
+#define NFC_HCI_ADM_DELETE_PIPE			0x11
+#define NFC_HCI_ADM_NOTIFY_PIPE_CREATED		0x12
+#define NFC_HCI_ADM_NOTIFY_PIPE_DELETED		0x13
+#define NFC_HCI_ADM_CLEAR_ALL_PIPE		0x14
+#define NFC_HCI_ADM_NOTIFY_ALL_PIPE_CLEARED	0x15
+
+/* Generic responses */
+#define NFC_HCI_ANY_OK				0x00
+#define NFC_HCI_ANY_E_NOT_CONNECTED		0x01
+#define NFC_HCI_ANY_E_CMD_PAR_UNKNOWN		0x02
+#define NFC_HCI_ANY_E_NOK			0x03
+#define NFC_HCI_ANY_E_PIPES_FULL		0x04
+#define NFC_HCI_ANY_E_REG_PAR_UNKNOWN		0x05
+#define NFC_HCI_ANY_E_PIPE_NOT_OPENED		0x06
+#define NFC_HCI_ANY_E_CMD_NOT_SUPPORTED		0x07
+#define NFC_HCI_ANY_E_INHIBITED			0x08
+#define NFC_HCI_ANY_E_TIMEOUT			0x09
+#define NFC_HCI_ANY_E_REG_ACCESS_DENIED		0x0a
+#define NFC_HCI_ANY_E_PIPE_ACCESS_DENIED	0x0b
+
+/* Pipes */
+#define NFC_HCI_INVALID_PIPE	0x80
+#define NFC_HCI_LINK_MGMT_PIPE	0x00
+#define NFC_HCI_ADMIN_PIPE	0x01
+
+#endif /* __LOCAL_HCI_H */
diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
new file mode 100644
index 0000000..7212cf2
--- /dev/null
+++ b/net/nfc/hci/hcp.c
@@ -0,0 +1,156 @@
+/*
+ * Copyright (C) 2012  Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#define pr_fmt(fmt) "hci: %s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <net/nfc/hci.h>
+
+#include "hci.h"
+
+/*
+ * Payload is the HCP message data only. Instruction will be prepended.
+ * Guarantees that cb will be called upon completion or timeout delay
+ * counted from the moment the cmd is sent to the transport.
+ */
+int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
+			   u8 type, u8 instruction,
+			   const u8 *payload, size_t payload_len,
+			   hci_cmd_cb_t cb, void *cb_data,
+			   unsigned long completion_delay)
+{
+	struct nfc_dev *ndev = hdev->ndev;
+	struct hci_msg *cmd;
+	const u8 *ptr = payload;
+	int hci_len, err;
+	bool firstfrag = true;
+
+	cmd = kzalloc(sizeof(struct hci_msg), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&cmd->msg_l);
+	skb_queue_head_init(&cmd->msg_frags);
+	cmd->wait_response = (type == NFC_HCI_HCP_COMMAND) ? true : false;
+	cmd->cb = cb;
+	cmd->cb_context = cb_data;
+	cmd->completion_delay = completion_delay;
+
+	hci_len = payload_len + 1;
+	while (hci_len > 0) {
+		struct sk_buff *skb;
+		int skb_len, data_link_len;
+		struct hcp_packet *packet;
+
+		if (NFC_HCI_HCP_PACKET_HEADER_LEN + hci_len <=
+		    hdev->max_data_link_payload)
+			data_link_len = hci_len;
+		else
+			data_link_len = hdev->max_data_link_payload -
+					NFC_HCI_HCP_PACKET_HEADER_LEN;
+
+		skb_len = ndev->tx_headroom + NFC_HCI_HCP_PACKET_HEADER_LEN +
+			  data_link_len + ndev->tx_tailroom;
+		hci_len -= data_link_len;
+
+		skb = alloc_skb(skb_len, GFP_KERNEL);
+		if (skb == NULL) {
+			err = -ENOMEM;
+			goto out_skb_err;
+		}
+		skb_reserve(skb, ndev->tx_headroom);
+
+		skb_put(skb, NFC_HCI_HCP_PACKET_HEADER_LEN + data_link_len);
+
+		/* Only the last fragment will have the cb bit set to 1 */
+		packet = (struct hcp_packet *)skb->data;
+		packet->header = pipe;
+		if (firstfrag) {
+			firstfrag = false;
+			packet->message.header = HCP_HEADER(type, instruction);
+			if (ptr) {
+				memcpy(packet->message.data, ptr,
+				       data_link_len - 1);
+				ptr += data_link_len - 1;
+			}
+		} else {
+			memcpy(&packet->message, ptr, data_link_len);
+			ptr += data_link_len;
+		}
+
+		/* This is the last fragment, set the cb bit */
+		if (hci_len == 0)
+			packet->header |= ~NFC_HCI_FRAGMENT;
+
+		skb_queue_tail(&cmd->msg_frags, skb);
+	}
+
+	mutex_lock(&hdev->msg_tx_mutex);
+	list_add_tail(&hdev->msg_tx_queue, &cmd->msg_l);
+	mutex_unlock(&hdev->msg_tx_mutex);
+
+	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+
+	return 0;
+
+out_skb_err:
+	skb_queue_purge(&cmd->msg_frags);
+	kfree(cmd);
+
+	return err;
+}
+
+u8 nfc_hci_pipe2gate(struct nfc_hci_dev *hdev, u8 pipe)
+{
+	int gate;
+
+	for (gate = 0; gate < NFC_HCI_MAX_GATES; gate++)
+		if (hdev->gate2pipe[gate] == pipe)
+			return gate;
+
+	return 0xff;
+}
+
+/*
+ * Receive hcp message for pipe, with type and cmd.
+ * skb contains optional message data only.
+ */
+void nfc_hci_hcp_message_rx(struct nfc_hci_dev *hdev, u8 pipe, u8 type,
+			    u8 instruction, struct sk_buff *skb)
+{
+	switch (type) {
+	case NFC_HCI_HCP_RESPONSE:
+		nfc_hci_resp_received(hdev, instruction, skb);
+		break;
+	case NFC_HCI_HCP_COMMAND:
+		nfc_hci_cmd_received(hdev, pipe, instruction, skb);
+		break;
+	case NFC_HCI_HCP_EVENT:
+		nfc_hci_event_received(hdev, pipe, instruction, skb);
+		break;
+	default:
+		pr_err("UNKNOWN MSG Type %d, instruction=%d\n",
+		       type, instruction);
+		kfree_skb(skb);
+		break;
+	}
+}
-- 
1.7.9.1

