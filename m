Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:54234 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761702AbXHAT4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 15:56:07 -0400
Date: Wed, 01 Aug 2007 14:55:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC] bcm43xx-mac80211: Provide information to allow transmission rate decreases
Message-ID: <46b0e53e.ouY931+cZsSSSmLK%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

This version saves the long- and short-retry limits in the phy struct
and only sets excessive retries when one or the other is reached.

Larry
---

In bcm43xx-mac80211, the mechanism for decreasing the transmit rate cannot
be triggered. This may be shown by walking away from the AP with a laptop.
At some distance, communications will be lost and never recovered because
the rate decreasing mechanism of rc80211_simple needs to see excessive_retries
set in the ieee80211_tx_status struct. With this patch, the transmit rate
will decrease until communications restart.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
@@ -1284,6 +1284,7 @@ void bcm43xx_dma_handle_txstatus(struct 
 	struct bcm43xx_dmaring *ring;
 	struct bcm43xx_dmadesc_generic *desc;
 	struct bcm43xx_dmadesc_meta *meta;
+	struct bcm43xx_phy *phy = &dev->phy;
 	int slot;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
@@ -1311,6 +1312,10 @@ void bcm43xx_dma_handle_txstatus(struct 
 			 */
 			if (status->acked)
 				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+			else
+				if ((status->frame_count >= phy->lrlimit) ||
+				    (status->frame_count >= phy->srlimit))
+					meta->txstat.excessive_retries = 1;
 			meta->txstat.retry_count = status->frame_count - 1;
 			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
@@ -562,6 +562,8 @@ struct bcm43xx_phy {
 	u16 lofcal;
 
 	u16 initval;//FIXME rename?
+	u8 srlimit;
+	u8 lrlimit;
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -3333,10 +3333,12 @@ static int bcm43xx_wireless_core_init(st
 	tmp = limit_value(modparam_short_retry, 0, 0xF);
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SCRATCH,
 			    BCM43xx_SHM_SC_SRLIMIT, tmp);
+	phy->srlimit = tmp;
 	tmp = limit_value(modparam_long_retry, 0, 0xF);
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SCRATCH,
 			    BCM43xx_SHM_SC_LRLIMIT, tmp);
 
+	phy->lrlimit = tmp;
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
 			    BCM43xx_SHM_SH_SFFBLIM, 3);
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
