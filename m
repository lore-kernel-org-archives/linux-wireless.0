Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbZHNAnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2 23/25] wireless: downgrade TI driver from menuconfig to config
Date: Thu, 13 Aug 2009 20:43:02 -0400
Message-Id: <1250210584-13374-24-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few options here so let this expand upon
selection.

Cc: Kalle Valo <kalle.valo@nokia.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 1818e45..78029fd 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,10 +1,12 @@
-menuconfig WL12XX
+config WL12XX
 	boolean "TI wl12xx driver support"
 	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support. The drivers make
 	  use of the mac80211 stack.
 
+if WL12XX
+
 config WL1251
 	tristate "TI wl1251 support"
 	depends on WL12XX && GENERIC_HARDIRQS
@@ -50,3 +52,5 @@ config WL1271
 
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
+
+endif # WL12XX
-- 
1.6.2.5

