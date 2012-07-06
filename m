Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2GFT7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:35 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 15/33] NFC: Allow HCI driver to pre-open pipes to some gates
Date: Fri,  6 Jul 2012 22:09:35 +0200
Message-Id: <1341605393-32056-16-git-send-email-sameo@linux.intel.com> (sfid-20120706_220531_449963_72F146D5)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@linux.intel.com>

Some NFC chips will statically create and open pipes for both standard
and proprietary gates. The driver can now pass this information to HCI
such that HCI will not attempt to create and open them, but will instead
directly use the passed pipe ids.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn544_hci.c |   31 ++++++++++++++++++-------------
 include/net/nfc/hci.h   |   17 ++++++++++++++---
 net/nfc/hci/command.c   |    8 ++++++--
 net/nfc/hci/core.c      |   23 +++++++++--------------
 net/nfc/hci/hci.h       |    5 -----
 5 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index 69df6fe..c67b55e 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -108,16 +108,22 @@ enum pn544_state {
 
 #define PN544_NFC_WI_MGMT_GATE			0xA1
 
-static u8 pn544_custom_gates[] = {
-	PN544_SYS_MGMT_GATE,
-	PN544_SWP_MGMT_GATE,
-	PN544_POLLING_LOOP_MGMT_GATE,
-	PN544_NFC_WI_MGMT_GATE,
-	PN544_RF_READER_F_GATE,
-	PN544_RF_READER_JEWEL_GATE,
-	PN544_RF_READER_ISO15693_GATE,
-	PN544_RF_READER_NFCIP1_INITIATOR_GATE,
-	PN544_RF_READER_NFCIP1_TARGET_GATE
+static struct nfc_hci_gate pn544_gates[] = {
+	{NFC_HCI_ADMIN_GATE, NFC_HCI_INVALID_PIPE},
+	{NFC_HCI_LOOPBACK_GATE, NFC_HCI_INVALID_PIPE},
+	{NFC_HCI_ID_MGMT_GATE, NFC_HCI_INVALID_PIPE},
+	{NFC_HCI_LINK_MGMT_GATE, NFC_HCI_INVALID_PIPE},
+	{NFC_HCI_RF_READER_B_GATE, NFC_HCI_INVALID_PIPE},
+	{NFC_HCI_RF_READER_A_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_SYS_MGMT_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_SWP_MGMT_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_POLLING_LOOP_MGMT_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_NFC_WI_MGMT_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_RF_READER_F_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_RF_READER_JEWEL_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_RF_READER_ISO15693_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_RF_READER_NFCIP1_INITIATOR_GATE, NFC_HCI_INVALID_PIPE},
+	{PN544_RF_READER_NFCIP1_TARGET_GATE, NFC_HCI_INVALID_PIPE}
 };
 
 /* Largest headroom needed for outgoing custom commands */
@@ -849,10 +855,9 @@ static int __devinit pn544_hci_probe(struct i2c_client *client,
 		goto err_rti;
 	}
 
-	init_data.gate_count = ARRAY_SIZE(pn544_custom_gates);
+	init_data.gate_count = ARRAY_SIZE(pn544_gates);
 
-	memcpy(init_data.gates, pn544_custom_gates,
-	       ARRAY_SIZE(pn544_custom_gates));
+	memcpy(init_data.gates, pn544_gates, sizeof(pn544_gates));
 
 	/*
 	 * TODO: Session id must include the driver name + some bus addr
diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index d25dd9b..f5169b0 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -44,10 +44,20 @@ struct nfc_hci_ops {
 			      struct nfc_target *target);
 };
 
-#define NFC_HCI_MAX_CUSTOM_GATES	15
+/* Pipes */
+#define NFC_HCI_INVALID_PIPE	0x80
+#define NFC_HCI_LINK_MGMT_PIPE	0x00
+#define NFC_HCI_ADMIN_PIPE	0x01
+
+struct nfc_hci_gate {
+	u8 gate;
+	u8 pipe;
+};
+
+#define NFC_HCI_MAX_CUSTOM_GATES	50
 struct nfc_hci_init_data {
 	u8 gate_count;
-	u8 gates[NFC_HCI_MAX_CUSTOM_GATES];
+	struct nfc_hci_gate gates[NFC_HCI_MAX_CUSTOM_GATES];
 	char session_id[9];
 };
 
@@ -182,7 +192,8 @@ void nfc_hci_event_received(struct nfc_hci_dev *hdev, u8 pipe, u8 event,
 void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb);
 
 /* connecting to gates and sending hci instructions */
-int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate);
+int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate,
+			 u8 pipe);
 int nfc_hci_disconnect_gate(struct nfc_hci_dev *hdev, u8 gate);
 int nfc_hci_disconnect_all_gates(struct nfc_hci_dev *hdev);
 int nfc_hci_get_param(struct nfc_hci_dev *hdev, u8 gate, u8 idx,
diff --git a/net/nfc/hci/command.c b/net/nfc/hci/command.c
index 12cd6f3..46362ef 100644
--- a/net/nfc/hci/command.c
+++ b/net/nfc/hci/command.c
@@ -299,9 +299,9 @@ int nfc_hci_disconnect_all_gates(struct nfc_hci_dev *hdev)
 }
 EXPORT_SYMBOL(nfc_hci_disconnect_all_gates);
 
