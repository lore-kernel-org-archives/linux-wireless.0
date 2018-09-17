Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeIQTTf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 15:19:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sameo@linux.intel.com, davem@davemloft.net, netdev@vger.kernel.org
Cc: allen.pais@oracle.com, keescook@chromium.org, surenb@google.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] NFC: Fix possible memory corruption when handling SHDLC I-Frame commands
Date: Mon, 17 Sep 2018 15:51:40 +0200
Message-Id: <20180917135141.28328-2-gregkh@linuxfoundation.org> (sfid-20180917_155228_496980_87542BFE)
In-Reply-To: <20180917135141.28328-1-gregkh@linuxfoundation.org>
References: <20180917135141.28328-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

When handling SHDLC I-Frame commands "pipe" field used for indexing
into an array should be checked before usage. If left unchecked it
might access memory outside of the array of size NFC_HCI_MAX_PIPES(127).

Malformed NFC HCI frames could be injected by a malicious NFC device
communicating with the device being attacked (remote attack vector),
or even by an attacker with physical access to the I2C bus such that
they could influence the data transfers on that bus (local attack vector).
skb->data is controlled by the attacker and has only been sanitized in
the most trivial ways (CRC check), therefore we can consider the
create_info struct and all of its members to tainted. 'create_info->pipe'
with max value of 255 (uint8) is used to take an offset of the
hdev->pipes array of 127 elements which can lead to OOB write.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Allen Pais <allen.pais@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Suggested-by: Kevin Deus <kdeus@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/hci/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index ac8030c4bcf8..19cb2e473ea6 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -209,6 +209,11 @@ void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
 		}
 		create_info = (struct hci_create_pipe_resp *)skb->data;
 
+		if (create_info->pipe >= NFC_HCI_MAX_PIPES) {
+			status = NFC_HCI_ANY_E_NOK;
+			goto exit;
+		}
+
 		/* Save the new created pipe and bind with local gate,
 		 * the description for skb->data[3] is destination gate id
 		 * but since we received this cmd from host controller, we
@@ -232,6 +237,11 @@ void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
 		}
 		delete_info = (struct hci_delete_pipe_noti *)skb->data;
 
+		if (delete_info->pipe >= NFC_HCI_MAX_PIPES) {
+			status = NFC_HCI_ANY_E_NOK;
+			goto exit;
+		}
+
 		hdev->pipes[delete_info->pipe].gate = NFC_HCI_INVALID_GATE;
 		hdev->pipes[delete_info->pipe].dest_host = NFC_HCI_INVALID_HOST;
 		break;
-- 
2.19.0
