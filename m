Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37057 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 35/73] staging: wilc1000: rename EnableTCPAckFilter variable
Date: Fri, 6 Nov 2015 11:12:56 +0900
Message-ID: <1446776014-28094-35-git-send-email-glen.lee@atmel.com> (sfid-20151106_033800_975316_A6869E29)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the EnableTCPAckFilter variable to enabled
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 283ab52..0bfd1bd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -389,16 +389,16 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 }
 #endif
 
-bool EnableTCPAckFilter = false;
+bool enabled = false;
 
 void Enable_TCP_ACK_Filter(bool value)
 {
-	EnableTCPAckFilter = value;
+	enabled = value;
 }
 
 bool is_TCP_ACK_Filter_Enabled(void)
 {
-	return EnableTCPAckFilter;
+	return enabled;
 }
 
 static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
-- 
1.9.1

