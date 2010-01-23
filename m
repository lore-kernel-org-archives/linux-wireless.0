Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51088 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0AWTi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 14:38:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: hwtkip hangs on b43
Date: Sat, 23 Jan 2010 20:38:52 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <201001232000.07229.mb@bu3sch.de> <4B5B4E9F.8040708@lwfinger.net>
In-Reply-To: <4B5B4E9F.8040708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001232038.55204.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 23 January 2010 20:31:43 Larry Finger wrote:
> On 01/23/2010 01:00 PM, Michael Buesch wrote:
> > On Saturday 23 January 2010 19:53:48 Johannes Berg wrote:
> >> Actually you can't, because you can't acquire the mutex here since we're
> >> in an atomic section. So relying on it being already locked is probably
> >> safer. However, you can't actually sleep anyway...
> >
> > I'm OK with removing the lock from the callback, if it is guaranteed that
> > the callback is only called on behalf of a RX call.
> >
> > We can just remove the lock and add a comment explaining why it is not locked...
> 
> That works for me.
> 


untested

---
 drivers/net/wireless/b43/main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -856,22 +856,19 @@ static void b43_op_update_tkip_key(struc
 	if (B43_WARN_ON(!modparam_hwtkip))
 		return;
 
-	mutex_lock(&wl->mutex);
-
+	/* This is only called from the RX path though mac80211, where
+	 * our mutex is already locked. */
+	B43_WARN_ON(!mutex_is_locked(&wl->mutex));
 	dev = wl->current_dev;
-	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
-		goto out_unlock;
+	B43_WARN_ON(!dev || b43_status(dev) < B43_STAT_INITIALIZED);
 
 	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
 
 	rx_tkip_phase1_write(dev, index, iv32, phase1key);
 	/* only pairwise TKIP keys are supported right now */
 	if (WARN_ON(!sta))
-		goto out_unlock;
+		return;
 	keymac_write(dev, index, sta->addr);
-
-out_unlock:
-	mutex_unlock(&wl->mutex);
 }
 
 static void do_key_write(struct b43_wldev *dev,


-- 
Greetings, Michael.
