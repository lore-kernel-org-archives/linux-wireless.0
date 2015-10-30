Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20776 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbbJ3DI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:08:28 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/17] staging: wilc1000: remove unused function remove_TCP_related
Date: Fri, 30 Oct 2015 12:10:33 +0900
Message-ID: <1446174642-28570-8-git-send-email-glen.lee@atmel.com> (sfid-20151030_040831_136174_0D31FA93)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just remove unused function remove_TCP_related.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b503f07..c8ce1f6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -349,16 +349,6 @@ static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_ent
 	}
 	return 0;
 }
-static inline int remove_TCP_related(void)
-{
-	wilc_wlan_dev_t *p = &g_wlan;
-	unsigned long flags;
-
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
-
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
-	return 0;
-}
 
 static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 {
-- 
1.9.1

