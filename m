Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:40339 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZBUHxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 02:53:33 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 3/4] at76c50x-usb: additional disconnect fixes
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Feb 2009 09:53:29 +0200
Message-ID: <20090221075329.15991.63657.stgit@tikku> (sfid-20090221_085336_199484_42F3730D)
In-Reply-To: <20090221075013.15991.66595.stgit@tikku>
References: <20090221075013.15991.66595.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Andryuk <jandryuk@gmail.com>

Additional attempts to fix Oops on disconnect, that appear to be successful.
However, some may be extraneous.

The cancel_delayed_work call is probably the most necessary.  The
device_unplugged check may not be necessary.  del_timer_sync may not
be necessary either, but the Oops I was receiving was related to
timers.  Hence the addition.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 46ac9e2..64d4192 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1497,6 +1497,9 @@ static void at76_work_set_promisc(struct work_struct *work)
 					      work_set_promisc);
 	int ret = 0;
 
+	if (priv->device_unplugged)
+		return;
+
 	mutex_lock(&priv->mtx);
 
 	priv->mib_buf.type = MIB_LOCAL;
@@ -2290,6 +2293,7 @@ static void at76_delete_device(struct at76_priv *priv)
 	tasklet_kill(&priv->rx_tasklet);
 
 	if (priv->mac80211_registered) {
+		cancel_delayed_work(&priv->dwork_hw_scan);
 		flush_workqueue(priv->hw->workqueue);
 		ieee80211_unregister_hw(priv->hw);
 	}
@@ -2307,6 +2311,8 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	kfree(priv->bulk_out_buffer);
 
+	del_timer_sync(&ledtrig_tx_timer);
+
 	if (priv->rx_skb)
 		kfree_skb(priv->rx_skb);
 

