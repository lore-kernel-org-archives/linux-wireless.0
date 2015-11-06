Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031481AbbKFCOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:35 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 41/73] staging: wilc1000: fixes else should follow close brace '}'
Date: Fri, 6 Nov 2015 11:13:02 +0900
Message-ID: <1446776014-28094-41-git-send-email-glen.lee@atmel.com> (sfid-20151106_033755_684593_4BA72B5E)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the error reported by checkpatch.pl
for else should follow close brace '}'

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index cffd720..ec5fc1d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -898,14 +898,12 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				memcpy(&txb[offset], &header, 4);
 				if (tqe->type == WILC_CFG_PKT) {
 					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-				}
-				else if (tqe->type == WILC_NET_PKT) {
+				} else if (tqe->type == WILC_NET_PKT) {
 					char *pBSSID = ((struct tx_complete_data *)(tqe->priv))->pBssid;
 
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 					memcpy(&txb[offset + 4], pBSSID, 6);
-				}
-				else {
+				} else {
 					buffer_offset = HOST_HDR_OFFSET;
 				}
 
@@ -1008,9 +1006,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
 
 				WILC_WFI_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
-			}
-			else
-			{
+			} else {
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
 						frmw_to_linux(wilc,
-- 
1.9.1

