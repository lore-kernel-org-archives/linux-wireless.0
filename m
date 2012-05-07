Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43433 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2EGKcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:15 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 06/20] NFC: Update Documentation/nfc-hci.txt
Date: Mon,  7 May 2012 12:31:17 +0200
Message-Id: <1336386691-24840-7-git-send-email-sameo@linux.intel.com> (sfid-20120507_123218_355455_C4A614F0)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Document the new HCI ops and fix a few typos and spelling mistakes.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 Documentation/nfc/nfc-hci.txt |   45 +++++++++++++++++++++++++++++++---------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/Documentation/nfc/nfc-hci.txt b/Documentation/nfc/nfc-hci.txt
index 216b725..320f933 100644
--- a/Documentation/nfc/nfc-hci.txt
+++ b/Documentation/nfc/nfc-hci.txt
@@ -22,9 +22,9 @@ response to arrive.
 HCI events can also be received from the host controller. They will be handled
 and a translation will be forwarded to NFC Core as needed.
 HCI uses 2 execution contexts:
-- one if for executing commands : nfc_hci_msg_tx_work(). Only one command
+- one for executing commands : nfc_hci_msg_tx_work(). Only one command
 can be executing at any given moment.
-- one if for dispatching received events and responses : nfc_hci_msg_rx_work()
+- one for dispatching received events and commands : nfc_hci_msg_rx_work().
 
 HCI Session initialization:
 ---------------------------
@@ -52,18 +52,42 @@ entry points:
 struct nfc_hci_ops {
 	int (*open)(struct nfc_hci_dev *hdev);
 	void (*close)(struct nfc_hci_dev *hdev);
+	int (*hci_ready) (struct nfc_hci_dev *hdev);
 	int (*xmit)(struct nfc_hci_dev *hdev, struct sk_buff *skb);
 	int (*start_poll)(struct nfc_hci_dev *hdev, u32 protocols);
 	int (*target_from_gate)(struct nfc_hci_dev *hdev, u8 gate,
 				struct nfc_target *target);
+	int (*complete_target_discovered) (struct nfc_hci_dev *hdev, u8 gate,
+					   struct nfc_target *target);
+	int (*data_exchange) (struct nfc_hci_dev *hdev,
+			      struct nfc_target *target,
+			      struct sk_buff *skb, struct sk_buff **res_skb);
+	int (*check_presence)(struct nfc_hci_dev *hdev,
+			      struct nfc_target *target);
 };
 
-open() and close() shall turn the hardware on and off. xmit() shall simply
-write a frame to the chip. start_poll() is an optional entrypoint that shall
-set the hardware in polling mode. This must be implemented only if the hardware
-uses proprietary gates or a mechanism slightly different from the HCI standard.
-target_from_gate() is another optional entrypoint to return the protocols
+- open() and close() shall turn the hardware on and off.
+- hci_ready() is an optional entry point that is called right after the hci
+session has been set up. The driver can use it to do additional initialization
+that must be performed using HCI commands.
+- xmit() shall simply write a frame to the chip.
+- start_poll() is an optional entrypoint that shall set the hardware in polling
+mode. This must be implemented only if the hardware uses proprietary gates or a
+mechanism slightly different from the HCI standard.
+- target_from_gate() is an optional entrypoint to return the nfc protocols
 corresponding to a proprietary gate.
+- complete_target_discovered() is an optional entry point to let the driver
+perform additional proprietary processing necessary to auto activate the
+discovered target.
+- data_exchange() must be implemented by the driver if proprietary HCI commands
+are required to send data to the tag. Some tag types will require custom
+commands, others can be written to using the standard HCI commands. The driver
+can check the tag type and either do proprietary processing, or return 1 to ask
+for standard processing.
+- check_presence() is an optional entry point that will be called regularly
+by the core to check that an activated tag is still in the field. If this is
+not implemented, the core will not be able to push tag_lost events to the user
+space
 
 On the rx path, the driver is responsible to push incoming HCP frames to HCI
 using nfc_hci_recv_frame(). HCI will take care of re-aggregation and handling
@@ -99,7 +123,8 @@ fast, cannot sleep. stores incoming frames into an shdlc rx queue
 handles shdlc rx & tx queues. Dispatches HCI cmd responses.
 
 - HCI Tx Cmd worker (MSGTXWQ)
-Serialize execution of HCI commands. Complete execution in case of resp timeout.
+Serializes execution of HCI commands. Completes execution in case of response
+timeout.
 
 - HCI Rx worker (MSGRXWQ)
 Dispatches incoming HCI commands or events.
@@ -133,11 +158,11 @@ able to complete the command with a timeout error if no response arrive.
 SMW context gets scheduled and invokes nfc_shdlc_sm_work(). This function
 handles shdlc framing in and out. It uses the driver xmit to send frames and
 receives incoming frames in an skb queue filled from the driver IRQ handler.
-SHDLC I(nformation) frames payload are HCP fragments. They are agregated to
+SHDLC I(nformation) frames payload are HCP fragments. They are aggregated to
 form complete HCI frames, which can be a response, command, or event.
 
 HCI Responses are dispatched immediately from this context to unblock
-waiting command execution. Reponse processing involves invoking the completion
+waiting command execution. Response processing involves invoking the completion
 callback that was provided by nfc_hci_msg_tx_work() when it sent the command.
 The completion callback will then wake the syscall context.
 
-- 
1.7.9.1

