Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbZHNU1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:27:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 09/34] wireless: group Realtek wireless on kconfig
Date: Fri, 14 Aug 2009 16:25:34 -0400
Message-Id: <1250281559-13041-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few of these so we keep them under a config option
which expands upon selection.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index a04ca56..c2e88dc 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -407,6 +407,15 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
+config REALTEK_80211
+	bool "Realtek"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Realtek wireless drivers. This includes
+	  the PCI rtl8180 driver and the USB rtl8187 driver.
+
+if REALTEK_80211
+
 config RTL8180
 	tristate "Realtek 8180/8185 PCI support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
@@ -492,6 +501,8 @@ config RTL8187_LEDS
 	depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = RTL8187)
 	default y
 
+endif # REALTEK_80211
+
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
-- 
1.6.2.5

