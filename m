Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbZHQR1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:31 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 12/33] wireless: group Atmel wireless together on kconfig
Date: Mon, 17 Aug 2009 13:27:11 -0400
Message-Id: <1250530052-14783-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few of these so we keep them under a config option
which expands upon selection.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index c557056..b489d9c 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -213,6 +213,14 @@ config AIRO
 
 	  The driver can be compiled as a module and will be named "airo".
 
+config ATMEL_80211
+	bool "Atmel"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Atmel wireless drivers.
+
+if ATMEL_80211
+
 config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
       depends on (PCI || PCMCIA) && WLAN_80211
@@ -255,6 +263,8 @@ config AT76C50X_USB
           Enable support for USB Wireless devices using Atmel at76c503,
           at76c505 or at76c505a chips.
 
+endif # ATMEL_80211
+
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
 	depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
-- 
1.6.2.5

