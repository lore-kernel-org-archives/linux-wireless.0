Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33903 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758659AbXFKKjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 06:39:17 -0400
Message-Id: <20070611103914.577674038@warmcat.com>
References: <20070611103828.961999956@warmcat.com>
Date: Mon, 11 Jun 2007 11:38:30 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, Andy Green <andy@warmcat.com>
Subject: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcm43xx-mac80211 is reporting bogus frequencies and channels back to
mac80211 at the moment (eg, actual ch1 (2412MHz) reported as 2424MHz).

Prior to this patch, the hardware rx channel value is reported as
starting at 0x18 and rising by 0x0a per channel.  Code in bcm43xx_xmit.c
tries to take this value and add 2400 to it to get the rx frequency.
It seems the intention is that the hardware reports the (rx freq - 2400),
so we want the value starting at 0x0c and rising by 0x05 per channel.

If the value read is shifted one more bit to the right, it will
succeed in doing this.  Therefore this patch increases the shifting constant
by one and reduces the mask by one lsb.

The rx frequency reported in the radiotap rx and then, eg, tcpdump,
is then correct.  I didn't test ch 14 but I guess the hardware is
consistent about it.

CC: Larry Finger <larry.finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andy Green <andy@warmcat.com>

diff --git a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
index 44fa515..0372064 100644
--- a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
+++ b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
@@ -190,8 +190,8 @@ struct bcm43xx_rxhdr_fw4 {
 /* RX channel */
 #define BCM43xx_RX_CHAN_GAIN		0xFC00 /* Gain */
 #define BCM43xx_RX_CHAN_GAIN_SHIFT	10
-#define BCM43xx_RX_CHAN_ID		0x03FC /* Channel ID */
-#define BCM43xx_RX_CHAN_ID_SHIFT	2
+#define BCM43xx_RX_CHAN_ID		0x03F8 /* Channel ID */
+#define BCM43xx_RX_CHAN_ID_SHIFT	3
 #define BCM43xx_RX_CHAN_PHYTYPE		0x0003 /* PHY type */
 
 

-- 
