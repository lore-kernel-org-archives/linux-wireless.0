Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:20461 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaIRGkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 02:40:12 -0400
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH] ath9k: Fix NULL pointer dereference on early irq
Date: Thu, 18 Sep 2014 08:30:41 +0200
Message-Id: <1411021841-12683-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20140918_084027_868413_EC038BD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ah struct might not have been initialized when
interrupt comes so check for it.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3e485f7..fbf23ac 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -504,7 +504,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * touch anything. Note this can happen early
 	 * on if the IRQ is shared.
 	 */
-	if (test_bit(ATH_OP_INVALID, &common->op_flags))
+	if (!ah || test_bit(ATH_OP_INVALID, &common->op_flags))
 		return IRQ_NONE;
 
 	/* shared irq, not for us */
-- 
1.9.1

