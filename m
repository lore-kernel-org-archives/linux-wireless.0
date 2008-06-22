Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:8848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbYFVXpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 19:45:33 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1780017wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 16:45:32 -0700 (PDT)
Subject: [PATCH 4/4] mac80211: mlme.c use new frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 16:45:32 -0700
Message-Id: <1214178332.21092.17.camel@brick> (sfid-20080623_014554_553523_BF52DC4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/mlme.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 55659a7..e5f3de1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3173,33 +3173,32 @@ ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
 		      struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_mgmt *mgmt;
-	u16 fc;
+	__le16 fc;
 
 	if (skb->len < 2)
 		return RX_DROP_UNUSABLE;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = le16_to_cpu(mgmt->frame_control);
+	fc = mgmt->frame_control;
 
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL)
+	if (ieee80211_is_ctl(fc))
 		return RX_CONTINUE;
 
 	if (skb->len < 24)
 		return RX_DROP_MONITOR;
 
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP) {
-			ieee80211_rx_mgmt_probe_resp(dev, mgmt,
-						     skb->len, rx_status);
-			dev_kfree_skb(skb);
-			return RX_QUEUED;
-		} else if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON) {
-			ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len,
-						 rx_status);
-			dev_kfree_skb(skb);
-			return RX_QUEUED;
-		}
+	if (ieee80211_is_probe_resp(fc)) {
+		ieee80211_rx_mgmt_probe_resp(dev, mgmt, skb->len, rx_status);
+		dev_kfree_skb(skb);
+		return RX_QUEUED;
 	}
+
+	if (ieee80211_is_beacon(fc)) {
+		ieee80211_rx_mgmt_beacon(dev, mgmt, skb->len, rx_status);
+		dev_kfree_skb(skb);
+		return RX_QUEUED;
+	}
+
 	return RX_CONTINUE;
 }
 
@@ -3777,7 +3776,7 @@ static void ieee80211_send_nullfunc(struct ieee80211_local *local,
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr *nullfunc;
-	u16 fc;
+	__le16 fc;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
 	if (!skb) {
@@ -3789,11 +3788,11 @@ static void ieee80211_send_nullfunc(struct ieee80211_local *local,
 
 	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
 	memset(nullfunc, 0, 24);
-	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
-	     IEEE80211_FCTL_TODS;
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
+			 IEEE80211_FCTL_TODS);
 	if (powersave)
-		fc |= IEEE80211_FCTL_PM;
-	nullfunc->frame_control = cpu_to_le16(fc);
+		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
+	nullfunc->frame_control = fc;
 	memcpy(nullfunc->addr1, sdata->u.sta.bssid, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
-- 
1.5.6.290.gc4e15

