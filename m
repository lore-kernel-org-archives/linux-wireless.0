Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:42671 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756746AbdLTTvn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 14:51:43 -0500
Received: by mail-pg0-f66.google.com with SMTP id q67so3092573pga.9
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 11:51:43 -0800 (PST)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH 3/4] NFC: Fix possible memory corruption when handling SHDLC I-Frame commands
Date: Thu, 21 Dec 2017 01:21:23 +0530
Message-Id: <1513799484-12505-4-git-send-email-amit.pundir@linaro.org> (sfid-20171220_205150_085665_9F9A7D25)
In-Reply-To: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org>
References: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

When handling SHDLC I-Frame commands "pipe" field used for indexing
into an array should be checked before usage. If left unchecked it
might access memory outside of the array of size NFC_HCI_MAX_PIPES(127).

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
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
2.7.4
