Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37142 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 40/73] staging: wilc1000: rename pu32TxqCount in wilc_wlan_handle_txq function
Date: Fri, 6 Nov 2015 11:13:01 +0900
Message-ID: <1446776014-28094-40-git-send-email-glen.lee@atmel.com> (sfid-20151106_033803_115929_EB988324)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename pu32TxqCount to txq_count that is second argument of
wilc_wlan_handle_txq function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 66d5d42..cffd720 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -695,7 +695,7 @@ void chip_sleep_manually(void)
 	release_bus(RELEASE_ONLY);
 }
 
-int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
+int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int i, entries = 0;
@@ -949,7 +949,7 @@ _end_:
 
 	p->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
-	*pu32TxqCount = p->txq_entries;
+	*txq_count = p->txq_entries;
 	return ret;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index de2fb7c..1eaac9a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -300,7 +300,7 @@ int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func);
-int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount);
+int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
 void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-- 
1.9.1

