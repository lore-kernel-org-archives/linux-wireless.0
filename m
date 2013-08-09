Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:60729 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967928Ab3HIRBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 13:01:18 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv2] mac80211: ibss - do not scan if not needed when creating an IBSS
Date: Fri,  9 Aug 2013 18:58:32 +0200
Message-Id: <1376067512-733-1-git-send-email-ordex@autistici.org> (sfid-20130809_190121_441903_C7093BF3)
In-Reply-To: <1375862917-3625-1-git-send-email-ordex@autistici.org>
References: <1375862917-3625-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

In some cases mac80211 will scan before creating an IBSS
even if bssid and frequency have been forced by the user.
This is not needed and leads only to a delay in the IBSS
establishment phase.

Immediately create the cell if both bssid and frequency
(and fixed_freq is set) have been specified.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/ibss.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e08387c..79e294e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -891,6 +891,17 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
+	/* if a fixed bssid and a fixed freq have been provided create the IBSS
+	 * directly and do not waste time scanning
+	 */
+	if (ifibss->fixed_bssid && ifibss->fixed_channel) {
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

