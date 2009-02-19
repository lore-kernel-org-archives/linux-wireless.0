Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:35764 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbZBSDZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 22:25:52 -0500
Received: by qyk4 with SMTP id 4so417076qyk.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 19:25:50 -0800 (PST)
Subject: [PATCH] at76c50x-usb: additional disconnect fixes
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87wsbnpiws.fsf@litku.valot.fi>
References: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com>
	 <da94abde0902070329s373a9edbqd9265acac8930d2a@mail.gmail.com>
	 <c4d76b3b0902081947x92eb0bo73fa63afb23b5e2c@mail.gmail.com>
	 <87wsbnpiws.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 22:25:48 -0500
Message-Id: <1235013948.6344.12.camel@rainbow> (sfid-20090219_042557_242962_78EFCBE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Additional attempts to fix Oops on disconnect, that appear to be successful.  However, 
some may be extraneous.

The cancel_delayed_work call is probably the most necessary.  The device_unplugged
check may not be necessary.  del_timer_sync may not be necessary either, but the Oops 
I was receiving was related to timers.  Hence the addition.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 7a03251..52b0be5 100644
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
@@ -2297,6 +2300,7 @@ static void at76_delete_device(struct at76_priv *priv)
 	tasklet_kill(&priv->rx_tasklet);
 
 	if (priv->mac80211_registered) {
+		cancel_delayed_work(&priv->dwork_hw_scan);
 		flush_workqueue(priv->hw->workqueue);
 		ieee80211_unregister_hw(priv->hw);
 	}
@@ -2314,6 +2318,8 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	kfree(priv->bulk_out_buffer);
 
+	del_timer_sync(&ledtrig_tx_timer);
+
 	if (priv->rx_skb)
 		kfree_skb(priv->rx_skb);
 

