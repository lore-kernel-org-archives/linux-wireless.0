Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50321 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab2GLOfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 10:35:31 -0400
Received: by wibhr14 with SMTP id hr14so2330051wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 07:35:29 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: go out of PS before sending disassoc
Date: Thu, 12 Jul 2012 17:35:33 +0300
Message-Id: <1342103733-31835-1-git-send-email-eliad@wizery.com> (sfid-20120712_163535_380290_B9EF48E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

on disassoc, ieee80211_set_disassoc() goes out of PS
before indicating BSS_CHANGED_ASSOC (not sure why this
is needed, but some drivers might count on the current
behavior).

However, it does it after sending the disassoc
frame, which results in null-data frame being sent
(in order to go out of ps) after we were already sent
the disassoc, which is invalid.

Fix it by going out of ps before sending the disassoc.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 671b9fd..9c74a1b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1365,6 +1365,17 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->sta_mtx);
 
+	/*
+	 * if we want to get out of ps before disassoc (why?) we have
+	 * to do it before sending disassoc, as otherwise the null-packet
+	 * won't be valid.
+	 */
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+	local->ps_sdata = NULL;
+
 	/* flush out any pending frame (e.g. DELBA) before deauth/disassoc */
 	if (tx)
 		drv_flush(local, false);
@@ -1400,12 +1411,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
-	local->ps_sdata = NULL;
-
 	/* Disable ARP filtering */
 	if (sdata->vif.bss_conf.arp_filter_enabled) {
 		sdata->vif.bss_conf.arp_filter_enabled = false;
-- 
1.7.6.401.g6a319

