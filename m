Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3HUKFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 06:05:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3.11] mac80211: add missing channel context release
Date: Wed, 21 Aug 2013 12:04:56 +0200
Message-Id: <1377079496-27797-1-git-send-email-johannes@sipsolutions.net> (sfid-20130821_120502_794203_50AA32F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS needs to release the channel context when leaving
but I evidently missed that. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ea7b9c2..5e8bb3b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1138,6 +1138,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
+	ieee80211_vif_release_channel(sdata);
 	synchronize_rcu();
 	kfree(presp);
 
-- 
1.8.4.rc2

