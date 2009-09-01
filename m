Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10860 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZIAPWq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:22:46 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:22:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/7] wireless: update top level wireless driver entry
Date: Tue, 1 Sep 2009 08:22:40 -0700
Message-ID: <1251818566-9264-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index dda7cc2..1e45444 100644
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
@@ -506,4 +515,4 @@ source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
 source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 
-endmenu
+endif # WLAN
-- 
1.6.3.3

