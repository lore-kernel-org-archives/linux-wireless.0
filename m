Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57893 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1EQHOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:14:06 -0400
Received: by pvg12 with SMTP id 12so109695pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:14:05 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8162.741714.66959@gargle.gargle.HOWL> (sfid-20110517_091410_331660_840E674C)
Date: Tue, 17 May 2011 12:42:34 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 8/8] ath9k_htc: Fix packet timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The WMI tx status event timeout was not aligning with the
TX cleanup timer threshold value. Fix this to handle dropped
packets.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index fa5bb39..e09b20f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -273,9 +273,9 @@ struct ath9k_htc_rx {
 };
 
 #define ATH9K_HTC_TX_CLEANUP_INTERVAL 50 /* ms */
-#define ATH9K_HTC_TX_TIMEOUT_INTERVAL 2500 /* ms */
+#define ATH9K_HTC_TX_TIMEOUT_INTERVAL 3000 /* ms */
 #define ATH9K_HTC_TX_RESERVE 10
-#define ATH9K_HTC_TX_TIMEOUT_COUNT 20
+#define ATH9K_HTC_TX_TIMEOUT_COUNT 40
 #define ATH9K_HTC_TX_THRESHOLD (MAX_TX_BUF_NUM - ATH9K_HTC_TX_RESERVE)
 
 #define ATH9K_HTC_OP_TX_QUEUES_STOP BIT(0)
-- 
1.7.5.1

