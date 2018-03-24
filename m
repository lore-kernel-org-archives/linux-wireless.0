Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34175 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeCXNpN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 09:45:13 -0400
Received: by mail-qt0-f196.google.com with SMTP id l25so15410731qtj.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Mar 2018 06:45:12 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, christophe.ricard@gmail.com,
        linux-nfc@lists.01.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 2/2] nfc: st21nfca: Remove unnecessary devm_kzalloc() cast
Date: Sat, 24 Mar 2018 10:44:59 -0300
Message-Id: <1521899099-23634-2-git-send-email-festevam@gmail.com> (sfid-20180324_144516_841626_875E1145)
In-Reply-To: <1521899099-23634-1-git-send-email-festevam@gmail.com>
References: <1521899099-23634-1-git-send-email-festevam@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

There is no need to use cast for the returned value
from memory allocation functions, so remove the unnecessary cast.

Detected via Coccinelle script:
scripts/coccinelle/api/alloc/alloc_cast.cocci.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/nfc/st21nfca/se.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index fd967a3..5b63549 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -326,8 +326,7 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
-						   skb->len - 2, GFP_KERNEL);
+		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
 		if (!transaction)
 			return -ENOMEM;
 
-- 
2.7.4
