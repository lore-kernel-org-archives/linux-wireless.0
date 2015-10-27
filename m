Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58398 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbbJ0J1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:27:03 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 20/27] staging: wilc1000: frmw_to_linux: add argument struct wilc
Date: Tue, 27 Oct 2015 18:27:56 +0900
Message-ID: <1445938083-20445-20-git-send-email-glen.lee@atmel.com> (sfid-20151027_102706_752026_9CA99544)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of
g_linux_wlan. Pass argument wilc to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d193af8..6293410 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1557,7 +1557,7 @@ done:
 	return s32Error;
 }
 
-void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
+void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 {
 
 	unsigned int frame_len = 0;
@@ -1586,8 +1586,8 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 			return;
 		}
 
-		if (g_linux_wlan == NULL || wilc_netdev == NULL)
-			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
+		if (wilc == NULL || wilc_netdev == NULL)
+			PRINT_ER("wilc_netdev in wilc is NULL");
 		skb->dev = wilc_netdev;
 
 		if (skb->dev == NULL)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8ba69ee..bca3e25 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -208,7 +208,7 @@ struct WILC_WFI_mon_priv {
 
 extern struct wilc *g_linux_wlan;
 extern struct net_device *WILC_WFI_devs[];
-void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
+void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 1461b61..35c4c32d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1184,7 +1184,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
-						frmw_to_linux(&buffer[offset],
+						frmw_to_linux(wilc,
+							      &buffer[offset],
 							      pkt_len,
 							      pkt_offset);
 						has_packet = 1;
-- 
1.9.1

