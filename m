Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37181 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031481AbbKFCOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 42/73] staging: wilc1000: rename pBSSID variable
Date: Fri, 6 Nov 2015 11:13:03 +0900
Message-ID: <1446776014-28094-42-git-send-email-glen.lee@atmel.com> (sfid-20151106_033759_406035_D9FC2302)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the pBSSID variable to bssid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ec5fc1d..f1bb8af 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -899,10 +899,10 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (tqe->type == WILC_CFG_PKT) {
 					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
 				} else if (tqe->type == WILC_NET_PKT) {
-					char *pBSSID = ((struct tx_complete_data *)(tqe->priv))->pBssid;
+					char *bssid = ((struct tx_complete_data *)(tqe->priv))->pBssid;
 
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
-					memcpy(&txb[offset + 4], pBSSID, 6);
+					memcpy(&txb[offset + 4], bssid, 6);
 				} else {
 					buffer_offset = HOST_HDR_OFFSET;
 				}
-- 
1.9.1

