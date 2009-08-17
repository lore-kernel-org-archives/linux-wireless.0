Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817AbZHQR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:33 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 27/33] wireless: update top level wireless driver entry
Date: Mon, 17 Aug 2009 13:27:26 -0400
Message-Id: <1250530052-14783-28-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change it to a menuconfig to give it some documentation, to
refer users to our wireless wiki for extra resources and
documentation. It seems our wiki is still obscure to some.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index ed9093f..2dab145 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -2,8 +2,17 @@
 # Wireless LAN device configuration
 #
 
-menu "Wireless LAN"
+menuconfig WLAN
+	bool "IEEE 802.11 - Wireless LAN"
 	depends on !S390
+	---help---
+	  This section contains all the pre 802.11 and 802.11 wireless
+	  device drivers. For a complete list of drivers and documentation
+	  on them refer to the wireless wiki:
+
+	  http://wireless.kernel.org/en/users/Drivers
+
+if WLAN
 
 menuconfig WLAN_PRE80211
 	bool "Wireless LAN (pre-802.11)"
@@ -579,4 +588,4 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-endmenu
+endif # WLAN
-- 
1.6.2.5

