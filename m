Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34134 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbcGMUUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 16:20:16 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so2661952wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 13:20:10 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 4/4 v1] Simple and well understood logic
Date: Wed, 13 Jul 2016 23:19:56 +0300
Message-Id: <1468441196-23503-5-git-send-email-br.shurik@gmail.com> (sfid-20160713_222021_890403_455BBE4B)
In-Reply-To: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
References: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now the logic is obvious - if skb not handled by pkt type and not handled
by frame control it is handled by vif type and then released

Signed-off-by: Alex Briskin <br.shurik@gmail.com>
---
 net/mac80211/iface.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 41c3bd0..76e8c6a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1324,6 +1324,27 @@ static bool ieee80211_is_handled_by_frame_control(struct sk_buff *skb,
 	return true;
 }
 
+static void ieee80211_handle_by_vif_type(struct sk_buff *skb,
+					 struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		ieee80211_sta_rx_queued_mgmt(sdata, skb);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		ieee80211_ibss_rx_queued_mgmt(sdata, skb);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		if (!ieee80211_vif_is_mesh(&sdata->vif))
+			break;
+		ieee80211_mesh_rx_queued_mgmt(sdata, skb);
+		break;
+	default:
+		WARN(1, "frame for unexpected interface type");
+		break;
+	}
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -1343,28 +1364,11 @@ static void ieee80211_iface_work(struct work_struct *work)
 
 	/* first process frames */
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
-		if (ieee80211_is_skb_handled_by_pkt_type(skb, sdata)) {
-			goto free_skb;
-		} else if (ieee80211_is_handled_by_frame_control(skb, sdata)) {
-			goto free_skb;
-		} else switch (sdata->vif.type) {
-		case NL80211_IFTYPE_STATION:
-			ieee80211_sta_rx_queued_mgmt(sdata, skb);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			ieee80211_ibss_rx_queued_mgmt(sdata, skb);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			if (!ieee80211_vif_is_mesh(&sdata->vif))
-				break;
-			ieee80211_mesh_rx_queued_mgmt(sdata, skb);
-			break;
-		default:
-			WARN(1, "frame for unexpected interface type");
-			break;
+		if (!ieee80211_is_skb_handled_by_pkt_type(skb, sdata) &&
+		    !ieee80211_is_handled_by_frame_control(skb, sdata)) {
+			ieee80211_handle_by_vif_type(skb, sdata);
 		}
 
-free_skb:
 		kfree_skb(skb);
 	}
 
-- 
2.5.0

