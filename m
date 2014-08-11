Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48722 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaHKULG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 16:11:06 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: [PATCH 1/2] iwlwifi: Remove module build requirement for Intel Wireless WiFi DVM
Date: Mon, 11 Aug 2014 22:11:35 +0200
Message-Id: <1407787896-52455-1-git-send-email-marcel@holtmann.org> (sfid-20140811_221110_509815_D2F2B8E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CONFIG_IWLDVM currently has a "depends on m" as its requirement
forcing it to be build as module. This is not needed and thus just
remove it.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/net/wireless/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6451d2b6abcf..9cc33e13690b 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -51,7 +51,6 @@ config IWLWIFI_LEDS
 
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
-	depends on m
 	default IWLWIFI
 	help
 	  This is the driver that supports the DVM firmware which is
-- 
1.9.3

