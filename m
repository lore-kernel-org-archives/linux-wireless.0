Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37889 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3BFNRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 08:17:52 -0500
Received: by mail-ea0-f169.google.com with SMTP id d13so606889eaa.14
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 05:17:51 -0800 (PST)
From: Emanuel Taube <emanuel.taube@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Emanuel Taube <emanuel.taube@gmail.com>
Subject: [PATCH] mac80211: Add the DS Params for mesh to every band
Date: Wed,  6 Feb 2013 14:17:17 +0100
Message-Id: <1360156637-30926-1-git-send-email-emanuel.taube@gmail.com> (sfid-20130206_141756_426211_F24E642C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There seems to be no reason, why it has to be limited to 2.4 GHz.

Signed-off-by: Emanuel Taube <emanuel.taube@gmail.com>
---
 net/mac80211/mesh.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 694e273..cedb6e3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -343,7 +343,6 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 			  struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
 	u8 *pos;
@@ -360,13 +359,10 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
 
-	sband = local->hw.wiphy->bands[chan->band];
-	if (sband->band == IEEE80211_BAND_2GHZ) {
-		pos = skb_put(skb, 2 + 1);
-		*pos++ = WLAN_EID_DS_PARAMS;
-		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(chan->center_freq);
-	}
+	pos = skb_put(skb, 2 + 1);
+	*pos++ = WLAN_EID_DS_PARAMS;
+	*pos++ = 1;
+	*pos++ = ieee80211_frequency_to_channel(chan->center_freq);
 
 	return 0;
 }
-- 
1.7.10.4

