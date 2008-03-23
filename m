Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gondor.com ([212.117.64.182]:2563 "EHLO moria.gondor.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752884AbYCWTgq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 15:36:46 -0400
Date: Sun, 23 Mar 2008 20:23:56 +0100
From: Jan Niehusmann <jan@gondor.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: trigger ieee80211_sta_work after opening
	interface
Message-ID: <20080323192355.GA5773@x61s.gondor.com> (sfid-20080323_193650_459982_3FC6B102)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_sta_work is disabled while network interface
is down. Therefore, if you configure wireless parameters
before bringing the interface up, these configurations are
not yet effective and association fails.

A workaround from userspace is calling a command like
'iwconfig wlan0 ap any' after the interface is brought up.

To fix this behaviour, trigger execution of ieee80211_sta_work from
ieee80211_open when in STA or IBSS mode.

Signed-off-by: Jan Niehusmann <jan@gondor.com>
---
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 28bcdf9..8e58639 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -286,6 +286,18 @@ static int ieee80211_open(struct net_device *dev)
 	if (need_hw_reconfig)
 		ieee80211_hw_config(local);
 
+	/*
+	 * ieee80211_sta_work is disabled while network interface
+	 * is down. Therefore, some configuration changes may not
+	 * yet be effective. Trigger execution of ieee80211_sta_work
+	 * to fix this.
+	 */
+	if(sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	   sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+		queue_work(local->hw.workqueue, &ifsta->work);
+	}
+
 	netif_start_queue(dev);
 
 	return 0;
