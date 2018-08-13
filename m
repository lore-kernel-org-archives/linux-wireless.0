Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40872 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbeHNBYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:24:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id e13-v6so8318809pff.7
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 15:40:02 -0700 (PDT)
From: Suren Baghdasaryan <surenb@google.com>
Cc: security@kernel.org, kdeus@google.com, surenb@google.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] NFC: Fix possible memory corruption when handling SHDLC I-Frame commands
Date: Mon, 13 Aug 2018 15:39:08 -0700
Message-Id: <20180813223910.26276-1-surenb@google.com> (sfid-20180814_004011_887275_7E164D8B)
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Suggested-by: Kevin Deus <kdeus@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
2.18.0.597.ga71716f1ad-goog
