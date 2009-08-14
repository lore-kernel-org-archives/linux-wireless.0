Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbZHNAnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>,
	Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v2 06/25] wireless: group Conexant / STEricsson drivers in kconfig
Date: Thu, 13 Aug 2009 20:42:45 -0400
Message-Id: <1250210584-13374-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few of these so we keep them under a
config option which expands upon selection.

Cc: Christian Lamparter <chunkeey@web.de>
Cc: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 636c864..babd36e 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -284,6 +284,18 @@ config PCMCIA_WL3501
 	 It has basic support for Linux wireless extensions and initial
 	 micro support for ethtool.
 
+config CONEXANT_ST_80211
+	bool "Intersil / Conexant / STEricsson"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Intersil / Conexant and STEricsson
+	  wireless drivers. All these companies have sell wireless cards which
+	  have shared common parts one way or another. The drivers for these cards
+	  include the mac80211 based p54 drivers for PCI, USB and SPI (Nokia N810
+	  and N800), and and the old PCI FullMAC driver prism54.
+
+if CONEXANT_ST_80211
+
 source "drivers/net/wireless/p54/Kconfig"
 
 config PRISM54
@@ -333,6 +345,8 @@ config PRISM54
 	  say M here and read <file:Documentation/kbuild/modules.txt>.
 	  The module will be called prism54.
 
+endif # CONEXANT_ST_80211
+
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
 	depends on USB && WLAN_80211
-- 
1.6.2.5

