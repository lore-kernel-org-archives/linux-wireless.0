Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45597 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFYKRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 06:17:53 -0400
Received: by mail-pa0-f51.google.com with SMTP id hz1so1534177pad.38
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 03:17:53 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id oz7sm4523086pbc.41.2014.06.25.03.17.52
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 25 Jun 2014 03:17:53 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] rsi: Fixed errors and warnings reported by static code analyzers.
Date: Wed, 25 Jun 2014 15:47:45 +0530
Message-Id: <1403691465-4968-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140625_121756_615048_05379335)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a potential buffer overflow in 'rsi_rates' and a sparse warning
related to difference in endianness in rsi_91x_mgmt.c.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 83abe58..8d110fd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1055,7 +1055,8 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 		rate_table_offset = 4;
 	}
 
-	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
+	for (ii = 0, jj = 0;
+	     ii < (ARRAY_SIZE(rsi_rates) - rate_table_offset); ii++) {
 		if (rate_bitmap & BIT(ii)) {
 			selected_rates[jj++] =
 			(rsi_rates[ii + rate_table_offset].bitrate / 5);
@@ -1103,7 +1104,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	}
 
 	for (; ii < RSI_TBL_SZ; ii++)
-		auto_rate->supported_rates[ii] = min_rate;
+		auto_rate->supported_rates[ii] = cpu_to_le16(min_rate);
 
 	auto_rate->num_supported_rates = cpu_to_le16(num_supported_rates * 2);
 	auto_rate->moderate_rate_inx = cpu_to_le16(num_supported_rates / 2);
-- 
1.7.1

