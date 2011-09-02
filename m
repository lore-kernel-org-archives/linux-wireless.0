Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21719 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1IBIV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 04:21:29 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2] mac80211: stop tx before doing hw config and rate update
Date: Fri, 2 Sep 2011 13:51:59 +0530
Message-ID: <1314951719-9816-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110902_102135_513783_84D922AF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assumption is that during the hw config, transmission was
already stopped by mac80211. Sometimes the AP can be switching
b/w the ht modes due to intolerant or etc where STA is in
the middle of transmission. In such scenario, buffer overflow
was observed at driver side. And also before updating the rate
control, the frames are continued to xmited with older rates.
This patch ensures that the frames are always xmitted with
updated rates and avoid buffer overflow.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..8db9f9a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -670,6 +670,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 60a6f27..edd2518 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1922,8 +1922,24 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		rcu_read_unlock();
 
+		/*
+		 * Whenever the AP announces the HT mode change that can be
+		 * 40MHz intolerant or etc., it would be safer to stop tx
+		 * queues before doing hw config to avoid buffer overflow.
+		 */
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
+
+		/* flush out all packets */
+		synchronize_net();
+
+		drv_flush(local, false);
+
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
 					       bssid, ap_ht_cap_flags);
+
+		ieee80211_wake_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
 
 	/* Note: country IE parsing is done for us by cfg80211 */
-- 
1.7.6.1

