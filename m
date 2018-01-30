Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50277 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752827AbeA3PeF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 10:34:05 -0500
From: Colin King <colin.king@canonical.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: fdp: fix signed less or equal zero check in u8 max_size
Date: Tue, 30 Jan 2018 15:33:59 +0000
Message-Id: <20180130153359.524-1-colin.king@canonical.com> (sfid-20180130_163433_805262_9E3DD096)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The u8 variable max_size is being assigned a return value from the
call to nci_conn_max_data_pkt_payload_size that can return a -ve
error return. Since max_size is a u8, the -ve check for the error will
always be false. Fix this by making max_size an int type.

Detected using Coccinelle:
drivers/nfc/fdp/fdp.c:208:5-13: WARNING: Unsigned expression compared
with zero: max_size <= 0

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index d5784a47fc13..5ddc01b4913a 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -192,8 +192,8 @@ static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 	const struct firmware *fw;
 	struct sk_buff *skb;
 	unsigned long len;
-	u8 max_size, payload_size;
-	int rc = 0;
+	u8 payload_size;
+	int max_size, rc = 0;
 
 	if ((type == NCI_PATCH_TYPE_OTP && !info->otp_patch) ||
 	    (type == NCI_PATCH_TYPE_RAM && !info->ram_patch))
-- 
2.15.1
