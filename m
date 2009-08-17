Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbZHQR1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 14/33] wireless: group Cisco together on kconfig
Date: Mon, 17 Aug 2009 13:27:13 -0400
Message-Id: <1250530052-14783-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's only a few of these so we keep them under
a config option which expands upon selection.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index b03035f..8675f3d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -195,6 +195,16 @@ config MWL8K
 
 endif # MARVELL_80211
 
+config CISCO_80211
+	bool "Cisco"
+	depends on WLAN_80211
+	---help---
+	  This will enable the support for Cisco wireless drivers. This
+	  includes the Cisco Aironet ISA and PCI drivers and the Cisco
+	  Aironet PCMCIA drivers.
+
+if CISCO_80211
+
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
 	depends on ISA_DMA_API && WLAN_80211 && (PCI || BROKEN)
@@ -233,6 +243,8 @@ config AIRO_CS
 	  and Cisco proprietary API, so both the Linux Wireless Tools and the
 	  Cisco Linux utilities can be used to configure the card.
 
+endif # CISCO_80211
+
 config ATMEL_80211
 	bool "Atmel"
 	depends on WLAN_80211
-- 
1.6.2.5

