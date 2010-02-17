Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:37451 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab0BQVEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 16:04:11 -0500
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id CF19F18D48F
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:09 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id BE1F6E51A9
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:08 +0200 (EET)
Subject: [RFC PATCH 1/3] mac80211: refactor nullfunc status handling to a
	separate function
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 17 Feb 2010 23:04:08 +0200
Message-ID: <20100217210408.30634.73615.stgit@tikku>
In-Reply-To: <20100217210202.30634.69236.stgit@tikku>
References: <20100217210202.30634.69236.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Create a new function for handling nullfunc status and make it easier
to add new functionality.

No functional changes.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/status.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 56d5b9a..8a17454 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -157,6 +157,29 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	}
 }
 
+static void ieee80211_nullfunc_status(struct ieee80211_local *local,
+				      struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	__le16 fc = hdr->frame_control;
+
+	if (ieee80211_has_pm(fc) &&
+	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+	    local->ps_sdata && !(local->scanning)) {
+		if (info->flags & IEEE80211_TX_STAT_ACK) {
+			local->ps_sdata->u.mgd.flags |=
+				IEEE80211_STA_NULLFUNC_ACKED;
+			ieee80211_queue_work(&local->hw,
+					     &local->dynamic_ps_enable_work);
+		} else
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(10));
+	}
+}
+
+
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
@@ -274,19 +297,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			local->dot11FailedCount++;
 	}
 
-	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
-	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
-	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-	    local->ps_sdata && !(local->scanning)) {
-		if (info->flags & IEEE80211_TX_STAT_ACK) {
-			local->ps_sdata->u.mgd.flags |=
-					IEEE80211_STA_NULLFUNC_ACKED;
-			ieee80211_queue_work(&local->hw,
-					&local->dynamic_ps_enable_work);
-		} else
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-					msecs_to_jiffies(10));
-	}
+	if (ieee80211_is_nullfunc(fc))
+		ieee80211_nullfunc_status(local, skb);
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX)
 		cfg80211_action_tx_status(

