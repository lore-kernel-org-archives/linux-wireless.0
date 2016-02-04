Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10429 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966103AbcBDJ06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:26:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 34/70] staging: wilc1000: remove useless function
Date: Thu, 4 Feb 2016 18:15:51 +0900
Message-ID: <1454577387-509-35-git-send-email-glen.lee@atmel.com> (sfid-20160204_102706_687489_BC1E1896)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove useless function remove_TCP_related
in wilc_wlan.c file

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 400d311..8618e27 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -206,15 +206,6 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 	}
 	return 0;
 }
-static inline int remove_TCP_related(struct wilc *wilc)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-	return 0;
-}
 
 static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 {
-- 
1.9.1

