Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13148 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbJLH7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:59:30 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 27/41] staging: wilc1000: remove typedef from tenuConnDisconnEvent
Date: Mon, 12 Oct 2015 16:56:01 +0900
Message-ID: <1444636575-2486-27-git-send-email-tony.cho@atmel.com> (sfid-20151012_095935_837030_B7E1DD1A)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the enum tenuConnDisconnEvent and
renames it to conn_event.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ad4c1c4..a88fd82 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -160,11 +160,11 @@ enum scan_event {
 	SCAN_EVENT_FORCE_32BIT		= 0xFFFFFFFF
 };
 
-typedef enum {
+enum conn_event {
 	CONN_DISCONN_EVENT_CONN_RESP		= 0,
 	CONN_DISCONN_EVENT_DISCONN_NOTIF	= 1,
 	CONN_DISCONN_EVENT_FORCE_32BIT		= 0xFFFFFFFF
-} tenuConnDisconnEvent;
+};
 
 enum KEY_TYPE {
 	WEP,
@@ -179,7 +179,7 @@ typedef void (*wilc_scan_result)(enum scan_event, tstrNetworkInfo *,
 				  void *, void *);
 
 /*Connect callBack function definition*/
-typedef void (*wilc_connect_result)(tenuConnDisconnEvent,
+typedef void (*wilc_connect_result)(enum conn_event,
 				     tstrConnectInfo *,
 				     u8,
 				     tstrDisconnectNotifInfo *,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 45a10c5..11f9d46 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -531,7 +531,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
  */
 int connecting;
 
-static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
+static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			     tstrConnectInfo *pstrConnectInfo,
 			     u8 u8MacStatus,
 			     tstrDisconnectNotifInfo *pstrDisconnectNotifInfo,
-- 
1.9.1

