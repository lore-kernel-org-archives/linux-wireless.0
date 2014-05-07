Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36274 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbaEGPyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 11:54:52 -0400
Received: by mail-ee0-f49.google.com with SMTP id e53so888050eek.36
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 08:54:51 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 4/4] rtl8187: make CTS-to-self protection work
Date: Wed,  7 May 2014 17:54:46 +0200
Message-Id: <1399478086-26586-1-git-send-email-andrea.merello@gmail.com> (sfid-20140507_175501_111719_164DB86D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CTS protection was not working properly because the HW needs
RTS flag to be asserted, and it need also RTS duration field to be
filled with CTS-to-self duration.

This patch makes the driver to do this.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 6e4b177..629ad8c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -253,14 +253,21 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
 	flags |= ieee80211_get_tx_rate(dev, info)->hw_value << 24;
 	if (ieee80211_has_morefrags(tx_hdr->frame_control))
 		flags |= RTL818X_TX_DESC_FLAG_MOREFRAG;
+
+	/* HW will perform RTS-CTS when only RTS flags is set.
+	 * HW will perform CTS-to-self when both RTS and CTS flags are set.
+	 * RTS rate and RTS duration will be used also for CTS-to-self.
+	 */
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		flags |= RTL818X_TX_DESC_FLAG_RTS;
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 		rts_dur = ieee80211_rts_duration(dev, priv->vif,
 						 skb->len, info);
 	} else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-		flags |= RTL818X_TX_DESC_FLAG_CTS;
+		flags |= RTL818X_TX_DESC_FLAG_RTS | RTL818X_TX_DESC_FLAG_CTS;
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
+		rts_dur = ieee80211_ctstoself_duration(dev, priv->vif,
+						 skb->len, info);
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-- 
1.8.3.2

