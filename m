Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28192 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbbJ2DQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:16:12 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 04/12] staging: wilc1000: wilc_wlan_txq_add_mgmt_pkt: add new argument dev
Date: Thu, 29 Oct 2015 12:18:44 +0900
Message-ID: <1446088732-12301-4-git-send-email-glen.lee@atmel.com> (sfid-20151029_041615_668968_BC26BB54)
In-Reply-To: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
References: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device *dev and pass argument
struct net_device to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c              | 3 ++-
 drivers/staging/wilc1000/wilc_wlan.h              | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 450af1b..589a11f 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -195,7 +195,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	mgmt_tx->size = len;
 
 	memcpy(mgmt_tx->buff, buf, len);
-	wilc_wlan_txq_add_mgmt_pkt(mgmt_tx, mgmt_tx->buff, mgmt_tx->size,
+	wilc_wlan_txq_add_mgmt_pkt(dev, mgmt_tx, mgmt_tx->buff, mgmt_tx->size,
 				   mgmt_tx_complete);
 
 	netif_wake_queue(dev);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4de27ef..cdcf134 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2337,8 +2337,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 				jiffies, pstrWFIDrv->p2p_timeout);
 		}
 
-		wilc_wlan_txq_add_mgmt_pkt(mgmt_tx, mgmt_tx->buff,
-					   mgmt_tx->size,
+		wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
+					   mgmt_tx->buff, mgmt_tx->size,
 					   WILC_WFI_mgmt_tx_complete);
 	} else {
 		PRINT_D(GENERIC_DBG, "This function transmits only management frames\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5dcc4d2..3dc0a80 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -543,7 +543,8 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	return p->txq_entries;
 }
 
-int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
+int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
+			       u32 buffer_size, wilc_tx_complete_func_t func)
 {
 
 	wilc_wlan_dev_t *p = &g_wlan;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 57e1d51..2eb7e20 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -307,6 +307,6 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
-int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size,
-			       wilc_tx_complete_func_t func);
+int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
+			       u32 buffer_size, wilc_tx_complete_func_t func);
 #endif
-- 
1.9.1

