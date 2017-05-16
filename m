Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55195 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdEPJXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:48 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6/7] mac80211: enable VHT for mesh channel processing
Date: Tue, 16 May 2017 11:23:15 +0200
Message-Id: <20170516092316.15636-7-sw@simonwunderlich.de> (sfid-20170516_112817_777559_43F067C4)
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
References: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/mesh.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7c6593c0d453..a57af5df7ee4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -991,12 +991,14 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	if (!sband)
 		return false;
 
-	sta_flags = IEEE80211_STA_DISABLE_VHT;
+	sta_flags = 0;
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		sta_flags |= IEEE80211_STA_DISABLE_HT;
 	case NL80211_CHAN_WIDTH_20:
 		sta_flags |= IEEE80211_STA_DISABLE_40MHZ;
+	case NL80211_CHAN_WIDTH_40:
+		sta_flags |= IEEE80211_STA_DISABLE_VHT;
 		break;
 	default:
 		break;
-- 
2.11.0
