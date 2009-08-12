Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46859 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZHLOw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 10:52:29 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/3] mac80211: refactor dynamic power save check
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Wed, 12 Aug 2009 17:52:01 +0300
Message-ID: <20090812145200.23691.17281.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Refactor dynamic power save checks to a function of it's own for better
readibility. No functional changes.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/tx.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 10a1099..03005f9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1384,6 +1384,26 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 	return 0;
 }
 
+static bool is_dynamic_ps_enabled(struct ieee80211_local *local)
+{
+	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+		/* driver doesn't support power save */
+		return false;
+
+	if (local->hw.conf.dynamic_ps_timeout <= 0)
+		/* dynamic power save disabled */
+		return false;
+
+	if (local->scanning)
+		/* we are scanning, don't enable power save */
+		return false;
+
+	if (!local->ps_sdata)
+		return false;
+
+	return true;
+}
+
 static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
@@ -1396,9 +1416,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	dev_hold(sdata->dev);
 
-	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    local->hw.conf.dynamic_ps_timeout > 0 &&
-	    !(local->scanning) && local->ps_sdata) {
+	if (is_dynamic_ps_enabled(local)) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);

