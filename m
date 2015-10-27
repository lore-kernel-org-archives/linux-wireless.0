Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58561 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbbJ0J11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:27:27 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 24/27] staging: wilc1000: wilc_wlan_txq_get_next: add argument wilc
Date: Tue, 27 Oct 2015 18:28:00 +0900
Message-ID: <1445938083-20445-24-git-send-email-glen.lee@atmel.com> (sfid-20151027_102840_311429_FE58B9F4)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a6b966f..b109289 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -574,13 +574,14 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 	return tqe;
 }
 
-static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
+static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
+						  struct txq_entry_t *tqe)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	tqe = tqe->next;
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
 
 	return tqe;
@@ -887,7 +888,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 				i++;
 				sum += vmm_sz;
 				PRINT_D(TX_DBG, "sum = %d\n", sum);
-				tqe = wilc_wlan_txq_get_next(tqe);
+				tqe = wilc_wlan_txq_get_next(wilc, tqe);
 			} else {
 				break;
 			}
-- 
1.9.1

