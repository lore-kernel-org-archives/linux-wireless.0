Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:5190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0JMWsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:54 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id o9DMmrNE012870
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz33.hot.corp.google.com with ESMTP id o9DMmq0v017360
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:52 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 15:20:26 -0700
Subject: [PATCH 5/6] Schedule work proc when output bitrate changes
To: linux-wireless@vger.kernel.org
Message-Id: <20101013224851.C946720664@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Paul Stewart <pstew@google.com>

---
 net/mac80211/status.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3153c19..0148c50 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -154,6 +154,20 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 		}
 
 		ieee80211_queue_work(&local->hw, &local->recalc_smps);
+	} else if (ieee80211_is_data(mgmt->frame_control) &&
+		   sdata->vif.type == NL80211_IFTYPE_STATION) {
+		struct ieee80211_bss_conf *bss_conf;
+		struct ieee80211_if_managed *ifmgd;
+		bss_conf = &sta->sdata->vif.bss_conf;
+		ifmgd = &sta->sdata->u.mgd;
+		if (bss_conf->cqm_bitrate_thold != 0 &&
+		    (memcmp(&ifmgd->last_cqm_tx_rate, &sta->last_tx_rate,
+			    sizeof(ifmgd->last_cqm_tx_rate)) != 0 ||
+		     sdata->u.mgd.last_cqm_bitrate == 0)) {
+			ifmgd->last_cqm_tx_rate = sta->last_tx_rate;
+			ifmgd->flags |= IEEE80211_STA_TX_RATE_CHANGED;
+			ieee80211_queue_work(&local->hw, &local->rate_notify);
+		}
 	}
 }
 
-- 
1.7.1

