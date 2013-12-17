Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54503 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3LQQeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 11:34:02 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so3008424eek.8
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 08:34:00 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: add DFS_CERTIFIED option
Date: Tue, 17 Dec 2013 17:33:45 +0100
Message-Id: <1387298026-2599-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131217_173411_380320_689B8FFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Kconfig option that allow DFS functionality.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 82e8088..a6f5285 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -37,3 +37,10 @@ config ATH10K_TRACING
 	---help---
 	  Select this to ath10k use tracing infrastructure.
 
+config ATH10K_DFS_CERTIFIED
+	bool "Atheros DFS support for certified platforms"
+	depends on ATH10K && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	This option enables DFS support for initiating radiation on
+	ath10k.
-- 
1.7.9.5

