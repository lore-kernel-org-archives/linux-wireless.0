Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZHNU1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:27:35 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Buesch <mb@bu3sch.de>,
	=?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 10/34] wireless: group Broadcom drivers on kconfig
Date: Fri, 14 Aug 2009 16:25:35 -0400
Message-Id: <1250281559-13041-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
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
index c2e88dc..150565d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -561,8 +561,21 @@ source "drivers/net/wireless/iwmc3200wifi/Kconfig"
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

