Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62158 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaIDMww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 08:52:52 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so10027135wgg.8
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 05:52:51 -0700 (PDT)
From: Matteo Croce <matteo@openwrt.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Matteo Croce <matteo@openwrt.org>
Subject: [PATCH] ath10k: ATH10K_DEBUGFS depends on DEBUG_FS
Date: Thu,  4 Sep 2014 14:51:09 +0200
Message-Id: <1409835069-2246-1-git-send-email-matteo@openwrt.org> (sfid-20140904_145305_478992_16E21543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ATH10K_DEBUGFS must depend on DEBUG_FS, otherwise
ath10k will generate an invalid pointer on module load

Signed-off-by: Matteo Croce <matteo@openwrt.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 1053bb5..72acb82 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -24,7 +24,7 @@ config ATH10K_DEBUG
 
 config ATH10K_DEBUGFS
 	bool "Atheros ath10k debugfs support"
-	depends on ATH10K
+	depends on ATH10K && DEBUG_FS
 	select RELAY
 	---help---
 	  Enabled debugfs support
-- 
2.1.0