-int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate)
+int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate,
+			 u8 pipe)
 {
-	u8 pipe = NFC_HCI_INVALID_PIPE;
 	bool pipe_created = false;
 	int r;
 
@@ -310,6 +310,9 @@ int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate)
 	if (hdev->gate2pipe[dest_gate] != NFC_HCI_INVALID_PIPE)
 		return -EADDRINUSE;
 
+	if (pipe != NFC_HCI_INVALID_PIPE)
+		goto pipe_is_open;
+
 	switch (dest_gate) {
 	case NFC_HCI_LINK_MGMT_GATE:
 		pipe = NFC_HCI_LINK_MGMT_PIPE;
@@ -335,6 +338,7 @@ int nfc_hci_connect_gate(struct nfc_hci_dev *hdev, u8 dest_host, u8 dest_gate)
 		return r;
 	}
 
+pipe_is_open:
 	hdev->gate2pipe[dest_gate] = pipe;
 
 	return 0;
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index e6b2df3..4ccc518 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -315,15 +315,15 @@ static void nfc_hci_cmd_timeout(unsigned long data)
 }
 
 static int hci_dev_connect_gates(struct nfc_hci_dev *hdev, u8 gate_count,
-				 u8 gates[])
+				 struct nfc_hci_gate *gates)
 {
 	int r;
-	u8 *p = gates;
 	while (gate_count--) {
-		r = nfc_hci_connect_gate(hdev, NFC_HCI_HOST_CONTROLLER_ID, *p);
+		r = nfc_hci_connect_gate(hdev, NFC_HCI_HOST_CONTROLLER_ID,
+					 gates->gate, gates->pipe);
 		if (r < 0)
 			return r;
-		p++;
+		gates++;
 	}
 
 	return 0;
@@ -333,14 +333,13 @@ static int hci_dev_session_init(struct nfc_hci_dev *hdev)
 {
 	struct sk_buff *skb = NULL;
 	int r;
-	u8 hci_gates[] = {	/* NFC_HCI_ADMIN_GATE MUST be first */
-		NFC_HCI_ADMIN_GATE, NFC_HCI_LOOPBACK_GATE,
-		NFC_HCI_ID_MGMT_GATE, NFC_HCI_LINK_MGMT_GATE,
-		NFC_HCI_RF_READER_B_GATE, NFC_HCI_RF_READER_A_GATE
-	};
+
+	if (hdev->init_data.gates[0].gate != NFC_HCI_ADMIN_GATE)
+		return -EPROTO;
 
 	r = nfc_hci_connect_gate(hdev, NFC_HCI_HOST_CONTROLLER_ID,
-				 NFC_HCI_ADMIN_GATE);
+				 hdev->init_data.gates[0].gate,
+				 hdev->init_data.gates[0].pipe);
 	if (r < 0)
 		goto exit;
 
@@ -368,10 +367,6 @@ static int hci_dev_session_init(struct nfc_hci_dev *hdev)
 	if (r < 0)
 		goto exit;
 
-	r = hci_dev_connect_gates(hdev, sizeof(hci_gates), hci_gates);
-	if (r < 0)
-		goto disconnect_all;
-
 	r = hci_dev_connect_gates(hdev, hdev->init_data.gate_count,
 				  hdev->init_data.gates);
 	if (r < 0)
diff --git a/net/nfc/hci/hci.h b/net/nfc/hci/hci.h
index d3cde07..fa9a21e 100644
--- a/net/nfc/hci/hci.h
+++ b/net/nfc/hci/hci.h
@@ -132,9 +132,4 @@ void nfc_hci_hcp_message_rx(struct nfc_hci_dev *hdev, u8 pipe, u8 type,
 #define NFC_HCI_ANY_E_REG_ACCESS_DENIED		0x0a
 #define NFC_HCI_ANY_E_PIPE_ACCESS_DENIED	0x0b
 
-/* Pipes */
-#define NFC_HCI_INVALID_PIPE	0x80
-#define NFC_HCI_LINK_MGMT_PIPE	0x00
-#define NFC_HCI_ADMIN_PIPE	0x01
-
 #endif /* __LOCAL_HCI_H */
-- 
1.7.10

