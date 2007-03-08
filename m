Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2121 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbXCHECc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 23:02:32 -0500
Date: Wed, 7 Mar 2007 22:30:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream-fixes' branch of wireless-2.6
Message-ID: <20070308033022.GA19886@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 08e15e81a40e3241ce93b4a43886f3abda184aa6:
  Linus Torvalds (1):
        Linux 2.6.21-rc3

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes

Joerg Sommer (1):
      bcm43xx: Fix bug in frequency to channel conversion

Larry Finger (1):
      bcm43xx: Fix errors in specs to code translation in B6PHY init

Pavel Roskin (1):
      bcm43xx: Fix assertion failures in interrupt handler

 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    6 +++---
 drivers/net/wireless/bcm43xx/bcm43xx_phy.c  |   10 ++++++++--
 drivers/net/wireless/bcm43xx/bcm43xx_wx.c   |   10 ++++++++--
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index e594af4..80cb88e 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1858,9 +1858,6 @@ static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
 
 	spin_lock(&bcm->irq_lock);
 
-	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
-	assert(bcm->current_core->id == BCM43xx_COREID_80211);
-
 	reason = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
 	if (reason == 0xffffffff) {
 		/* irq not for us (shared irq) */
@@ -1871,6 +1868,9 @@ static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
 	if (!reason)
 		goto out;
 
+	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
+	assert(bcm->current_core->id == BCM43xx_COREID_80211);
+
 	bcm->dma_reason[0] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA0_REASON)
 			     & 0x0001DC00;
 	bcm->dma_reason[1] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA1_REASON)
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index 3a5c9c2..cae8925 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -859,6 +859,11 @@ static void bcm43xx_phy_initb6(struct bcm43xx_private *bcm)
 		bcm43xx_radio_write16(bcm, 0x005D, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x005E, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x007D, 0x0088);
+		bcm43xx_shm_write32(bcm, BCM43xx_SHM_SHARED,
+				    BCM43xx_UCODEFLAGS_OFFSET,
+				    (bcm43xx_shm_read32(bcm, BCM43xx_SHM_SHARED,
+				    BCM43xx_UCODEFLAGS_OFFSET)
+				    | 0x00000200));
 	}
 	if (radio->revision == 8) {
 		bcm43xx_radio_write16(bcm, 0x0051, 0x0000);
@@ -941,7 +946,8 @@ static void bcm43xx_phy_initb6(struct bcm43xx_private *bcm)
 	bcm43xx_phy_write(bcm, 0x0038, 0x0668);
 	bcm43xx_radio_set_txpower_bg(bcm, 0xFFFF, 0xFFFF, 0xFFFF);
 	if (radio->revision <= 5)
-		bcm43xx_phy_write(bcm, 0x005D, bcm43xx_phy_read(bcm, 0x005D) | 0x0003);
+		bcm43xx_phy_write(bcm, 0x005D, (bcm43xx_phy_read(bcm, 0x005D)
+			          & 0xFF80) | 0x0003);
 	if (radio->revision <= 2)
 		bcm43xx_radio_write16(bcm, 0x005D, 0x000D);
 	
@@ -958,7 +964,7 @@ static void bcm43xx_phy_initb6(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x0016, 0x0410);
 		bcm43xx_phy_write(bcm, 0x0017, 0x0820);
 		bcm43xx_phy_write(bcm, 0x0062, 0x0007);
-		(void) bcm43xx_radio_calibrationvalue(bcm);
+		bcm43xx_radio_init2050(bcm);
 		bcm43xx_phy_lo_g_measure(bcm);
 		if (bcm->sprom.boardflags & BCM43xx_BFL_RSSI) {
 			bcm43xx_calc_nrssi_slope(bcm);
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
index 7b665e2..d6d9413 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -105,18 +105,24 @@ static int bcm43xx_wx_set_channelfreq(struct net_device *net_dev,
 	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
 	unsigned long flags;
 	u8 channel;
+	s8 expon;
 	int freq;
 	int err = -EINVAL;
 
 	mutex_lock(&bcm->mutex);
 	spin_lock_irqsave(&bcm->irq_lock, flags);
 
-	if ((data->freq.m >= 0) && (data->freq.m <= 1000)) {
+	if ((data->freq.e == 0) &&
+	    (data->freq.m >= 0) && (data->freq.m <= 1000)) {
 		channel = data->freq.m;
 		freq = bcm43xx_channel_to_freq(bcm, channel);
 	} else {
-		channel = bcm43xx_freq_to_channel(bcm, data->freq.m);
 		freq = data->freq.m;
+		expon = 6 - data->freq.e;
+		while (--expon >= 0)    /* scale down the frequency to MHz */
+			freq /= 10;
+		assert(freq > 1000);
+		channel = bcm43xx_freq_to_channel(bcm, freq);
 	}
 	if (!ieee80211_is_valid_channel(bcm->ieee, channel))
 		goto out_unlock;
-- 
John W. Linville
linville@tuxdriver.com
