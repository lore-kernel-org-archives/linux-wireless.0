Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0E1NXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 09:23:02 -0400
Subject: [PATCH] mac80211: process station blockack action frames from work
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	John Linville <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 15:22:58 +0200
Message-ID: <1275052978.3909.105.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Processing an association response could take a bit
of time while we set up the hardware etc. During that
time, the AP might already send a blockack request.
If this happens very quickly on a fairly slow machine,
we can end up processing the blockack request before
the association processing has finished. Since the
blockack processing cannot sleep right now, we also
cannot make it wait in the driver.

As a result, sometimes on slow machines the iwlagn
driver gets totally confused, and no traffic can pass
when the aggregation setup was done before the assoc
setup completed.

I'm working on a proper fix for this, which involves
queuing all blockack category action frames from a
work struct, and also allowing the ampdu_action driver
callback to sleep, which will generally clean up the
code and make things easier.

However, this is a very involved and complex change.
To fix the problem at hand in a way that can also be
backported to stable, I've come up with this patch.
Here, I simply process all aggregation action frames
from the managed interface skb queue, which means
their processing will be serialized with processing
the association response, thereby fixing the problem.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: stable@kernel.org
---
 net/mac80211/mlme.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/rx.c   |    3 +++
 2 files changed, 48 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-28 15:10:29.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-28 15:12:04.000000000 +0200
@@ -1692,14 +1692,52 @@ static void ieee80211_sta_rx_queued_mgmt
 			rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
 			break;
 		case IEEE80211_STYPE_ACTION:
-			if (mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT)
-				break;
+			switch (mgmt->u.action.category) {
+			case WLAN_CATEGORY_BACK: {
+				struct ieee80211_local *local = sdata->local;
+				int len = skb->len;
+				struct sta_info *sta;
 
-			ieee80211_sta_process_chanswitch(sdata,
-					&mgmt->u.action.u.chan_switch.sw_elem,
-					(void *)ifmgd->associated->priv,
-					rx_status->mactime);
-			break;
+				rcu_read_lock();
+				sta = sta_info_get(sdata, mgmt->sa);
+				if (!sta) {
+					rcu_read_unlock();
+					break;
+				}
+
+				local_bh_disable();
+
+				switch (mgmt->u.action.u.addba_req.action_code) {
+				case WLAN_ACTION_ADDBA_REQ:
+					if (len < (IEEE80211_MIN_ACTION_SIZE +
+						   sizeof(mgmt->u.action.u.addba_req)))
+						break;
+					ieee80211_process_addba_request(local, sta, mgmt, len);
+					break;
+				case WLAN_ACTION_ADDBA_RESP:
+					if (len < (IEEE80211_MIN_ACTION_SIZE +
+						   sizeof(mgmt->u.action.u.addba_resp)))
+						break;
+					ieee80211_process_addba_resp(local, sta, mgmt, len);
+					break;
+				case WLAN_ACTION_DELBA:
+					if (len < (IEEE80211_MIN_ACTION_SIZE +
+						   sizeof(mgmt->u.action.u.delba)))
+						break;
+					ieee80211_process_delba(sdata, sta, mgmt, len);
+					break;
+				}
+				local_bh_enable();
+				rcu_read_unlock();
+				break;
+				}
+			case WLAN_CATEGORY_SPECTRUM_MGMT:
+				ieee80211_sta_process_chanswitch(sdata,
+						&mgmt->u.action.u.chan_switch.sw_elem,
+						(void *)ifmgd->associated->priv,
+						rx_status->mactime);
+				break;
+			}
 		}
 		mutex_unlock(&ifmgd->mtx);
 
--- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 14:22:59.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-28 15:11:47.000000000 +0200
@@ -1936,6 +1936,9 @@ ieee80211_rx_h_action(struct ieee80211_r
 		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 			break;
 
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			return ieee80211_sta_rx_mgmt(sdata, rx->skb);
+
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +


