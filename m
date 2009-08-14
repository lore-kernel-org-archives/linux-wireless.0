Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbZHNAnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Buesch <mb@bu3sch.de>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 10/25] wireless: group Broadcom drivers on kconfig
Date: Thu, 13 Aug 2009 20:42:49 -0400
Message-Id: <1250210584-13374-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves Broadcom wireless drivers into their own menu.
There are only 2 Broadcom specific drivers so we group
them into a menu which can expand. Although rndis_wlan
also supports Broadcom devices, RNDIS is a spec and other
vendors could technically implement solutions with it
as well so we keep that separate as users most likely
won't look for those devices under a Broadcom tag.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Gábor Stefanik <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 6dba711..cb5aae6 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -562,8 +562,21 @@ source "drivers/net/wireless/iwmc3200wifi/Kconfig"
 endif # INTEL_80211
 
 source "drivers/net/wireless/hostap/Kconfig"
+
+config BROADCOM_80211
+	bool "Broadcom"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Broadcom wireless drivers. This
+	  includes b43 driver, b43legacy driver and the rndis_wlan driver.
+
+if BROADCOM_80211
+
 source "drivers/net/wireless/b43/Kconfig"
 source "drivers/net/wireless/b43legacy/Kconfig"
+
+endif # BROADCOM_80211
+
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
-- 
1.6.2.5

