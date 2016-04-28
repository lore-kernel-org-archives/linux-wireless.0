Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35880 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbcD1OqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 10:46:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id w143so24033344wmw.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2016 07:46:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/3] ath9k: Move TX99 config option under ath9k debugging
Date: Thu, 28 Apr 2016 16:45:05 +0200
Message-Id: <1461854706-10494-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20160428_164610_166146_D8E7523E)
In-Reply-To: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com>
References: <1461854706-10494-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ATH9K_TX99 depends on ATH9K_DEBUGFS anyway move it there
such that "make menuconfig" will indent TX99 support below ath9k
debugging.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 40fa915..f68cb00 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -75,6 +75,26 @@ config ATH9K_STATION_STATISTICS
 	---help---
 	  This option enables detailed statistics for association stations.
 
+config ATH9K_TX99
+	bool "Atheros ath9k TX99 testing support"
+	depends on ATH9K_DEBUGFS && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  Say N. This should only be enabled on systems undergoing
+	  certification testing and evaluation in a controlled environment.
+	  Enabling this will only enable TX99 support, all other modes of
+	  operation will be disabled.
+
+	  TX99 support enables Specific Absorption Rate (SAR) testing.
+	  SAR is the unit of measurement for the amount of radio frequency(RF)
+	  absorbed by the body when using a wireless device. The RF exposure
+	  limits used are expressed in the terms of SAR, which is a measure
+	  of the electric and magnetic field strength and power density for
+	  transmitters operating at frequencies from 300 kHz to 100 GHz.
+	  Regulatory bodies around the world require that wireless device
+	  be evaluated to meet the RF exposure limits set forth in the
+	  governmental SAR regulations.
+
 config ATH9K_DFS_CERTIFIED
 	bool "Atheros DFS support for certified platforms"
 	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
@@ -103,26 +123,6 @@ config ATH9K_DYNACK
 	  based on ACK frame RX timestamp, TX frame timestamp and frame
 	  duration
 
-config ATH9K_TX99
-	bool "Atheros ath9k TX99 testing support"
-	depends on ATH9K_DEBUGFS && CFG80211_CERTIFICATION_ONUS
-	default n
-	---help---
-	  Say N. This should only be enabled on systems undergoing
-	  certification testing and evaluation in a controlled environment.
-	  Enabling this will only enable TX99 support, all other modes of
-	  operation will be disabled.
-
-	  TX99 support enables Specific Absorption Rate (SAR) testing.
-	  SAR is the unit of measurement for the amount of radio frequency(RF)
-	  absorbed by the body when using a wireless device. The RF exposure
-	  limits used are expressed in the terms of SAR, which is a measure
-	  of the electric and magnetic field strength and power density for
-	  transmitters operating at frequencies from 300 kHz to 100 GHz.
-	  Regulatory bodies around the world require that wireless device
-	  be evaluated to meet the RF exposure limits set forth in the
-	  governmental SAR regulations.
-
 config ATH9K_WOW
 	bool "Wake on Wireless LAN support (EXPERIMENTAL)"
 	depends on ATH9K && PM
-- 
2.8.1

