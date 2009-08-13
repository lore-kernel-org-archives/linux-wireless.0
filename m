Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/20] wireless: group Cisco wireless together on kconfig
Date: Thu, 13 Aug 2009 15:31:42 -0400
Message-Id: <1250191909-21682-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 3be8623..1c74512 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -195,6 +195,16 @@ config MWL8K
 
 endif # MARVELL_80211
 
+menuconfig CISCO_80211
+	bool "Cisco Wireless Cards"
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
 menuconfig ATMEL_80211
 	bool "Atmel Wireless Cards"
 	depends on WLAN_80211
-- 
1.6.2.5

