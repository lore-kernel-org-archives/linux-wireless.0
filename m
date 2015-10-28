Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42926 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbbJ1HEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:04:38 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 53/80] staging: wilc1000: rename u8LinkSpeed of struct rf_info
Date: Wed, 28 Oct 2015 16:06:58 +0900
Message-ID: <1446016045-32154-3-git-send-email-glen.lee@atmel.com> (sfid-20151028_080441_104754_038F1D8C)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8LinkSpeed of struct rf_info to link_speed
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 357f68d..a835016 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2139,7 +2139,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u8LinkSpeed;
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->link_speed;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_RSSI;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9de0267..941b8d9 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -53,7 +53,7 @@
 #define NUM_CONCURRENT_IFC			2
 
 struct rf_info {
-	u8 u8LinkSpeed;
+	u8 link_speed;
 	s8 s8RSSI;
 	u32 u32TxCount;
 	u32 u32RxCount;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bf7a2a2..2c12887 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1570,11 +1570,12 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		sinfo->rx_packets   =  strStatistics.u32RxCount;
 		sinfo->tx_packets   =  strStatistics.u32TxCount + strStatistics.u32TxFailureCount;
 		sinfo->tx_failed	=  strStatistics.u32TxFailureCount;
-		sinfo->txrate.legacy = strStatistics.u8LinkSpeed * 10;
+		sinfo->txrate.legacy = strStatistics.link_speed * 10;
 
-		if ((strStatistics.u8LinkSpeed > TCP_ACK_FILTER_LINK_SPEED_THRESH) && (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED))
+		if ((strStatistics.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH) &&
+		    (strStatistics.link_speed != DEFAULT_LINK_SPEED))
 			Enable_TCP_ACK_Filter(true);
-		else if (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)
+		else if (strStatistics.link_speed != DEFAULT_LINK_SPEED)
 			Enable_TCP_ACK_Filter(false);
 
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
-- 
1.9.1

