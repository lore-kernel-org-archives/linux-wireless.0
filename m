Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26962 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314AbbJ2DEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:13 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 40/64] staging: wilc1000: rename u32RxCount of struct rf_info
Date: Thu, 29 Oct 2015 12:05:32 +0900
Message-ID: <1446087956-19054-7-git-send-email-glen.lee@atmel.com> (sfid-20151029_040417_256980_88FDA039)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32RxCount of struct rf_info to rx_cnt
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0d220a8..4f64ee7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2156,7 +2156,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].id = WID_RECEIVED_FRAGMENT_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u32RxCount;
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->rx_cnt;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9d31c4e..d61b9b7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -56,7 +56,7 @@ struct rf_info {
 	u8 link_speed;
 	s8 rssi;
 	u32 tx_cnt;
-	u32 u32RxCount;
+	u32 rx_cnt;
 	u32 u32TxFailureCount;
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 73cec4b..9b7cac3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1567,7 +1567,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 						BIT(NL80211_STA_INFO_TX_BITRATE);
 
 		sinfo->signal = strStatistics.rssi;
-		sinfo->rx_packets   =  strStatistics.u32RxCount;
+		sinfo->rx_packets = strStatistics.rx_cnt;
 		sinfo->tx_packets = strStatistics.tx_cnt + strStatistics.u32TxFailureCount;
 		sinfo->tx_failed	=  strStatistics.u32TxFailureCount;
 		sinfo->txrate.legacy = strStatistics.link_speed * 10;
-- 
1.9.1

