Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/20] wireless: group intel wireless drivers on kconfig
Date: Thu, 13 Aug 2009 15:31:30 -0400
Message-Id: <1250191909-21682-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves intel wireless drivers into their own menu.

Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index dda7cc2..92bb407 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -493,10 +493,21 @@ config MWL8K
 	  To compile this driver as a module, choose M here: the module
 	  will be called mwl8k.  If unsure, say N.
 
-source "drivers/net/wireless/p54/Kconfig"
-source "drivers/net/wireless/ath/Kconfig"
+menuconfig INTEL_80211
+	bool "Intel Wireless Cards"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Intel wireless drivers. This
+	  includes ipw2100, ipw2200, iwl3945, iwlagn, and iwmc3200wifi
+
+if INTEL_80211
 source "drivers/net/wireless/ipw2x00/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
+source "drivers/net/wireless/iwmc3200wifi/Kconfig"
+endif # INTEL_80211
+
+source "drivers/net/wireless/p54/Kconfig"
+source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
@@ -504,6 +515,5 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
-source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 
 endmenu
-- 
1.6.2.5

