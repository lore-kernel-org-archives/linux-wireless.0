Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:54305
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2LTDIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 22:08:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] ath9k: Fix compilation breakage
Date: Thu, 20 Dec 2012 08:38:00 +0530
Message-Id: <1355972880-30671-1-git-send-email-sujith@msujith.org> (sfid-20121220_040852_959332_2BD12BF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since ath9k makes use of mac80211's debugfs hooks to
maintain station statistics, make ATH9K_DEBUGFS
select MAC80211_DEBUGFS. This fixes the issue reported by
Fengguang Wu:

drivers/net/wireless/ath/ath9k/debug.c: In function 'ath9k_sta_add_debugfs':
drivers/net/wireless/ath/ath9k/debug.c:1589:4: error: 'struct ath_node' has no member named 'node_stat'
drivers/net/wireless/ath/ath9k/debug.c: In function 'ath9k_sta_remove_debugfs':
drivers/net/wireless/ath/ath9k/debug.c:1599:19: error: 'struct ath_node' has no member named 'node_stat'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 5fc15bf..581913e 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -56,7 +56,8 @@ config ATH9K_AHB
 
 config ATH9K_DEBUGFS
 	bool "Atheros ath9k debugging"
-	depends on ATH9K && DEBUG_FS
+	depends on ATH9K
+	select MAC80211_DEBUGFS
 	---help---
 	  Say Y, if you need access to ath9k's statistics for
 	  interrupts, rate control, etc.
-- 
1.8.0.2

