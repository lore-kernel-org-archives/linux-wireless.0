Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51797 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbJWF0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:26:41 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/28] staging: wilc1000: linux_wlan_mac_indicate: add argument and use wilc
Date: Fri, 23 Oct 2015 14:28:24 +0900
Message-ID: <1445578124-31486-8-git-send-email-glen.lee@atmel.com> (sfid-20151023_072644_384884_981F6DC0)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds argument wilc and pass the function wilc. Use wilc instead of
g_linux_wlan and pd.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 13 ++++++-------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c          |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3f5ae55..af7e844 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -347,24 +347,23 @@ int linux_wlan_lock_timeout(void *vp, u32 timeout)
 	return error;
 }
 
-void linux_wlan_mac_indicate(int flag)
+void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 {
 	/*I have to do it that way becuase there is no mean to encapsulate device pointer
 	 * as a parameter
 	 */
-	struct wilc *pd = g_linux_wlan;
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
 		wilc_wlan_cfg_get_val(WID_STATUS, (unsigned char *)&status, 4);
-		if (pd->mac_status == WILC_MAC_STATUS_INIT) {
-			pd->mac_status = status;
-			up(&pd->sync_event);
+		if (wilc->mac_status == WILC_MAC_STATUS_INIT) {
+			wilc->mac_status = status;
+			up(&wilc->sync_event);
 		} else {
-			pd->mac_status = status;
+			wilc->mac_status = status;
 		}
 
-		if (pd->mac_status == WILC_MAC_STATUS_CONNECT) {        /* Connect */
+		if (wilc->mac_status == WILC_MAC_STATUS_CONNECT) {        /* Connect */
 		}
 
 	} else if (flag == WILC_MAC_INDICATE_SCAN) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8aa3355..a828fab 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -209,7 +209,7 @@ struct WILC_WFI_mon_priv {
 extern struct wilc *g_linux_wlan;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
-void linux_wlan_mac_indicate(int flag);
+void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4fc88ef..4fa956a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1199,10 +1199,10 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 						/**
 						 *      Call back to indicate status...
 						 **/
-						linux_wlan_mac_indicate(WILC_MAC_INDICATE_STATUS);
+						linux_wlan_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
 
 					} else if (rsp.type == WILC_CFG_RSP_SCAN) {
-						linux_wlan_mac_indicate(WILC_MAC_INDICATE_SCAN);
+						linux_wlan_mac_indicate(wilc, WILC_MAC_INDICATE_SCAN);
 					}
 				}
 			}
-- 
1.9.1

