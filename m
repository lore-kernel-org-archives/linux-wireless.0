Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22191 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab0KMP2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 10:28:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 07:28:22 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k_htc: Use macro for caldata array size
Date: Sat, 13 Nov 2010 20:58:27 +0530
Message-ID: <1289662107-29613-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The calibration data variable size is based on the number of
channels available in the ath9k driver.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 75ecf6a..db00289 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -368,7 +368,7 @@ struct ath9k_htc_priv {
 	u16 seq_no;
 	u32 bmiss_cnt;
 
-	struct ath9k_hw_cal_data caldata[38];
+	struct ath9k_hw_cal_data caldata[ATH9K_NUM_CHANNELS];
 
 	spinlock_t beacon_lock;
 
-- 
1.7.0.4

