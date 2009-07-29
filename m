Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52559 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZG2VUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:20:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 14:20:55 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/2] at76c50x-usb: remove unneeded flush_workqueue() at usb disconnect
Date: Wed, 29 Jul 2009 14:20:41 -0700
Message-ID: <1248902442-14621-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver only uses the mac80211 workqueue and mac80211 requires us to
cancel all work at driver stop. Since we now have the cancels in the right
places at stop() we really don't need to flush the mac80211 workqueue so
remove it.

Cc: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/at76c50x-usb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index f46e2b3..aff09a1 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2298,10 +2298,8 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	tasklet_kill(&priv->rx_tasklet);
 
-	if (priv->mac80211_registered) {
-		flush_workqueue(priv->hw->workqueue);
+	if (priv->mac80211_registered)
 		ieee80211_unregister_hw(priv->hw);
-	}
 
 	if (priv->tx_urb) {
 		usb_kill_urb(priv->tx_urb);
-- 
1.6.0.4

