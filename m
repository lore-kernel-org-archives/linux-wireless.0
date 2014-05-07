Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:41984 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933936AbaEGPxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 11:53:23 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so885933eek.41
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 08:53:21 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 3/4] rtl8180: make CTS-to-self protection work
Date: Wed,  7 May 2014 17:53:17 +0200
Message-Id: <1399477997-26455-1-git-send-email-andrea.merello@gmail.com> (sfid-20140507_175332_795359_63718326)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CTS protection was not working properly because the HW still need
RTS flag to be asserted, and it need also RTS rate field to be
set with CTS-to-self rate and RTS duration field to be filled with
CTS-to-self duration.

This patch makes the driver to do this.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 8d07df2..2c1c02b 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -463,18 +463,23 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 			    RTL818X_TX_DESC_FLAG_NO_ENC;
 
 	rc_flags = info->control.rates[0].flags;
+
+	/* HW will perform RTS-CTS when only RTS flags is set.
+	 * HW will perform CTS-to-self when both RTS and CTS flags are set.
+	 * RTS rate and RTS duration will be used also for CTS-to-self.
+	 */
 	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		tx_flags |= RTL818X_TX_DESC_FLAG_RTS;
 		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
+		rts_duration = ieee80211_rts_duration(dev, priv->vif,
+						skb->len, info);
 	} else if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-		tx_flags |= RTL818X_TX_DESC_FLAG_CTS;
+		tx_flags |= RTL818X_TX_DESC_FLAG_RTS | RTL818X_TX_DESC_FLAG_CTS;
 		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
+		rts_duration = ieee80211_ctstoself_duration(dev, priv->vif,
+						skb->len, info);
 	}
 
-	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS)
-		rts_duration = ieee80211_rts_duration(dev, priv->vif, skb->len,
-						      info);
-
 	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180) {
 		unsigned int remainder;
 
-- 
1.8.3.2

