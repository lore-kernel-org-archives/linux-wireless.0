Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.234]:26357 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752874AbeGDXMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 19:12:07 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id F21614C63
        for <linux-wireless@vger.kernel.org>; Wed,  4 Jul 2018 17:49:28 -0500 (CDT)
Date: Wed, 4 Jul 2018 17:48:56 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] NFC: pn533: mark expected switch fall-through
Message-ID: <20180704224856.GA19315@embeddedor.com> (sfid-20180705_011211_196059_2CEB3395)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Warning level 2 was used: -Wimplicit-fallthrough=2

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/nfc/pn533/pn533.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a0cc1cc..1d0eafeb 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2147,6 +2147,7 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 
 			break;
 		}
+		/* else: fall through */
 	default:
 		/* jumbo frame ? */
 		if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
@@ -2273,6 +2274,7 @@ static void pn533_wq_mi_recv(struct work_struct *work)
 
 			break;
 		}
+		/* else: fall through */
 	default:
 		skb_put_u8(skb, 1); /*TG*/
 
-- 
2.7.4
