Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:33388 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbXCBSdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 13:33:12 -0500
Date: Fri, 02 Mar 2007 12:32:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix bug in frequency to channel conversion
Message-ID: <45e86da6.364P62Xmkc0zH2f9%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joerg Sommer <joerg@alea.gnuu.de>

The frequency to channel routine in bcm43xx requires that the frequency
be in MHz, but that condition is not always met. This patch does the
necessary conversion.

Signed-off-by: Joerg Sommer <joerg@alea.gnuu.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -106,18 +106,24 @@ static int bcm43xx_wx_set_channelfreq(st
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

---

