Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25389 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbIXJMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:12:53 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/15] staging: wilc1000: remove function pointer mac_indicate
Date: Thu, 24 Sep 2015 18:14:53 +0900
Message-ID: <1443086106-20482-2-git-send-email-glen.lee@atmel.com> (sfid-20150924_111256_183138_FA7D7386)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need for a pointer to a function. Just call linux_wlan_mac_indicate.
Remove mac_indicate and also wilc_wlan_indicate_func_t since no members in it.
Variable indicate_func is not used so delete it and related codes.
Finally remove static from the function linux_wlan_mac_indicate.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 3 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 9 ++-------
 drivers/staging/wilc1000/wilc_wlan_if.h       | 4 ----
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8119c40..9e099c3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -393,7 +393,7 @@ static int linux_wlan_lock_timeout(void *vp, u32 timeout)
 	return error;
 }
 
-static void linux_wlan_mac_indicate(int flag)
+void linux_wlan_mac_indicate(int flag)
 {
 	/*I have to do it that way becuase there is no mean to encapsulate device pointer
 	 * as a parameter
@@ -1095,7 +1095,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 
 	/*for now - to be revised*/
 	nwi->net_func.rx_complete = linux_wlan_rx_complete;
-	nwi->indicate_func.mac_indicate = linux_wlan_mac_indicate;
 }
 
 int wlan_initialize_threads(perInterface_wlan_t *nic)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 72220df..5efbaf4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -217,5 +217,6 @@ struct WILC_WFI_mon_priv {
 
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
+void linux_wlan_mac_indicate(int flag);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 56af108..8acf013 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -33,7 +33,6 @@ typedef struct {
 	wilc_wlan_os_func_t os_func;
 	wilc_wlan_io_func_t io_func;
 	wilc_wlan_net_func_t net_func;
-	wilc_wlan_indicate_func_t indicate_func;
 
 	/**
 	 *      host interface functions
@@ -1223,13 +1222,10 @@ static void wilc_wlan_handle_rxq(void)
 						/**
 						 *      Call back to indicate status...
 						 **/
-						if (p->indicate_func.mac_indicate) {
-							p->indicate_func.mac_indicate(WILC_MAC_INDICATE_STATUS);
-						}
+						linux_wlan_mac_indicate(WILC_MAC_INDICATE_STATUS);
 
 					} else if (rsp.type == WILC_CFG_RSP_SCAN) {
-						if (p->indicate_func.mac_indicate)
-							p->indicate_func.mac_indicate(WILC_MAC_INDICATE_SCAN);
+						linux_wlan_mac_indicate(WILC_MAC_INDICATE_SCAN);
 					}
 				}
 			}
@@ -1978,7 +1974,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	memcpy((void *)&g_wlan.os_func, (void *)&inp->os_func, sizeof(wilc_wlan_os_func_t));
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
 	memcpy((void *)&g_wlan.net_func, (void *)&inp->net_func, sizeof(wilc_wlan_net_func_t));
-	memcpy((void *)&g_wlan.indicate_func, (void *)&inp->indicate_func, sizeof(wilc_wlan_net_func_t));
 	g_wlan.hif_lock = inp->os_context.hif_critical_section;
 	g_wlan.txq_lock = inp->os_context.txq_critical_section;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index f878ca5..e42bb07 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -103,9 +103,6 @@ typedef struct {
 	void (*rx_complete)(void);
 } wilc_wlan_net_func_t;
 
-typedef struct {
-	void (*mac_indicate)(int);
-} wilc_wlan_indicate_func_t;
 #define WILC_MAC_INDICATE_STATUS	0x1
 #define WILC_MAC_STATUS_INIT		-1
 #define WILC_MAC_STATUS_READY		0
@@ -139,7 +136,6 @@ typedef struct {
 	wilc_wlan_os_func_t os_func;
 	wilc_wlan_io_func_t io_func;
 	wilc_wlan_net_func_t net_func;
-	wilc_wlan_indicate_func_t indicate_func;
 } wilc_wlan_inp_t;
 
 struct tx_complete_data {
-- 
1.9.1

