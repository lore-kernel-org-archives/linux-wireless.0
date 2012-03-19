Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:49606 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab2CTOzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:55:20 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 10:22:40 +0100
Subject: [RFC 04/12] mac80211: prepare ieee80211_get_tx_channel_type to per-vif
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <fee1d9db-75c7-4e26-a463-e5d436a24cc2@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155525_168969_C5FBFFE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        |    4 +++-
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |    2 +-
 net/mac80211/rx.c          |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e00ce8c..421c64e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -142,9 +142,11 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
  * whatever regulatory flags we have been given.
  */
 enum nl80211_channel_type ieee80211_get_tx_channel_type(
-				struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type channel_type)
 {
+	struct ieee80211_local *local = sdata->local;
+
 	switch (channel_type) {
 	case NL80211_CHAN_HT40PLUS:
 		if (local->hw.conf.channel->flags &
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0ffee10..69a38be 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1504,7 +1504,7 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 enum nl80211_channel_type
 ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info);
 enum nl80211_channel_type ieee80211_get_tx_channel_type(
-					struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
 					enum nl80211_channel_type channel_type);
 
 #ifdef CONFIG_MAC80211_NOINLINE
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 576fb25..9d0e865 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -234,7 +234,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	tx_channel_type = ieee80211_get_tx_channel_type(local, rx_channel_type);
+	tx_channel_type = ieee80211_get_tx_channel_type(sdata, rx_channel_type);
 
 	if (local->tmp_channel)
 		local->tmp_channel_type = rx_channel_type;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bcfe8c7..5749c74 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2273,7 +2273,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 				local, sband, rx->sta,
 				IEEE80211_RC_SMPS_CHANGED,
 				ieee80211_get_tx_channel_type(
-					local, local->_oper_channel_type));
+					sdata, local->_oper_channel_type));
 			goto handled;
 		}
 		default:
-- 
1.7.0.4

