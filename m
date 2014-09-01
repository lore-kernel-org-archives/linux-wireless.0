Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50424 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaIAHM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:12:59 -0400
Received: by mail-wi0-f178.google.com with SMTP id r20so5489236wiv.11
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 00:12:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] iwlwifi: Remove module build requirement for Intel Wireless WiFi
Date: Mon,  1 Sep 2014 10:12:49 +0300
Message-Id: <1409555570-18567-2-git-send-email-egrumbach@gmail.com> (sfid-20140901_091304_352653_5E0EF5BF)
In-Reply-To: <54041C13.7000905@gmail.com>
References: <54041C13.7000905@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcel Holtmann <marcel@holtmann.org>

The CONFIG_IWLDVM and CONFIG_IWLMVM currently have a
"depends on m" as its requirement forcing it to be build
as module. This is not needed and thus just remove it.

Fixes: ae7486a2b734 ("iwlwifi: fix Kconfig issues")
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
[Squashed 2 commites for MVM and DVM]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6451d2b..824f5e2 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -51,7 +51,6 @@ config IWLWIFI_LEDS
 
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
-	depends on m
 	default IWLWIFI
 	help
 	  This is the driver that supports the DVM firmware which is
@@ -60,7 +59,6 @@ config IWLDVM
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
-	depends on m
 	help
 	  This is the driver that supports the MVM firmware which is
 	  currently only available for 7260 and 3160 devices.
-- 
1.9.1

