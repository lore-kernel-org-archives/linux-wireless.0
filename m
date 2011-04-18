Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54964 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DRLWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:22:36 -0400
Received: by wya21 with SMTP id 21so3803021wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:22:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] mac80211: allow low level drivers to report packet loss
Date: Mon, 18 Apr 2011 14:22:28 +0300
Message-Id: <1303125749-31967-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add API that allows low level drivers to notify mac80211 about TX
packet loss. This is useful when there are FW triggers to notify the
low level driver about these events.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |   11 +++++++++++
 net/mac80211/status.c  |    8 ++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cefe1b3..efbdda9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2265,6 +2265,17 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb);
 
 /**
+ * ieee80211_report_low_ack - report non-responding station
+ *
+ * When operating in AP-mode, call this function to report a non-responding
+ * connected STA.
+ *
+ * @sta: the non-responding connected sta
+ * @num_packets: number of packets sent to @sta without a response
+ */
+void ieee80211_report_low_ack(struct ieee80211_sta *sta, u32 num_packets);
+
+/**
  * ieee80211_beacon_get_tim - beacon generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3ed3c83..1658efa 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -446,3 +446,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
+
+void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
+				    num_packets, GFP_ATOMIC);
+}
+EXPORT_SYMBOL(ieee80211_report_low_ack);
-- 
1.7.1

