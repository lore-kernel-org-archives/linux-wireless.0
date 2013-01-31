Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42954 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3AaJ1E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:04 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 1/6] ath9k: Select RELAY for ATH9K_DEBUGFS
Date: Thu, 31 Jan 2013 10:26:44 +0100
Message-Id: <1359624409-14815-1-git-send-email-sven@narfation.org> (sfid-20130131_102708_962304_4E760E9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The spectral scan support activated through ATH9K_DEBUGFS depends on RELAY for
the kernel->userspace communication. Not activating RELAY causes build
failures.

The RELAY is added as select instead of depend to do it similar like
the only other user of RELAY: BLK_DEV_IO_TRACE

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 7647ed6..17507dc 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -58,6 +58,7 @@ config ATH9K_DEBUGFS
 	bool "Atheros ath9k debugging"
 	depends on ATH9K
 	select MAC80211_DEBUGFS
+	select RELAY
 	---help---
 	  Say Y, if you need access to ath9k's statistics for
 	  interrupts, rate control, etc.
-- 
1.7.10.4

