Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48749 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaHKULG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 16:11:06 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: [PATCH 2/2] iwlwifi: Remove module build requirement for Intel Wireless WiFi MVM
Date: Mon, 11 Aug 2014 22:11:36 +0200
Message-Id: <1407787896-52455-2-git-send-email-marcel@holtmann.org> (sfid-20140811_221112_092925_F6B9A40E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CONFIG_IWLMVM currently has a "depends on m" as its requirement
forcing it to be build as module. This is not needed and thus just
remove it.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/net/wireless/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 9cc33e13690b..824f5e287783 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -59,7 +59,6 @@ config IWLDVM
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
-	depends on m
 	help
 	  This is the driver that supports the MVM firmware which is
 	  currently only available for 7260 and 3160 devices.
-- 
1.9.3

