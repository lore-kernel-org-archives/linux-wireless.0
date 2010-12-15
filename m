Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64252 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0LOPbJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:09 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:30:53 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] ath9k_hw: Move get_streams() to hw.h
Date: Wed, 15 Dec 2010 07:30:49 -0800
Message-ID: <1292427053-5880-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helper can be used in multiple places. Also make
it inline returning u8.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    5 -----
 drivers/net/wireless/ath/ath9k/hw.h           |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 69f7792..4c74479 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -50,11 +50,6 @@ static int ar9003_get_training_power_2g(struct ath_hw *ah)
 	return power;
 }
 
-static int get_streams(int mask)
-{
-	return !!(mask & BIT(0)) + !!(mask & BIT(1)) + !!(mask & BIT(2));
-}
-
 static int ar9003_get_training_power_5g(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 97f22c4..fb64ab8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -868,6 +868,11 @@ static inline struct ath_hw_ops *ath9k_hw_ops(struct ath_hw *ah)
 	return &ah->ops;
 }
 
+static inline u8 get_streams(int mask)
+{
+	return !!(mask & BIT(0)) + !!(mask & BIT(1)) + !!(mask & BIT(2));
+}
+
 /* Initialization, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_deinit(struct ath_hw *ah);
-- 
1.7.0.4

