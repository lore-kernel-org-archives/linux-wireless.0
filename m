Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:29459 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab2DCBlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 21:41:05 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 3/4] rt2800: initialize queues before giving up due to DMA error
Date: Tue,  3 Apr 2012 03:40:49 +0200
Message-Id: <1333417250-24560-4-git-send-email-kubakici@wp.pl> (sfid-20120403_034112_332456_9750A145)
In-Reply-To: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
References: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't immediately abort .start if DMA is busy before we
initialize the queues. Some drivers do not deinitialize
queues properly and we would fail to take over after them.

This behaviour is consistent with legacy driver.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
common/rtmp_init.c:2007
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cc6ca18..bd19802 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -290,7 +290,7 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 		msleep(10);
 	}
 
-	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
+	ERROR(rt2x00dev, "WPDMA TX/RX busy [0x%08x].\n", reg);
 	return -EACCES;
 }
 EXPORT_SYMBOL_GPL(rt2800_wait_wpdma_ready);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index e499389..4366c23 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -496,8 +496,10 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800pci_init_queues(rt2x00dev)))
+	/* Wait for DMA, ignore error until we initialize queues. */
+	rt2800_wait_wpdma_ready(rt2x00dev);
+
+	if (unlikely(rt2800pci_init_queues(rt2x00dev)))
 		return -EIO;
 
 	retval = rt2800_enable_radio(rt2x00dev);
-- 
1.7.7.6

