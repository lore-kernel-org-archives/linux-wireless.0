Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46621 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZL2H2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 02:28:04 -0500
Received: by fxm25 with SMTP id 25so5051184fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2009 23:28:01 -0800 (PST)
Subject: [PATCH] ath9k: Fix Kconfig depends for ATH9K_DEBUGFS
From: Dominik Geyer <dominik.geyer@gmx.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 08:27:57 +0100
Message-ID: <1262071677.32610.25.camel@pc3800>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing DEBUG_FS dependency for ATH9K_DEBUGFS in ath9k's Kconfig.

Signed-off-by: Dominik D. Geyer <dominik.geyer@gmx.de>
---
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 03a1106..5774cea 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -25,7 +25,7 @@ config ATH9K
 
 config ATH9K_DEBUGFS
 	bool "Atheros ath9k debugging"
-	depends on ATH9K
+	depends on ATH9K && DEBUG_FS
 	---help---
 	  Say Y, if you need access to ath9k's statistics for
 	  interrupts, rate control, etc.

