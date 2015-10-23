Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52253 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbJWF2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:28:40 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/28] staging: wilc1000: tcp_process: add argument dev and get private from it
Date: Fri, 23 Oct 2015 14:28:44 +0900
Message-ID: <1445578124-31486-28-git-send-email-glen.lee@atmel.com> (sfid-20151023_074657_656205_4ADAA1F2)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument net_device *dev and use netdev private data member
wilc instead of g_linux_wlan. Pass argument dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6c4fef2..68a2fd4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -341,7 +341,7 @@ static inline int remove_TCP_related(void)
 	return 0;
 }
 
-static inline int tcp_process(struct txq_entry_t *tqe)
+static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 {
 	int ret;
 	u8 *eth_hdr_ptr;
@@ -350,8 +350,13 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	int i;
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
+	spin_lock_irqsave(&wl->txq_spinlock, flags);
 
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
@@ -399,7 +404,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	} else {
 		ret = 0;
 	}
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
 	return ret;
 }
 
@@ -525,7 +530,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 #ifdef TCP_ACK_FILTER
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
 	if (is_TCP_ACK_Filter_Enabled())
-		tcp_process(tqe);
+		tcp_process(dev, tqe);
 #endif
 	wilc_wlan_txq_add_to_tail(tqe);
 	/*return number of itemes in the queue*/
-- 
1.9.1

