Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56999 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHVPJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 11:09:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 5/8] ath9k: Add a config option for channel context
Date: Fri, 22 Aug 2014 20:39:28 +0530
Message-Id: <1408720171-9765-6-git-send-email-sujith@msujith.org> (sfid-20140822_170954_610150_CFA02022)
In-Reply-To: <1408720171-9765-1-git-send-email-sujith@msujith.org>
References: <1408720171-9765-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Channel contexts are supported only for P2P right now,
so make sure that the 'normal' path remains unaffected
by using a config option. This will also reduce the size
of the driver.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 8fcc029..b8f570e 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -130,6 +130,15 @@ config ATH9K_RFKILL
 	  seconds. Turn off to save power, but enable it if you have
 	  a platform that can toggle the RF-Kill GPIO.
 
+config ATH9K_CHANNEL_CONTEXT
+       bool "Channel Context support"
+       depends on ATH9K
+       default n
+       ---help---
+         This option enables channel context support in ath9k, which is needed
+	 for multi-channel concurrency. Enable this if P2P PowerSave support
+	 is required.
+
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
        depends on USB && MAC80211
-- 
2.0.4

