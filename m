Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11374 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbbLAJ7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/41] iwlwifi: dvm: remove Kconfig default
Date: Tue,  1 Dec 2015 11:58:29 +0200
Message-Id: <1448963947-24302-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105920_630443_A63EEE6D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The split of iwlwifi into DVM and MVM was a long time ago now,
so we can remove the "default IWLWIFI" that we had to keep all
existing .config files with working defaults during the split.
This is no longer necessary, practically nobody should now be
upgrading a .config that's older than the split.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 6e949df..8660677 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -53,7 +53,7 @@ config IWLWIFI_LEDS
 
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
-	default IWLWIFI
+	depends on m
 	help
 	  This is the driver that supports the DVM firmware. The list
 	  of the devices that use this firmware is available here:
-- 
2.5.0

