Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab1LIBY7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:24:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/15] iwlwifi: hide kernel option IWLWIFI_DEVICE_SVTOOL
Date: Thu,  8 Dec 2011 16:26:09 -0800
Message-Id: <1323390382-1678-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022510_418759_340B82D0)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Because the testmode support should be the mandatory foundation
of test functionality, it is better to set kernel option
IWLWIFI_DEVICE_SVTOOL automatically instead of user configuration.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 57703d5..855b135 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -103,9 +103,9 @@ config IWLWIFI_DEVICE_TRACING
 endmenu
 
 config IWLWIFI_DEVICE_SVTOOL
-	bool "iwlwifi device svtool support"
+	def_bool y
 	depends on IWLWIFI
-	select NL80211_TESTMODE
+	depends on NL80211_TESTMODE
 	help
 	  This option enables the svtool support for iwlwifi device through
 	  NL80211_TESTMODE. svtool is a software validation tool that runs in
-- 
1.7.0.4

