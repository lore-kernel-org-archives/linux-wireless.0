Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:54937 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936269Ab3DIPtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:49:47 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211 allow HT override of ampdu factor/density
Date: Tue,  9 Apr 2013 17:49:39 +0200
Message-Id: <1365522579-20771-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130409_174951_558534_9705BDF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the current implementation, amdpu changes are applied to own_cap,
but never actually applied to the stations ht settings, leaving these
overrides without effect.

Fix this by using the minimum (factor) or maximum (density) of the
respective remote and own ampdu values.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
This seems to be regression, as this patch was not required in 3.7, most
probably "mac80211: fix HT capability overrides for AP station".
---
 net/mac80211/ht.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index af8cee0..e433c78 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -141,9 +141,11 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 
 	ampdu_info = ht_cap_ie->ampdu_params_info;
 	ht_cap.ampdu_factor =
-		ampdu_info & IEEE80211_HT_AMPDU_PARM_FACTOR;
+		min(ampdu_info & IEEE80211_HT_AMPDU_PARM_FACTOR,
+		    own_cap.ampdu_factor);
 	ht_cap.ampdu_density =
-		(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
+		max((ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2,
+		    own_cap.ampdu_density);
 
 	/* own MCS TX capabilities */
 	tx_mcs_set_cap = own_cap.mcs.tx_params;
-- 
1.7.10.4

