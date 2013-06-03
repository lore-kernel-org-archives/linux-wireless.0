Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:37497 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 03:04:32 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 2/2] mac80211: in mgmt_tx use the current channel if none has been specified
Date: Mon,  3 Jun 2013 08:39:47 +0200
Message-Id: <1370241587-2609-2-git-send-email-ordex@autistici.org> (sfid-20130603_090435_727410_099A6CFA)
In-Reply-To: <1370241587-2609-1-git-send-email-ordex@autistici.org>
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

In mgmt_tx, if no channel has been specified via cfg80211,
use the current one.

If the interface requires offchan (because disconnected or
for other reasons) then fail.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/cfg.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9034da1..e6e41c7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2836,6 +2836,13 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * configurations requiring offchan cannot work if no channel has been
+	 * specified
+	 */
+	if (need_offchan && !chan)
+		return -EINVAL;
+
 	mutex_lock(&local->mtx);
 
 	/* Check if the operating channel is the requested channel */
@@ -2845,6 +2852,10 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		rcu_read_lock();
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
+		/* if no channel was specified, use the current one */
+		if (chanctx_conf && !chan)
+			chan = chanctx_conf->def.chan;
+
 		if (chanctx_conf)
 			need_offchan = chan != chanctx_conf->def.chan;
 		else
@@ -2852,6 +2863,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		rcu_read_unlock();
 	}
 
+	/* at this point a channel should have been chosen */
+	if (!chan) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (need_offchan && !offchan) {
 		ret = -EBUSY;
 		goto out_unlock;
-- 
1.8.1.5

