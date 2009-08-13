Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbZHMTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:50 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"Johannes Berg\"" <johannes@sipsolutions.net>
Subject: [PATCH 17/20] wireless: move mac80211_hwsim to top level wireless driver menu
Date: Thu, 13 Aug 2009 15:31:46 -0400
Message-Id: <1250191909-21682-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim is not a device driver for real hardware it is a
driver we can use to simulate a real device for testing mac80211.
Move it to the top wireless driver menu by removing its dependency
on WLAN_80211.

While at it move it outside of the WLAN_80211 section as we'll
be touching all those later.

Cc: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg" <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 513739a..b9a8fbd 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -585,9 +585,12 @@ config ADM8211
 
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
+source "drivers/net/wireless/hostap/Kconfig"
+source "drivers/net/wireless/orinoco/Kconfig"
+
 config MAC80211_HWSIM
 	tristate "Simulated radio testing tool for mac80211"
-	depends on MAC80211 && WLAN_80211
+	depends on MAC80211
 	---help---
 	  This driver is a developer testing tool that can be used to test
 	  IEEE 802.11 networking stack (mac80211) functionality. This is not
@@ -598,7 +601,4 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-source "drivers/net/wireless/hostap/Kconfig"
-source "drivers/net/wireless/orinoco/Kconfig"
-
 endmenu
-- 
1.6.2.5

