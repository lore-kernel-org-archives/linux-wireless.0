Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaCEOuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 09:50:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] mac80211: clear sequence/fragment number in QoS-null frames
Date: Wed,  5 Mar 2014 15:50:10 +0100
Message-Id: <1394031010-22560-1-git-send-email-johannes@sipsolutions.net> (sfid-20140305_155024_170900_214FD454)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Avoid leaking data by sending uninitialized memory and setting an
invalid (non-zero) fragment number (the sequence number is ignored
anyway) by setting the seq_ctrl field to zero.

Cc: stable@vger.kernel.org
Fixes: 3f52b7e328c5 ("mac80211: mesh power save basics")
Fixes: ce662b44ce22 ("mac80211: send (QoS) Null if no buffered frames")
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_ps.c  | 1 +
 net/mac80211/sta_info.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 2802f9d9279d..ad8b377b4b9f 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -36,6 +36,7 @@ static struct sk_buff *mps_qos_null_get(struct sta_info *sta)
 				      sdata->vif.addr);
 	nullfunc->frame_control = fc;
 	nullfunc->duration_id = 0;
+	nullfunc->seq_ctrl = 0;
 	/* no address resolution for this frame -> set addr 1 immediately */
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memset(skb_put(skb, 2), 0, 2); /* append QoS control field */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a023b432143b..137a192e64bc 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1206,6 +1206,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
 
 	skb->priority = tid;
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
-- 
1.8.5.3

