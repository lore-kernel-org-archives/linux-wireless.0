Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:60937
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753544Ab3GTDbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 23:31:34 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] cw1200:  Fix OOPS in monitor mode
Date: Fri, 19 Jul 2013 23:31:27 -0400
Message-Id: <1374291087-27706-1-git-send-email-pizza@shaftnet.org> (sfid-20130720_053138_028089_663AC196)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In monitor mode, priv->vif is NULL, but at one point in the receive path we
blindly attempt to dereference it.  Add a test to prevent this.

This patch really needs to go into 3.11-rc

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/txrx.c b/drivers/net/wireless/cw1200/txrx.c
index 5862c37..e824d4d 100644
--- a/drivers/net/wireless/cw1200/txrx.c
+++ b/drivers/net/wireless/cw1200/txrx.c
@@ -1165,7 +1165,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		if (cw1200_handle_action_rx(priv, skb))
 			return;
 	} else if (ieee80211_is_beacon(frame->frame_control) &&
-		   !arg->status &&
+		   !arg->status && priv->vif &&
 		   !memcmp(ieee80211_get_SA(frame), priv->vif->bss_conf.bssid,
 			   ETH_ALEN)) {
 		const u8 *tim_ie;
-- 
1.8.3.1

