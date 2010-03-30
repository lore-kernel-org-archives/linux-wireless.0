Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:56125 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094Ab0C3Vug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:50:36 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, <users@rt2x00.serialmonkey.com>,
	<linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/4] rt2x00: Add wakeup interrupt handler to rt61pci.
Date: Tue, 30 Mar 2010 23:50:25 +0200
Message-Id: <1269985826-17438-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to wake up the device automatically for receiving beacons,
and is required for proper powersave handling.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index e2da928..ac69dbe 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2117,6 +2117,14 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
+{
+	struct ieee80211_conf conf = { .flags = 0 };
+	struct rt2x00lib_conf libconf = { .conf = &conf };
+
+	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
+}
+
 static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
@@ -2164,6 +2172,12 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 		rt2x00pci_register_write(rt2x00dev,
 					 M2H_CMD_DONE_CSR, 0xffffffff);
 
+	/*
+	 * 4 - MCU Autowakeup interrupt.
+	 */
+	if (rt2x00_get_field32(reg_mcu, MCU_INT_SOURCE_CSR_TWAKEUP))
+		rt61pci_wakeup(rt2x00dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.7.0.3

