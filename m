Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35849 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbcGPSTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2016 14:19:52 -0400
Received: by mail-wm0-f68.google.com with SMTP id x83so6495402wma.3
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2016 11:19:52 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 3/3 v6] mac80211: Refactor ieee80211_iface_work
Date: Sat, 16 Jul 2016 21:19:00 +0300
Message-Id: <1468693140-19483-3-git-send-email-br.shurik@gmail.com> (sfid-20160716_201955_691410_EE73C57F)
In-Reply-To: <1468693140-19483-1-git-send-email-br.shurik@gmail.com>
References: <1468693140-19483-1-git-send-email-br.shurik@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added ieee80211_iface_work_handle_vif_type function. Moved the code that
handles sdata->vif.type from ieee80211_iface_work to the function.

Signed-off-by: Alex Briskin <br.shurik@gmail.com>
---
 net/mac80211/iface.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c185801..f8f7363 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1323,6 +1323,27 @@ static int ieee80211_iface_work_handle_frame_control(struct sk_buff *skb,
 	return 0;
 }
 
+static void ieee80211_iface_work_handle_vif_type(struct sk_buff *skb,
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
@@ -1341,28 +1362,11 @@ static void ieee80211_iface_work(struct work_struct *work)
 
 	/* first process frames */
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
-		if (!ieee80211_iface_work_handle_pkt_type(skb, sdata)) {
-			goto free_skb;
-		} else if (!ieee80211_iface_work_handle_frame_control(skb, sdata)) {
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
+		if (ieee80211_iface_work_handle_pkt_type(skb, sdata) &&
+		    ieee80211_iface_work_handle_frame_control(skb, sdata)) {
+			ieee80211_iface_work_handle_vif_type(skb, sdata);
 		}
 
-free_skb:
 		kfree_skb(skb);
 	}
 
-- 
2.7.4

