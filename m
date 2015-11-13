Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35827 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbbKMWAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 17:00:23 -0500
Received: by wmdw130 with SMTP id w130so46163873wmd.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 14:00:22 -0800 (PST)
From: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
Subject: [PATCH] staging: wilc1000: remove new line around else and braces
Date: Fri, 13 Nov 2015 23:59:47 +0200
Message-Id: <1447451987-5447-1-git-send-email-panayiotis.tembriotis@gmail.com> (sfid-20151113_230031_823535_8D838E8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove excess new line characters as suggested by checkpatch.pl:
ERROR: else should follow close brace '}'
ERROR: that open brace { should be on the previous line

Signed-off-by: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c02665747705..9966ac8d7ceb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1056,15 +1056,13 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 				memcpy(&txb[offset], &header, 4);
 				if (tqe->type == WILC_CFG_PKT) {
 					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-				}
-				else if (tqe->type == WILC_NET_PKT) {
+				} else if (tqe->type == WILC_NET_PKT) {
 					char *pBSSID = ((struct tx_complete_data *)(tqe->priv))->pBssid;
 
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 					/* copy the bssid at the sart of the buffer */
 					memcpy(&txb[offset + 4], pBSSID, 6);
-				}
-				else {
+				} else {
 					buffer_offset = HOST_HDR_OFFSET;
 				}
 
@@ -1183,9 +1181,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
 
 				WILC_WFI_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
-			}
-			else
-			{
+			} else {
 
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
-- 
2.6.2

