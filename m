Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59377 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbbAFMrB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 07:47:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] orinoco/hermes: select CFG80211_WEXT
Date: Tue,  6 Jan 2015 13:46:57 +0100
Message-Id: <1420548417-17650-1-git-send-email-johannes@sipsolutions.net> (sfid-20150106_134705_726093_182565FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It makes no sense to require the user to find and enable
CFG80211_WEXT before the driver can be selected, make the
driver select the needed Kconfig symbol itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/orinoco/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/Kconfig b/drivers/net/wireless/orinoco/Kconfig
index 60698b020851..6d831d4d1b5f 100644
--- a/drivers/net/wireless/orinoco/Kconfig
+++ b/drivers/net/wireless/orinoco/Kconfig
@@ -1,7 +1,8 @@
 config HERMES
 	tristate "Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)"
 	depends on (PPC_PMAC || PCI || PCMCIA)
-	depends on CFG80211 && CFG80211_WEXT
+	depends on CFG80211
+	select CFG80211_WEXT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
-- 
2.1.1

