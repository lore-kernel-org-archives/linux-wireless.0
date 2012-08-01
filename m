Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2HAPVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 5/8] mac80211: make ieee80211_beacon_connection_loss_work static
Date: Wed,  1 Aug 2012 17:21:24 +0200
Message-Id: <1343834487-23737-6-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172140_634139_742C001D)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to declare the function in the
header file since it's only used in a single
place, so make it static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a906cc0..585827e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1424,7 +1424,6 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack);
-void ieee80211_beacon_connection_loss_work(struct work_struct *work);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d963017..7451dd4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1720,7 +1720,7 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->mtx);
 }
 
-void ieee80211_beacon_connection_loss_work(struct work_struct *work)
+static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
-- 
1.7.10.4

