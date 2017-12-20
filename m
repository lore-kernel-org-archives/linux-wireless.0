Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37412 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756615AbdLTTvj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 14:51:39 -0500
Received: by mail-pl0-f68.google.com with SMTP id s3so9608559plp.4
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 11:51:39 -0800 (PST)
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
Subject: [RFC][PATCH 2/4] NFC: st21nfca: Fix memory OOB and leak issues in connectivity events handler
Date: Thu, 21 Dec 2017 01:21:22 +0530
Message-Id: <1513799484-12505-3-git-send-email-amit.pundir@linaro.org> (sfid-20171220_205149_538568_6B160C15)
In-Reply-To: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org>
References: <1513799484-12505-1-git-send-email-amit.pundir@linaro.org>
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
