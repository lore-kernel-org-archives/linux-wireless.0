Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxf2.seznam.cz ([77.75.76.123]:41221 "EHLO mxf2.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbdCIJtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 04:49:42 -0500
From: ondrej.lysonek@seznam.cz
To: johannes@sipsolutions.net
Cc: =?UTF-8?q?Ond=C5=99ej=20Lyson=C4=9Bk?= <ondrej.lysonek@seznam.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] mac80211: Use setup_timer instead of init_timer
Date: Thu,  9 Mar 2017 10:34:36 +0100
Message-Id: <20170309093436.25227-1-ondrej.lysonek@seznam.cz> (sfid-20170309_105019_337896_D7117E34)
In-Reply-To: <1488803104.5761.6.camel@sipsolutions.net>
References: <1488803104.5761.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ondřej Lysoněk <ondrej.lysonek@seznam.cz>

Use setup_timer() and setup_deferrable_timer() to set the data and
function timer fields. It makes the code cleaner and will allow for
easier change of the timer struct internals.

Signed-off-by: Ondřej Lysoněk <ondrej.lysonek@seznam.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index f0e6175..64c6174 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -397,11 +397,10 @@ struct mesh_path *mesh_path_new(struct ieee80211_sub_if_data *sdata,
 	new_mpath->sdata = sdata;
 	new_mpath->flags = 0;
 	skb_queue_head_init(&new_mpath->frame_queue);
-	new_mpath->timer.data = (unsigned long) new_mpath;
-	new_mpath->timer.function = mesh_path_timer;
 	new_mpath->exp_time = jiffies;
 	spin_lock_init(&new_mpath->state_lock);
-	init_timer(&new_mpath->timer);
+	setup_timer(&new_mpath->timer, mesh_path_timer,
+		    (unsigned long) new_mpath);
 
 	return new_mpath;
 }
-- 
2.9.3
