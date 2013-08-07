Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:46926 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab3HGIgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 04:36:10 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] mac80211: ibss - immediately create a cell if bssid and freq have been provided
Date: Wed,  7 Aug 2013 10:08:37 +0200
Message-Id: <1375862917-3625-1-git-send-email-ordex@autistici.org> (sfid-20130807_103616_483742_6373090B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

The current behaviour when not finding the cbss in the local
list is to always scan before creating the IBSS. However if
bssid and freq have been provided (and fixed_freq is set) it
is possible to immediately create the cell and avoid wasting
time with the scan operation.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e08387c..811207a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -891,6 +891,17 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
+	/* if a fixed bssid and a fixed freq have been provided create the IBSS
+	 * directly and do not waste time scanning
+	 */
+	if (!cbss && ifibss->fixed_bssid && ifibss->fixed_channel) {
+		sdata_info(sdata, "Created IBSS using preconfigured BSSID %pM\n",
+			   bssid);
+		ieee80211_sta_create_ibss(sdata);
+		return;
+	}
+
+
 	ibss_dbg(sdata, "sta_find_ibss: did not try to join ibss\n");
 
 	/* Selected IBSS not found in current scan results - try to scan */
-- 
1.8.1.5

