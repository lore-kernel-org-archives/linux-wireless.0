Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43342 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2KFKcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 05:32:01 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 2/2] compat-drivers: Add a next-pending patch.
Date: Tue, 6 Nov 2012 16:01:34 +0530
Message-ID: <1352197894-4352-3-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121106_113211_639943_5CF0CFA1)
In-Reply-To: <1352197894-4352-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1352197894-4352-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...x-signal-strength-noise-measurements-on-a.patch |   28 ++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch

diff --git a/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch b/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
new file mode 100644
index 0000000..727c904
--- /dev/null
+++ b/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
@@ -0,0 +1,28 @@
+From f91a5adf7e8d778f8f006934400249ec9c84717c Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Fri, 2 Nov 2012 16:23:47 +0530
+Subject: [PATCH] ath9k_hw: fix signal strength / noise measurements on ar9462
+
+The nominal noise floor for most channels is -120, though on some it can
+reach -127. Use -120 for converting noise floor to channel noise to
+avoid overestimating rx signal strength and channel noise.
+
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h | 4 ++--
+ 1 file changed, 2 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -332,9 +332,9 @@
+ #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
+ #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
+ 
+-#define AR_PHY_CCA_NOM_VAL_9462_2GHZ          -127
++#define AR_PHY_CCA_NOM_VAL_9462_2GHZ          -120
+ #define AR_PHY_CCA_MIN_GOOD_VAL_9462_2GHZ     -127
+-#define AR_PHY_CCA_NOM_VAL_9462_5GHZ          -127
++#define AR_PHY_CCA_NOM_VAL_9462_5GHZ          -120
+ #define AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ     -127
+ 
+ #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
-- 
1.7.4.1

