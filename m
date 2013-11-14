Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50970 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3KNIBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 03:01:34 -0500
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: expand the wmi mgmt queue limit to 128
Date: Thu, 14 Nov 2013 09:01:15 +0100
Message-ID: <1384416075-13751-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20131114_090137_930411_900CBD5F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was obseverd many times the short queue limit can be
easily exceeded in case of AP multiple BSSID scenarios.

"ath10k: wmi mgmt_tx queue limit reached."

This was leading to TX packets drops.

This patch expands the queue limit to 128. After many stress
experiments (high traffic and lot of management frames in
the air) the new value seems to fix the problem on platforms
with limited resources.

Reported-By: Tomasz Skapski <tomasz.skapski@tieto.com>
Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0934f76..be35df2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -43,7 +43,7 @@
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
 
-#define ATH10K_MAX_NUM_MGMT_PENDING 16
+#define ATH10K_MAX_NUM_MGMT_PENDING 128
 
 struct ath10k;
 
-- 
1.7.10

