Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0LAHf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:35:26 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:35:12 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 23/26] ath9k_hw: Program appropriate register for temperature compensation cal for AR9485
Date: Tue, 30 Nov 2010 23:32:52 -0800
Message-ID: <1291188775-13707-24-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 74e0da9..00cd3e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -586,7 +586,7 @@
 #define AR_PHY_65NM_CH0_BIAS2       0x160c4
 #define AR_PHY_65NM_CH0_BIAS4       0x160cc
 #define AR_PHY_65NM_CH0_RXTX4       0x1610c
-#define AR_PHY_65NM_CH0_THERM       0x16290
+#define AR_PHY_65NM_CH0_THERM       (AR_SREV_9485(ah) ? 0x1628c : 0x16290)
 
 #define AR_PHY_65NM_CH0_THERM_LOCAL   0x80000000
 #define AR_PHY_65NM_CH0_THERM_LOCAL_S 31
-- 
1.7.0.4

