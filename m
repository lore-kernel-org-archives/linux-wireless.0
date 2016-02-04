Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59204 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbcBDJeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:34:13 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 66/70] staging: wilc1000: remove unnecessary wilc_rx_complete function
Date: Thu, 4 Feb 2016 18:24:27 +0900
Message-ID: <1454577871-667-27-git-send-email-glen.lee@atmel.com> (sfid-20160204_103418_422398_111BC596)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unnecessary wilc_rx_complete function
because this function only print unused log message.
remove unused has_packet variable nomore.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 5 -----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 drivers/staging/wilc1000/wilc_wlan.c          | 7 +------
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 202be15..e702020 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -372,11 +372,6 @@ static int linux_wlan_txq_task(void *vp)
 	return 0;
 }
 
-void wilc_rx_complete(struct wilc *nic)
-{
-	PRINT_D(RX_DBG, "RX completed\n");
-}
-
 int wilc_wlan_get_firmware(struct net_device *dev)
 {
 	struct wilc_vif *vif;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 07a4ff1..3077f5d4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -228,7 +228,6 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif);
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
-void wilc_rx_complete(struct wilc *wilc);
 void wilc_dbg(u8 *buff);
 
 int wilc_lock_timeout(struct wilc *wilc, void *, u32 timeout);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d7f14a9..8cb1ef6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -811,7 +811,7 @@ _end_:
 
 static void wilc_wlan_handle_rxq(struct wilc *wilc)
 {
-	int offset = 0, size, has_packet = 0;
+	int offset = 0, size;
 	u8 *buffer;
 	struct rxq_entry_t *rqe;
 
@@ -866,7 +866,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 							      &buffer[offset],
 							      pkt_len,
 							      pkt_offset);
-						has_packet = 1;
 					}
 				} else {
 					struct wilc_cfg_rsp rsp;
@@ -888,10 +887,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				break;
 		} while (1);
 		kfree(rqe);
-
-		if (has_packet)
-			wilc_rx_complete(wilc);
-
 	} while (1);
 
 	wilc->rxq_exit = 1;
-- 
1.9.1

