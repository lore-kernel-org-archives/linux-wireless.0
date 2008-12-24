Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:40213 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYLWTBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 14:01:13 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2806849wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 11:01:12 -0800 (PST)
Date: Wed, 24 Dec 2008 00:34:37 -0800
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Cancel the power save timer in ieee80211_stop.
Message-ID: <20081224083437.GA3307@myhost.users.atheros.com> (sfid-20081223_200118_215765_A8BA37C4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the station info is flushed before calling set_disassoc
in ieee80211_stop, the power save timer is never cancelled
when the driver is unloaded. Hence the timer cancellation has
to be done in ieee80211_stop itself.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/iface.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5abbc3f..cf45314 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -383,6 +383,8 @@ static int ieee80211_stop(struct net_device *dev)
 		atomic_dec(&local->iff_promiscs);
 
 	dev_mc_unsync(local->mdev, dev);
+	del_timer_sync(&local->dynamic_ps_timer);
+	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-- 
1.6.0.1

