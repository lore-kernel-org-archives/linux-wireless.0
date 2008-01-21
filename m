Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8986 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929AbYAUKjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 05:39:24 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/2] mac80211: fix rx flow sparse errors, make functions static
Date: Mon, 21 Jan 2008 12:39:12 +0200
Message-Id: <1200911960850-git-send-email-tomas.winkler@intel.com> (sfid-20080121_103930_968244_AB02CB23)
In-Reply-To: <12009119602588-git-send-email-tomas.winkler@intel.com>
References: <12009119522429-git-send-email-tomas.winkler@intel.com>
 <12009119602588-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds static declarations to functions in the Rx flow in order to
eliminate sparse errors

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_sta.c |    4 ++--
 net/mac80211/rx.c            |   12 +++++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index e7da1cd..2019b4f 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1154,8 +1154,8 @@ end_no_lock:
 	sta_info_put(sta);
 }
 
-void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
-				u16 initiator, u16 reason_code)
+static void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
+				 u16 initiator, u16 reason_code)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6cc1e7e..d19f79e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -295,7 +295,7 @@ ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
 }
 
 
-u32 ieee80211_rx_load_stats(struct ieee80211_local *local,
+static u32 ieee80211_rx_load_stats(struct ieee80211_local *local,
 			      struct sk_buff *skb,
 			      struct ieee80211_rx_status *status)
 {
@@ -1664,8 +1664,10 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
  * This is the actual Rx frames handler. as it blongs to Rx path it must
  * be called with rcu_read_lock protection.
  */
-void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    struct ieee80211_rx_status *status, u32 load)
+static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
+					 struct sk_buff *skb,
+					 struct ieee80211_rx_status *status,
+					 u32 load)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -1920,8 +1922,8 @@ u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	return 1;
 }
 
-u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-			      struct sk_buff *skb)
+static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
+				     struct sk_buff *skb)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-- 
1.5.2.2

