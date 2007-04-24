Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:44071 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423090AbXDXUve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 16:51:34 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 157488CAC9
	for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2007 22:51:26 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id BE7B2131BD
	for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2007 20:52:04 +0000 (UTC)
Received: from meerkat.home.warmcat.com (meerkat.home.warmcat.com [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id 9ABED18D1D69
	for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2007 21:51:30 +0100 (BST)
Message-ID: <462E6DD1.4050108@warmcat.com>
Date: Tue, 24 Apr 2007 21:51:29 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: fix rx status reported frequency
Content-Type: multipart/mixed;
 boundary="------------000200050806080503020602"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000200050806080503020602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------000200050806080503020602
Content-Type: text/x-patch;
 name="bcm43xx-mac80211-fix-rx-status-reported-frequency.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="bcm43xx-mac80211-fix-rx-status-reported-frequency.patch"

bcm43xx-mac80211: Fix reported rx frequency and channel

bcm43xx-mac80211 is reporting bogus frequencies and channels back to
mac80211 at the moment (eg, actual ch1 (2412MHz) reported as 2424MHz).

Prior to this patch, the hardware rx channel value is reported as
starting at 0x18 and rising by 0x10 per channel.  Code in bcm43xx_xmit.c
tries to take this value and add 2400 to it to get the rx frequency.
It seems the intention is that the hardware reports the (rx freq - 2400),
so we want the value starting at 0x0c and rising by 0x05 per channel.

If the value read is shifted one more bit to the right, it will
succeed in doing this.  Therefore this patch increases the shifting constant
by one and reduces the mask by one lsb.

The rx frequency reported in the radiotap rx and then, eg, tcpdump,
is then correct.  I didn't test ch 14 but I guess the hardware is
consistent about it.

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
 
 

--------------000200050806080503020602--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
