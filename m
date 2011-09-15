Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55928 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IOMKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:10:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] wireless: Do not allow disabled channel in scan request
Date: Thu, 15 Sep 2011 17:40:50 +0530
Message-ID: <1316088650-4815-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_141021_454088_2BA9BB35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_conn_scan allows disabled channels at scan request.
Hence probe request was seen at the disabled one. This patch
ensures that disabled channel never be added into the scan
request's channel list.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/sme.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index dec0fa2..6e86d5a 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -110,17 +110,22 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	else {
 		int i = 0, j;
 		enum ieee80211_band band;
+		struct ieee80211_supported_band *bands;
+		struct ieee80211_channel *channel;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-			if (!wdev->wiphy->bands[band])
+			bands = wdev->wiphy->bands[band];
+			if (!bands)
 				continue;
-			for (j = 0; j < wdev->wiphy->bands[band]->n_channels;
-			     i++, j++)
-				request->channels[i] =
-					&wdev->wiphy->bands[band]->channels[j];
-			request->rates[band] =
-				(1 << wdev->wiphy->bands[band]->n_bitrates) - 1;
+			for (j = 0; j < bands->n_channels; j++) {
+				channel = &bands->channels[j];
+				if (channel->flags & IEEE80211_CHAN_DISABLED)
+					continue;
+				request->channels[i++] = channel;
+			}
+			request->rates[band] = (1 << bands->n_bitrates) - 1;
 		}
+		n_channels = i;
 	}
 	request->n_channels = n_channels;
 	request->ssids = (void *)&request->channels[n_channels];
-- 
1.7.6.1

