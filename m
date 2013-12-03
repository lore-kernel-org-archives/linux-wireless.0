Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:53254 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3LCIvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 03:51:00 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so9795561eak.39
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 00:50:59 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/4] nl80211: don't clear bitrate_mask twice
Date: Tue,  3 Dec 2013 09:50:44 +0100
Message-Id: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131203_095106_140870_E3F4DD0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't clear cfg80211_bitrate_mask twice in
nl80211_set_tx_bitrate_mask() function.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/nl80211.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c000449..c6401a8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7321,15 +7321,14 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	/* Default to all rates enabled */
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = rdev->wiphy.bands[i];
-		mask.control[i].legacy =
-			sband ? (1 << sband->n_bitrates) - 1 : 0;
-		if (sband)
-			memcpy(mask.control[i].mcs,
-			       sband->ht_cap.mcs.rx_mask,
-			       sizeof(mask.control[i].mcs));
-		else
-			memset(mask.control[i].mcs, 0,
-			       sizeof(mask.control[i].mcs));
+
+		if (!sband)
+			continue;
+
+		mask.control[i].legacy = (1 << sband->n_bitrates) - 1;
+		memcpy(mask.control[i].mcs,
+		       sband->ht_cap.mcs.rx_mask,
+		       sizeof(mask.control[i].mcs));
 	}
 
 	/*
-- 
1.7.9.5

