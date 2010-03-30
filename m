Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:61283 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab0C3Vuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:50:35 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, <users@rt2x00.serialmonkey.com>,
	<linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/4] rt2x00: Add wakeup interrupt handler to rt2800pci.
Date: Tue, 30 Mar 2010 23:50:26 +0200
Message-Id: <1269985826-17438-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to wake up the device automatically for receiving beacons,
and is required for proper powersave handling.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 91cce2d..357873c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1006,6 +1006,14 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
+{
+	struct ieee80211_conf conf = { .flags = 0 };
+	struct rt2x00lib_conf libconf = { .conf = &conf };
+
+	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
+}
+
 static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
@@ -1030,6 +1038,9 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
 		rt2800pci_txdone(rt2x00dev);
 
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
+		rt2800pci_wakeup(rt2x00dev);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.7.0.3

