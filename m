Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57842 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab0IRTd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 15:33:56 -0400
Received: by fxm3 with SMTP id 3so103190fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 12:33:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: clear txflags for filtered/retried frames
Date: Sat, 18 Sep 2010 21:33:49 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009182133.50104.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes stale mac80211_tx_control_flags for
filtered / retried frames.

Because ieee80211_handle_filtered_frame injects the skbs
back into the tx path, they have to be stripped of old tx
flags which might confuse the stack or driver.
---
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 571b32b..17d98a2 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -58,6 +58,15 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	info->control.vif = &sta->sdata->vif;
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
 		       IEEE80211_TX_INTFL_RETRANSMISSION;
+	info->flags &= ~(IEEE80211_TX_CTL_RATE_CTRL_PROBE |
+			 IEEE80211_TX_CTL_PSPOLL_RESPONSE |
+			 IEEE80211_TX_CTL_FIRST_FRAGMENT |
+			 IEEE80211_TX_CTL_CLEAR_PS_FILT |
+			 IEEE80211_TX_CTL_MORE_FRAMES |
+			 IEEE80211_TX_CTL_AMPDU |
+			 IEEE80211_TX_STAT_AMPDU_NO_BACK |
+			 IEEE80211_TX_STAT_TX_FILTERED |
+			 IEEE80211_TX_STAT_AMPDU);
 
 	sta->tx_filtered_count++;
 
