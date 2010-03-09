Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39079 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0CIM1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:27:55 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] mac80211: Fix (dynamic) power save entry
Date: Tue,  9 Mar 2010 14:25:02 +0200
Message-Id: <1268137502-25339-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently hardware with !IEEE80211_HW_PS_NULLFUNC_STACK and
IEEE80211_HW_REPORTS_TX_ACK_STATUS will never enter PSM due to the
conditions in the power save entry functions.

Fix those conditions.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/mlme.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8f591a4..cc80659 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -436,10 +436,12 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
 			ieee80211_send_nullfunc(local, sdata, 1);
 
-		if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
-			conf->flags |= IEEE80211_CONF_PS;
-			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-		}
+		if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
+		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+			return;
+
+		conf->flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 }
 
@@ -558,7 +560,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
 		ieee80211_send_nullfunc(local, sdata, 1);
 
-	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) ||
+	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
+	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
 	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
-- 
1.6.3.3

