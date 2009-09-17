Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21627 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760178AbZIQDzk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:55:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:55:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45889.473020.126495@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:25:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] ath9k: Fix chip wakeup issue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waking up the chip after powering it down fails sometimes.
In this case the CPU is locked for 200ms. Reduce this
interval to 10ms to avoid excessive busy looping.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 75c3041..b892345 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -106,7 +106,7 @@
 #define AH_TSF_WRITE_TIMEOUT        100    /* (us) */
 #define AH_TIME_QUANTUM             10
 #define AR_KEYTABLE_SIZE            128
-#define POWER_UP_TIME               200000
+#define POWER_UP_TIME               10000
 #define SPUR_RSSI_THRESH            40
 
 #define CAB_TIMEOUT_VAL             10
-- 
1.6.4.3

