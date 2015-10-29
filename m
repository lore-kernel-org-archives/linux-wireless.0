Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28155 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbbJ2DPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:15:54 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 01/12] staging: wilc1000: wilc_wlan_txq_get_first: add argument struct wilc
Date: Thu, 29 Oct 2015 12:18:41 +0900
Message-ID: <1446088732-12301-1-git-send-email-glen.lee@atmel.com> (sfid-20151029_041558_423249_063965EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c026657..6c7cbd1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -563,17 +563,17 @@ int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_
 	return 1;
 }
 
-static struct txq_entry_t *wilc_wlan_txq_get_first(void)
+static struct txq_entry_t *wilc_wlan_txq_get_first(struct wilc *wilc)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
 	unsigned long flags;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	tqe = p->txq_head;
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
 
 	return tqe;
@@ -855,7 +855,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		 *      build the vmm list
 		 **/
 		PRINT_D(TX_DBG, "Getting the head of the TxQ\n");
-		tqe = wilc_wlan_txq_get_first();
+		tqe = wilc_wlan_txq_get_first(wilc);
 		i = 0;
 		sum = 0;
 		do {
-- 
1.9.1

