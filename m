Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43014 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbbJ1HFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:05:01 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 57/80] staging: wilc1000: rename u32TxFailureCount of struct rf_info
Date: Wed, 28 Oct 2015 16:07:02 +0900
Message-ID: <1446016045-32154-7-git-send-email-glen.lee@atmel.com> (sfid-20151028_080510_382919_83B44763)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32TxFailureCount of struct rf_info to tx_fail_cnt
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 2 +-
 drivers/staging/wilc1000/host_interface.h         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b399589..7b41359 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2163,7 +2163,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].id = WID_FAILED_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
 	strWIDList[u32WidsCount].size = sizeof(u32);
-	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->u32TxFailureCount;
+	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
 	u32WidsCount++;
 
 	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e163581..655f59f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -57,7 +57,7 @@ struct rf_info {
 	s8 rssi;
 	u32 tx_cnt;
 	u32 rx_cnt;
-	u32 u32TxFailureCount;
+	u32 tx_fail_cnt;
 };
 
 enum host_if_state {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7388bba..3e1b6b3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1568,8 +1568,8 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		sinfo->signal = strStatistics.rssi;
 		sinfo->rx_packets = strStatistics.rx_cnt;
-		sinfo->tx_packets = strStatistics.tx_cnt + strStatistics.u32TxFailureCount;
-		sinfo->tx_failed	=  strStatistics.u32TxFailureCount;
+		sinfo->tx_packets = strStatistics.tx_cnt + strStatistics.tx_fail_cnt;
+		sinfo->tx_failed = strStatistics.tx_fail_cnt;
 		sinfo->txrate.legacy = strStatistics.link_speed * 10;
 
 		if ((strStatistics.link_speed > TCP_ACK_FILTER_LINK_SPEED_THRESH) &&
-- 
1.9.1

