Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19074 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0DVH35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 03:29:57 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix sta->last_tx_rate setting with no-op rate control devices
Date: Thu, 22 Apr 2010 10:27:48 +0300
Message-Id: <1271921268-7512-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sta->last_tx_rate is traditionally updated just before transmitting a
frame based on information from the rate control algorithm. However, for
hardware drivers with IEEE80211_HW_HAS_RATE_CONTROL this is not performed,
as the rate control algorithm is not executed, and because the used rate is
not known before the frame has actually been transmitted.

This causes atleast a fixed 1Mb/s to be reported to user space. A few other
instances of code also rely on this information.

Fix this by setting the sta->last_tx_rate in tx_status handling. There, look
for last rates entry set by the driver, and use that as value for
sta->last_tx_rate.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/status.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 11805a3..94613af 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -171,6 +171,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct net_device *prev_dev = NULL;
 	struct sta_info *sta, *tmp;
 	int retry_count = -1, i;
+	int rates_idx = -1;
 	bool send_to_cooked;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -178,6 +179,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (i >= hw->max_rates) {
 			info->status.rates[i].idx = -1;
 			info->status.rates[i].count = 0;
+		} else if (info->status.rates[i].idx >= 0) {
+			rates_idx = i;
 		}
 
 		retry_count += info->status.rates[i].count;
@@ -206,6 +209,10 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
+		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+		    (rates_idx != -1))
+			sta->last_tx_rate = info->status.rates[rates_idx];
+
 		if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
 		    (ieee80211_is_data_qos(fc))) {
 			u16 tid, ssn;
-- 
1.6.3.3

