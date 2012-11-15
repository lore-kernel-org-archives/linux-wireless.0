Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2KOXEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 18:04:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Bing Zhao <bzhao@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mwifiex: don't select lib80211
Date: Fri, 16 Nov 2012 00:05:20 +0100
Message-Id: <1353020720-5228-1-git-send-email-johannes@sipsolutions.net> (sfid-20121116_000453_521693_20D2F52C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver doesn't use any lib80211 symbols
so it shouldn't select it in Kconfig.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 8e384fa..b2e2772 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -1,7 +1,6 @@
 config MWIFIEX
 	tristate "Marvell WiFi-Ex Driver"
 	depends on CFG80211
-	select LIB80211
 	---help---
 	  This adds support for wireless adapters based on Marvell
 	  802.11n chipsets.
-- 
1.8.0

