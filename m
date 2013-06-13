Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59185 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3FMDZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 23:25:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix ANI trigger threshold
Date: Thu, 13 Jun 2013 08:52:09 +0530
Message-Id: <1371093729-24681-1-git-send-email-sujith@msujith.org> (sfid-20130613_052529_692489_A0E2E8D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since raising/lowering the limits based on INI has
been changed, the error limit for OFDM has to be 1000,
not 3500.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index b75aea2..77a06fd 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -20,7 +20,7 @@
 #define BEACON_RSSI(ahp) (ahp->stats.avgbrssi)
 
 /* units are errors per second */
-#define ATH9K_ANI_OFDM_TRIG_HIGH          3500
+#define ATH9K_ANI_OFDM_TRIG_HIGH          1000
 #define ATH9K_ANI_OFDM_TRIG_LOW           400
 #define ATH9K_ANI_CCK_TRIG_HIGH           600
 #define ATH9K_ANI_CCK_TRIG_LOW            300
-- 
1.8.3.1

