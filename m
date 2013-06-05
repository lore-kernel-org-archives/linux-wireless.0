Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:60841 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3FELzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:55:10 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv2 2/4] mac80211: make mgmt_tx accept a NULL channel
Date: Wed,  5 Jun 2013 13:53:05 +0200
Message-Id: <1370433187-1337-2-git-send-email-ordex@autistici.org> (sfid-20130605_135517_542135_61C23199)
In-Reply-To: <1370433187-1337-1-git-send-email-ordex@autistici.org>
References: <1370433187-1337-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

cfg80211 passes a NULL channel to mgmt_tx if the frame has
to be sent on the one currently in use by the device.
Make the implementation of mgmt_tx correctly handle this
case. Fail if offchan is required.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/cfg.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3062210..617c5c8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2838,6 +2838,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		return -EOPNOTSUPP;
 	}
 
+	/* configurations requiring offchan cannot work if no channel has been
+	 * specified
+	 */
+	if (need_offchan && !chan)
+		return -EINVAL;
+
 	mutex_lock(&local->mtx);
 
 	/* Check if the operating channel is the requested channel */
@@ -2847,10 +2853,14 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		rcu_read_lock();
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-		if (chanctx_conf)
-			need_offchan = chan != chanctx_conf->def.chan;
-		else
+		if (chanctx_conf) {
+			need_offchan = chan && (chan != chanctx_conf->def.chan);
+		} else if (!chan) {
+			ret = -EINVAL;
+			goto out_unlock;
+		} else {
 			need_offchan = true;
+		}
 		rcu_read_unlock();
 	}
 
-- 
1.8.1.5

