Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbYEECYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:18 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Jason Riedy <jason@acm.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 12/25] iwlwifi: Allow building iwl3945 without iwl4965.
Date: Mon,  5 May 2008 10:22:39 +0800
Message-Id: <1209954172-3092-13-git-send-email-yi.zhu@intel.com> (sfid-20080505_044418_253166_98890C9C)
In-Reply-To: <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Riedy <jason@acm.org>

iwlwifi: Allow building iwl3945 without iwl4965.

If IWL3945 ever depends on IWLCORE, the silent, user-invisible
IWLWIFI option can go away.

Signed-off-by: Jason Riedy <jason@acm.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/wireless/Makefile        |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 41eb08e..5026268 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -58,7 +58,7 @@ obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
 obj-$(CONFIG_ADM8211)	+= adm8211.o
 
-obj-$(CONFIG_IWLCORE)	+= iwlwifi/
+obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_P54_COMMON)	+= p54/
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7b9cfea..991ffc8 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,6 +1,11 @@
+config IWLWIFI
+	bool
+	default n
+
 config IWLCORE
 	tristate "Intel Wireless Wifi Core"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select IWLWIFI
 
 config IWLWIFI_LEDS
 	bool
@@ -132,6 +137,7 @@ config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
+	select IWLWIFI
 	---help---
 	  Select to build the driver supporting the:
 
-- 
1.5.3.6

