Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63809 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaEORFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:33 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so10179802wib.6
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:31 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/24] iwlwifi: fix LED support Kconfig dependencies
Date: Thu, 15 May 2014 20:04:41 +0300
Message-Id: <1400173481-9047-24-git-send-email-egrumbach@gmail.com> (sfid-20140515_190558_037272_A4A08F22)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If DVM or MVM are built-in but LEDS_CLASS isn't then the current
Kconfig will enable LED support and fail the build. Fix this by
making the LED support depend on LEDS_CLASS being built-in or,
if it is modular, only enabling it if iwlwifi also is.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index d216509..7fd5042 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -42,7 +42,7 @@ config IWLWIFI
 config IWLWIFI_LEDS
 	bool
 	depends on IWLWIFI
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 	default y
-- 
1.8.3.2

