Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53720 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886AbaIPANX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:23 -0400
Received: by mail-wg0-f43.google.com with SMTP id x12so4605810wgg.26
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:21 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 04/10] ath9k: add config for (en|dis)abling ACK timeout estimation
Date: Tue, 16 Sep 2014 02:13:10 +0200
Message-Id: <1410826396-15544-5-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021341_661378_83412B1F)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ACK timeout estimation algorithm to ath9k Makefile and Kconfig

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  | 9 +++++++++
 drivers/net/wireless/ath/ath9k/Makefile | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index b8f570e..896e632 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -92,6 +92,15 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
+config ATH9K_DYNACK
+	bool "Atheros ath9k ACK timeout estimation algorithm (EXPERIMENTAL)"
+	depends on ATH9K
+	default n
+	---help---
+	  This option enables ath9k dynamic ACK timeout estimation algorithm
+	  based on ACK frame RX timestamp, TX frame timestamp and frame
+	  duration
+
 config ATH9K_TX99
 	bool "Atheros ath9k TX99 testing support"
 	depends on ATH9K_DEBUGFS && CFG80211_CERTIFICATION_ONUS
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

