Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46864 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbeDRKFT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 06:05:19 -0400
Received: by mail-pf0-f195.google.com with SMTP id h69so660170pfe.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 03:05:19 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [RESEND][PATCH 2/4] NFC: st21nfca: Fix memory OOB and leak issues in connectivity events handler
Date: Wed, 18 Apr 2018 15:35:02 +0530
Message-Id: <1524045904-7005-3-git-send-email-amit.pundir@linaro.org> (sfid-20180418_120528_277665_17542FE4)
In-Reply-To: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

Overflow on memcpy is possible in kernel driver for st21nfca's
NFC HCI layer when handling connectivity events if aid_len or
params_len are bigger than the buffer size.
Memory leak is possible when parameter tag is invalid.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 drivers/nfc/st21nfca/se.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 4bed9e842db3..acdce231e227 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -322,23 +322,33 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
+		/*
+		 * Buffer should have enough space for at least
+		 * two tag fields + two length fields + aid_len (skb->data[1])
+		 */
+		if (skb->len < skb->data[1] + 4)
+			return -EPROTO;
+
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 						   skb->len - 2, GFP_KERNEL);
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
+		transaction->params_len = skb->data[transaction->aid_len + 3];
 
-		/* Check next byte is PARAMETERS tag (82) */
+		/* Check next byte is PARAMETERS tag (82) and the length field */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG ||
+		    skb->len < transaction->aid_len + transaction->params_len + 4) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 
-- 
2.7.4
