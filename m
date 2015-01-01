Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35802 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbAALnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2015 06:43:20 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so23079605wgg.28
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jan 2015 03:43:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: skip disabled channels in VHT check
Date: Thu,  1 Jan 2015 13:43:17 +0200
Message-Id: <1420112597-4035-1-git-send-email-arik@wizery.com> (sfid-20150101_124326_050301_8BBDF6D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "40a11ca mac80211: check if channels allow 80 MHz for VHT
probe requests" considered disabled channels as VHT enabled, and
mistakenly sent out probe-requests with the VHT IE.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/mac80211/util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0f9bf47..ad8cb4f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1470,10 +1470,12 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 
 	/* Check if any channel in this sband supports at least 80 MHz */
 	for (i = 0; i < sband->n_channels; i++) {
-		if (!(sband->channels[i].flags & IEEE80211_CHAN_NO_80MHZ)) {
-			have_80mhz = true;
-			break;
-		}
+		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
+						IEEE80211_CHAN_NO_80MHZ))
+			continue;
+
+		have_80mhz = true;
+		break;
 	}
 
 	if (sband->vht_cap.vht_supported && have_80mhz) {
-- 
2.1.0

