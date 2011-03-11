Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40384 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1CKUiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:38:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	vasanth@atheros.com, mark@moxienet.com
Subject: [PATCH v4 1/4] ath9k_hw: fix REG_SET_BIT and REG_CLR_BIT for multiple bits
Date: Fri, 11 Mar 2011 21:38:17 +0100
Message-Id: <1299875900-3180-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ef79f4c..6650fd4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -95,9 +95,9 @@
 #define REG_READ_FIELD(_a, _r, _f) \
 	(((REG_READ(_a, _r) & _f) >> _f##_S))
 #define REG_SET_BIT(_a, _r, _f) \
-	REG_WRITE(_a, _r, REG_READ(_a, _r) | _f)
+	REG_WRITE(_a, _r, REG_READ(_a, _r) | (_f))
 #define REG_CLR_BIT(_a, _r, _f) \
-	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~_f)
+	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~(_f))
 
 #define DO_DELAY(x) do {			\
 		if ((++(x) % 64) == 0)          \
-- 
1.7.3.2

