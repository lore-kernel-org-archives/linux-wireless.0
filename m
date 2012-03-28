Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab2C1JGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:15 -0400
Message-Id: <20120328090432.574661500@sipsolutions.net> (sfid-20120328_110626_625020_DAD8B9E5)
Date: Wed, 28 Mar 2012 11:04:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mac80211: refuse TX queue configuration on non-QoS HW
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers that don't support QoS also don't support
setting up their ACs, catch that early. While at
it, remove the input check since cfg80211 does it
now.

Also fix up the restart code to not try to set up
the queues in this case.

Finally also change the tx_conf array to have
IEEE80211_NUM_ACS entries instead of # of queues
since that's what it really needs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    6 +++---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/util.c        |   32 +++++++++++++++++++-------------
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/net/mac80211/cfg.c	2012-03-27 14:10:27.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-03-27 14:10:27.000000000 +0200
@@ -1437,6 +1437,9 @@ static int ieee80211_set_txq_params(stru
 	if (!local->ops->conf_tx)
 		return -EOPNOTSUPP;
 
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		return -EOPNOTSUPP;
+
 	memset(&p, 0, sizeof(p));
 	p.aifs = params->aifs;
 	p.cw_max = params->cwmax;
@@ -1449,9 +1452,6 @@ static int ieee80211_set_txq_params(stru
 	 */
 	p.uapsd = false;
 
-	if (params->ac >= local->hw.queues)
-		return -EINVAL;
-
 	sdata->tx_conf[params->ac] = p;
 	if (drv_conf_tx(local, sdata, params->ac, &p)) {
 		wiphy_debug(local->hw.wiphy,
--- a/net/mac80211/util.c	2012-03-27 14:09:46.000000000 +0200
+++ b/net/mac80211/util.c	2012-03-27 14:10:27.000000000 +0200
@@ -769,19 +769,22 @@ void ieee80211_set_wmm_default(struct ie
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
-	int queue;
+	int ac;
 	bool use_11b;
 	int aCWmin, aCWmax;
 
 	if (!local->ops->conf_tx)
 		return;
 
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		return;
+
 	memset(&qparam, 0, sizeof(qparam));
 
 	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
-	for (queue = 0; queue < local->hw.queues; queue++) {
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		/* Set defaults according to 802.11-2007 Table 7-37 */
 		aCWmax = 1023;
 		if (use_11b)
@@ -789,7 +792,7 @@ void ieee80211_set_wmm_default(struct ie
 		else
 			aCWmin = 15;
 
-		switch (queue) {
+		switch (ac) {
 		case IEEE80211_AC_BK:
 			qparam.cw_max = aCWmax;
 			qparam.cw_min = aCWmin;
@@ -825,8 +828,8 @@ void ieee80211_set_wmm_default(struct ie
 
 		qparam.uapsd = false;
 
-		sdata->tx_conf[queue] = qparam;
-		drv_conf_tx(local, sdata, queue, &qparam);
+		sdata->tx_conf[ac] = qparam;
+		drv_conf_tx(local, sdata, ac, &qparam);
 	}
 
 	/* after reinitialize QoS TX queues setting to default,
@@ -1226,14 +1229,17 @@ int ieee80211_reconfig(struct ieee80211_
 	mutex_unlock(&local->sta_mtx);
 
 	/* reconfigure tx conf */
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		    sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-		    !ieee80211_sdata_running(sdata))
-			continue;
-
-		for (i = 0; i < hw->queues; i++)
-			drv_conf_tx(local, sdata, i, &sdata->tx_conf[i]);
+	if (hw->queues >= IEEE80211_NUM_ACS) {
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+			    sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+			    !ieee80211_sdata_running(sdata))
+				continue;
+
+			for (i = 0; i < IEEE80211_NUM_ACS; i++)
+				drv_conf_tx(local, sdata, i,
+					    &sdata->tx_conf[i]);
+		}
 	}
 
 	/* reconfigure hardware */
--- a/net/mac80211/ieee80211_i.h	2012-03-27 14:10:27.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-03-27 14:10:34.000000000 +0200
@@ -687,7 +687,7 @@ struct ieee80211_sub_if_data {
 	__be16 control_port_protocol;
 	bool control_port_no_encrypt;
 
-	struct ieee80211_tx_queue_params tx_conf[IEEE80211_MAX_QUEUES];
+	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 
 	struct work_struct work;
 	struct sk_buff_head skb_queue;


