Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3FKSWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:22:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: Fix VHT bandwidth change event
Date: Tue, 11 Jun 2013 20:21:59 +0200
Message-Id: <1370974919-6117-1-git-send-email-johannes@sipsolutions.net> (sfid-20130611_202208_822753_A1333DD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/vht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 171344d..97c28941 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -396,7 +396,7 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	new_bw = ieee80211_sta_cur_vht_bw(sta);
 	if (new_bw != sta->sta.bandwidth) {
 		sta->sta.bandwidth = new_bw;
-		changed |= IEEE80211_RC_NSS_CHANGED;
+		changed |= IEEE80211_RC_BW_CHANGED;
 	}
 
  change:
-- 
1.8.0

