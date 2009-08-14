Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbZHNU03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:26:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Daniel Drake <dsd@gentoo.org>,
	Stephen Chen <stephen.chen@atheros.com>
Subject: [PATCH v4 08/34] wireless: group ZyDAS wireless drivers in kconfig
Date: Fri, 14 Aug 2009 16:25:33 -0400
Message-Id: <1250281559-13041-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few of these so we keep them under a config option
which expands upon selection.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Stephen Chen <stephen.chen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 9f1b5b6..a04ca56 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -347,6 +347,15 @@ config PRISM54
 
 endif # CONEXANT_ST_80211
 
+config ZYDAS_80211
+	bool "ZyDAS"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for ZyDAS wireless drivers. This includes
+	  the 802.11g zd1211rw usb driver and the older 802.11b zd1201 usb driver.
+
+if ZYDAS_80211
+
 source "drivers/net/wireless/zd1211rw/Kconfig"
 
 config USB_ZD1201
@@ -367,6 +376,8 @@ config USB_ZD1201
 	  To compile this driver as a module, choose M here: the
 	  module will be called zd1201.
 
+endif # ZYDAS_80211
+
 config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB && WLAN_80211 && EXPERIMENTAL
-- 
1.6.2.5

