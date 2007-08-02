Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:46298 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXHBPie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:38:34 -0400
Date: Thu, 02 Aug 2007 10:38:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC V3] bcm43xx-mac80211: Provide information to allow  transmission rate decreases
Message-ID: <46b1fa6d.d4l4DujAaAR2ORZf%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I couldn't find any long/short indication in the header, so I added a bool that
is set when the frame is sent.

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
@@ -1311,6 +1311,16 @@ void bcm43xx_dma_handle_txstatus(struct 
 			 */
 			if (status->acked)
 				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+			else
+				if (dev->last_frame_long) {
+					if (status->frame_count >=
+					    dev->long_retry_limit)
+						meta->txstat.excessive_retries = 1;
+				} else {
+					if (status->frame_count >=
+					    dev->short_retry_limit)
+						meta->txstat.excessive_retries = 1;
+				}
 			meta->txstat.retry_count = status->frame_count - 1;
 			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
@@ -707,6 +707,9 @@ struct bcm43xx_wldev {
 	bool short_preamble;		/* TRUE, if short preamble is enabled. */
 	bool short_slot;		/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;		/* saved state of radio hardware enabled state */
+	bool last_frame_long;		/* true is last frame was long */
+	u8 short_retry_limit;
+	u8 long_retry_limit;
 
 	/* PHY/Radio device. */
 	struct bcm43xx_phy phy;
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -3333,10 +3333,12 @@ static int bcm43xx_wireless_core_init(st
 	tmp = limit_value(modparam_short_retry, 0, 0xF);
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SCRATCH,
 			    BCM43xx_SHM_SC_SRLIMIT, tmp);
+	dev->short_retry_limit = tmp;
 	tmp = limit_value(modparam_long_retry, 0, 0xF);
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SCRATCH,
 			    BCM43xx_SHM_SC_LRLIMIT, tmp);
 
+	dev->long_retry_limit = tmp;
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
 			    BCM43xx_SHM_SH_SFFBLIM, 3);
 	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
@@ -264,6 +264,7 @@ static void generate_txhdr_fw4(struct bc
 	 * is a 5Ghz packet.
 	 */
 	txhdr->chan_radio_code = phy->channel;
+	dev->last_frame_long = 0;
 
 	/* PHY TX Control word */
 	if (rate_ofdm)
@@ -336,6 +337,7 @@ static void generate_txhdr_fw4(struct bc
 		if (rts_rate_fb_ofdm)
 			extra_ft |= BCM43xx_TX4_EFT_RTSFBOFDM;
 		mac_ctl |= BCM43xx_TX4_MAC_LONGFRAME;
+		dev->last_frame_long = 1;
 	}
 
 	/* Magic cookie */
