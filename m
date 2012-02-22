Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6845 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:12:14 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38212.850086.356517@gargle.gargle.HOWL> (sfid-20120222_081217_814656_71F1F8A9)
Date: Wed, 22 Feb 2012 12:42:04 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 22/26] ath9k: Modify ATH9K_BTCOEX_SUPPORT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ATH9K_BTCOEX_SUPPORT is now used by both ath9k and ath9k_htc
to enable BT coexistence. Fix Kbuild to allow this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index dc6be4a..595a272 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -6,6 +6,14 @@ config ATH9K_DFS_DEBUGFS
 	def_bool y
 	depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED
 
+config ATH9K_BTCOEX_SUPPORT
+	bool "Atheros bluetooth coexistence support"
+	depends on (ATH9K || ATH9K_HTC)
+	default y
+	---help---
+	  Say Y, if you want to use the ath9k/ath9k_htc radios together with
+	  Bluetooth modules in the same system.
+
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211
@@ -81,14 +89,6 @@ config ATH9K_RATE_CONTROL
 	  Say Y, if you want to use the ath9k specific rate control
 	  module instead of minstrel_ht.
 
-config ATH9K_BTCOEX_SUPPORT
-	bool "Atheros ath9k bluetooth coexistence support"
-	depends on ATH9K
-	default y
-	---help---
-	  Say Y, if you want to use the ath9k radios together with
-	  Bluetooth modules in the same system.
-
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
        depends on USB && MAC80211
-- 
1.7.9.1

