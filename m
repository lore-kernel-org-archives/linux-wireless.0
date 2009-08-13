Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZHMTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:50 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Buesch <mb@bu3sch.de>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 09/20] wireless: move bcm drivers above rndis wlan driver
Date: Thu, 13 Aug 2009 15:31:38 -0400
Message-Id: <1250191909-21682-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Gábor Stefanik <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index e6d2674..65397fe 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -378,6 +378,9 @@ config USB_ZD1201
 
 endif # ZYDAS_80211
 
+source "drivers/net/wireless/b43/Kconfig"
+source "drivers/net/wireless/b43legacy/Kconfig"
+
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB && WLAN_80211 && EXPERIMENTAL
@@ -557,8 +560,6 @@ source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 endif # INTEL_80211
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
-source "drivers/net/wireless/b43/Kconfig"
-source "drivers/net/wireless/b43legacy/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
-- 
1.6.2.5

