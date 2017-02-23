Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45495 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdBWQVH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 11:21:07 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Simon Kelley <simon@thekelleys.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] wireless/atmel: remove time_t usage
Date: Thu, 23 Feb 2017 17:14:45 +0100
Message-Id: <20170223161445.19200-1-alexandre.belloni@free-electrons.com> (sfid-20170223_172143_846726_360B3809)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

last_qual never really holds a time. It only holds jiffies. Make it the
same type as jiffies.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/net/wireless/atmel/atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index e12f62356fd1..27b110dc8cc6 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -513,7 +513,7 @@ struct atmel_private {
 	} station_state;
 
 	int operating_mode, power_mode;
-	time_t last_qual;
+	unsigned long last_qual;
 	int beacons_this_sec;
 	int channel;
 	int reg_domain, config_reg_domain;
-- 
2.11.0
