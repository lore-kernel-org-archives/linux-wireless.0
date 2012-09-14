Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62514 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab2INPpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 11:45:10 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <mcgrof@do-not-panic.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] compat-driver: Add crap patch to avoid regression
Date: Fri, 14 Sep 2012 21:11:02 +0530
Message-ID: <1347637262-27782-4-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120914_174514_773338_91D92308)
In-Reply-To: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix patch ath9k_hw: apply XLNA bias settings from EEPROM
is not cherry picked to avoid regression issues.
This patch adds few macros defined in above patch to avoid
compilation issues.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ..._hw-add-macros-to-avoid-compilation-error.patch |   26 ++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 crap/0004-ath9k_hw-add-macros-to-avoid-compilation-error.patch

diff --git a/crap/0004-ath9k_hw-add-macros-to-avoid-compilation-error.patch b/crap/0004-ath9k_hw-add-macros-to-avoid-compilation-error.patch
new file mode 100644
index 0000000..09bcb17
--- /dev/null
+++ b/crap/0004-ath9k_hw-add-macros-to-avoid-compilation-error.patch
@@ -0,0 +1,26 @@
+From 4a74a46a0628d8187dc310f0f90aea950ea84a7b Mon Sep 17 00:00:00 2001
+From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Date: Fri, 14 Sep 2012 20:10:36 +0530
+Subject: [PATCH] ath9k_hw: add macros for CH1 & CH2
+
+Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h | 2 ++
+ 1 file changed, 2 insertions(+)
+
+diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+index 7268a48..547e785 100644
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -633,6 +633,8 @@
+ #define AR_PHY_65NM_CH0_BIAS2       0x160c4
+ #define AR_PHY_65NM_CH0_BIAS4       0x160cc
+ #define AR_PHY_65NM_CH0_RXTX4       0x1610c
++#define AR_PHY_65NM_CH1_RXTX4       0x1650c
++#define AR_PHY_65NM_CH2_RXTX4       0x1690c
+ 
+ #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
+ 				((AR_SREV_9462(ah) ? 0x1628c : 0x16280)))
+-- 
+1.7.11.4
+
-- 
1.7.4.1

