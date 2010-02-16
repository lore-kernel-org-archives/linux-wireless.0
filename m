Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab0BPKHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 05:07:07 -0500
Message-Id: <20100216100525.611007761@sipsolutions.net>
Date: Tue, 16 Feb 2010 11:05:00 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: split ieee80211_drop_unencrypted
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, ieee80211_drop_unencrypted is called
from management and data frame context, and the
different contexts pass different frames. This
could lead to it processing an 802.3 frame as an
802.11 frame when MFP is enabled.

Move the MFP part of ieee80211_drop_unencrypted
into a new function that is only called for mgmt
frames.

Cc: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-02-16 09:21:37.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2010-02-16 09:30:33.000000000 +0100
@@ -1398,6 +1398,21 @@ ieee80211_drop_unencrypted(struct ieee80
 		     ieee80211_is_data(fc) &&
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
+
+	return 0;
+}
+
+static int
+ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	__le16 fc = hdr->frame_control;
+	int res;
+
+	res = ieee80211_drop_unencrypted(rx, fc);
+	if (unlikely(res))
+		return res;
+
 	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
 		if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
 			     rx->key))
@@ -1884,7 +1899,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_UNUSABLE;
 
-	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
+	if (ieee80211_drop_unencrypted_mgmt(rx))
 		return RX_DROP_UNUSABLE;
 
 	switch (mgmt->u.action.category) {
@@ -2025,14 +2040,13 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	ieee80211_rx_result rxs;
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
-	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
-		return RX_DROP_MONITOR;
+	if (ieee80211_drop_unencrypted_mgmt(rx))
+		return RX_DROP_UNUSABLE;
 
 	rxs = ieee80211_work_rx_mgmt(rx->sdata, rx->skb);
 	if (rxs != RX_CONTINUE)


