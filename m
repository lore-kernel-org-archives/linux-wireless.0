Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37096 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 37/73] staging: wilc1000: rename is_TCP_ACK_Filter_Enabled function
Date: Fri, 6 Nov 2015 11:12:58 +0900
Message-ID: <1446776014-28094-37-git-send-email-glen.lee@atmel.com> (sfid-20151106_033756_058960_213A180B)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the is_TCP_ACK_Filter_Enabled function to
is_tcp_ack_filter_enabled to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 53c5804..78a4359 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -396,7 +396,7 @@ void enable_tcp_ack_filter(bool value)
 	enabled = value;
 }
 
-bool is_TCP_ACK_Filter_Enabled(void)
+bool is_tcp_ack_filter_enabled(void)
 {
 	return enabled;
 }
@@ -456,7 +456,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
 #ifdef TCP_ACK_FILTER
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
-	if (is_TCP_ACK_Filter_Enabled())
+	if (is_tcp_ack_filter_enabled())
 		tcp_process(dev, tqe);
 #endif
 	wilc_wlan_txq_add_to_tail(dev, tqe);
-- 
1.9.1

