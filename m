Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:41832 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeCXNpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 09:45:10 -0400
Received: by mail-qt0-f195.google.com with SMTP id d18so2982585qtl.8
        for <linux-wireless@vger.kernel.org>; Sat, 24 Mar 2018 06:45:10 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, christophe.ricard@gmail.com,
        linux-nfc@lists.01.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 1/2] nfc: st21nfca: Check for devm_kzalloc() failure
Date: Sat, 24 Mar 2018 10:44:58 -0300
Message-Id: <1521899099-23634-1-git-send-email-festevam@gmail.com> (sfid-20180324_144514_535190_270F9631)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

devm_kzalloc() may fail, so we should better check for error and
propagate the error in the case of allocation failure.

This avoids a potential NULL pointer dereference later on.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/nfc/st21nfca/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 4bed9e84..fd967a3 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -328,6 +328,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 						   skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2],
-- 
2.7.4
