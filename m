Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31579 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZG0S4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:56:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:56:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/2] at76c50x-usb: cancel scan work at stop callback
Date: Mon, 27 Jul 2009 11:56:24 -0700
Message-ID: <1248720984-15922-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
References: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix suspend as mac80211 expects all work queued
to the mac80211 workqueue to be canceled at driver stop().

Cc: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/at76c50x-usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index bbf5277..f46e2b3 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1773,6 +1773,7 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 
+	cancel_delayed_work(&priv->dwork_hw_scan);
 	cancel_work_sync(&priv->work_set_promisc);
 
 	mutex_lock(&priv->mtx);
@@ -2298,7 +2299,6 @@ static void at76_delete_device(struct at76_priv *priv)
 	tasklet_kill(&priv->rx_tasklet);
 
 	if (priv->mac80211_registered) {
-		cancel_delayed_work(&priv->dwork_hw_scan);
 		flush_workqueue(priv->hw->workqueue);
 		ieee80211_unregister_hw(priv->hw);
 	}
-- 
1.6.0.4

