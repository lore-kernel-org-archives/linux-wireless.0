Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/20] wireless: group Atmel wireless together on kconfig
Date: Thu, 13 Aug 2009 15:31:40 -0400
Message-Id: <1250191909-21682-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 1a8e9bd..694b632 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -213,6 +213,14 @@ config AIRO
 
 	  The driver can be compiled as a module and will be named "airo".
 
+menuconfig ATMEL_80211
+	bool "Atmel Wireless Cards"
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

