Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35059 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0JFKBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 06:01:04 -0400
Received: by fxm4 with SMTP id 4so1014145fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 03:01:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: hoist sta->lock from reorder release timer
Date: Wed, 6 Oct 2010 12:00:53 +0200
Cc: linville@tuxdriver.com, Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010061200.54364.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: AMPDU rx reorder timeout timer" clashes
with "mac80211: use netif_receive_skb in ieee80211_rx callpath"

The timer itself is part of the station's private struct.
The clean-up routine will deactivate the timer as soon as
the station is removed. Therefore the extra sta->lock
protection should not be necessary.

Cc: Ben Greear <greearb@candelatech.com>
Reported-by: Ming Lei<tom.leiming@gmail.com>
Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
---
reference from Ben Greear: (no tested-by, because no-one
could actually reproduce the original lockdep warning)
http://www.spinics.net/lists/linux-wireless/msg56900.html
---
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 58eab9e..309ed70 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -129,9 +129,7 @@ static void sta_rx_agg_reorder_timer_expired(unsigned long data)
 			timer_to_tid[0]);
 
 	rcu_read_lock();
-	spin_lock(&sta->lock);
 	ieee80211_release_reorder_timeout(sta, *ptid);
-	spin_unlock(&sta->lock);
 	rcu_read_unlock();
 }
 
