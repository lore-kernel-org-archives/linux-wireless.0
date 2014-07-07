Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48937 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaGGJbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:53 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so1408579wgh.12
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 04/10] ath9k: add config for (en|dis)abling ack timeout estimation
Date: Mon,  7 Jul 2014 11:31:40 +0200
Message-Id: <1404725506-9571-5-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113201_358760_4517B09A)
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ack timeout estimation to ath9k Makefile

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  | 7 +++++++
 drivers/net/wireless/ath/ath9k/Makefile | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 8fcc029..ee61a4c 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -151,3 +151,10 @@ config ATH9K_HTC_DEBUGFS
 	depends on ATH9K_HTC && DEBUG_FS
 	---help---
 	  Say Y, if you need access to ath9k_htc's statistics.
+
+config ATH9K_DYNACK
+	bool "Atheros ath9k ack timeout estimation algorithm (EXPERIMENTAL)"
+	depends on ATH9K
+	default n
+	---help---
+	  This option enables ath9k dynamic ack timeout estimation algorithm
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 6b4020a..73704c1 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -49,6 +49,9 @@ ath9k_hw-$(CONFIG_ATH9K_WOW) += ar9003_wow.o
 
 ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
 					   ar9003_mci.o
+
+ath9k_hw-$(CONFIG_ATH9K_DYNACK) += dynack.o
+
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
 obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
-- 
1.9.1

