Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63191 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZEFQOr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 12:14:47 -0400
Subject: ath5k: scanning while transmitting causes oops on 802.11a capable
 card
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
Content-Type: text/plain
Date: Wed, 06 May 2009 12:14:46 -0400
Message-Id: <1241626486.30590.13.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

If I scan by "iw dev wlan0 scan" while sending data through the
interface, I get a BUG in net/mac80211/tx.c:

                /* RC is busted */
                if (WARN_ON_ONCE(info->control.rates[i].idx >=
                                 sband->n_bitrates)) {
                        info->control.rates[i].idx = -1;
                        continue;
                }

I added this statement inside the condition:

printk("idx = %d, bitrates = %d, i = %d\n", info->control.rates[i].idx,
sband->n_bitrates, i);

The result is:

idx = 9, bitrates = 8, i = 0
idx = 10, bitrates = 8, i = 1
idx = 9, bitrates = 8, i = 2

The card is 802.11a capable.  My interpretation is that scanning
switches to the 802.11a band temporarily, but doesn't stop transmission.
When transmitting, the rate indices for 2.4 GHz band are checked against
the number of rates in the 5 GHz band, which is indeed 8.  There are 12
rates in the 2.4 GHz band.

ath5k 0000:0b:00.0: PCI INT A disabled
ath5k 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath5k 0000:0b:00.0: setting latency timer to 64
ath5k 0000:0b:00.0: registered as 'phy2'
ath: Country alpha2 being used: US
ath: Regpair detected: 0x3a
phy2: Selected rate control algorithm 'minstrel'
ath5k phy2: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)

I actually had to patch the kernel, or the oops would escalate to a
panic.  Perhaps it's a good idea to have that check:

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1246,6 +1246,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
                        PCI_DMA_TODEVICE);
 
        rate = ieee80211_get_tx_rate(sc->hw, info);
+       if (!rate)
+               return -EIO;
 
        if (info->flags & IEEE80211_TX_CTL_NO_ACK)
                flags |= AR5K_TXDESC_NOACK;

-- 
Regards,
Pavel Roskin
