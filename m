Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50160 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaKYKXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 05:23:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe requests
Date: Tue, 25 Nov 2014 11:23:29 +0100
Message-Id: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net> (sfid-20141125_112336_239353_958B9666)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are no channels allowing 80 MHz to be used, then the
station isn't really VHT capable even if the driver and device
support it in general. In this case, exclude the VHT capability
IE from probe request frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bb9664cb8831..974ebe70f5b0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1339,6 +1339,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 	int ext_rates_len;
 	int shift;
 	u32 rate_flags;
+	bool have_80mhz = false;
 
 	*offset = 0;
 
@@ -1467,7 +1468,15 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 		*offset = noffset;
 	}
 
-	if (sband->vht_cap.vht_supported) {
+	/* Check if any channel in this sband supports at least 80 MHz */
+	for (i = 0; i < sband->n_channels; i++) {
+		if (!(sband->channels[i].flags & IEEE80211_CHAN_NO_80MHZ)) {
+			have_80mhz = true;
+			break;
+		}
+	}
+
+	if (sband->vht_cap.vht_supported && have_80mhz) {
 		if (end - pos < 2 + sizeof(struct ieee80211_vht_cap))
 			goto out_err;
 		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
-- 
2.1.1

