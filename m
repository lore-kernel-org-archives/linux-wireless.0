Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37608 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaJGJmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 05:42:40 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so7251410wiv.12
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 02:42:38 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] cfg80211: set the rates mask in connection probes over specified freq
Date: Tue,  7 Oct 2014 11:42:18 +0200
Message-Id: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com> (sfid-20141007_114247_064175_27E2D816)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM, specifying the frequency when connecting sends a void 'supported
rates' EID.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/wireless/sme.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8bbeeb3..2ebc54b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -80,9 +80,16 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	if (!request)
 		return -ENOMEM;
 
-	if (wdev->conn->params.channel)
+	if (wdev->conn->params.channel) {
+		enum ieee80211_band band = wdev->conn->params.channel->band;
+		struct ieee80211_supported_band *sband =
+			wdev->wiphy->bands[band];
+
+		if (!sband)
+			return -EINVAL;
 		request->channels[0] = wdev->conn->params.channel;
-	else {
+		request->rates[band] = (1 << sband->n_bitrates) - 1;
+	} else {
 		int i = 0, j;
 		enum ieee80211_band band;
 		struct ieee80211_supported_band *bands;
-- 
2.0.1

