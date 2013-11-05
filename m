Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41922 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3KENtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:49:04 -0500
Received: by mail-ee0-f48.google.com with SMTP id d49so1821831eek.35
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 05:49:03 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 3/5] cfg80211: add helper functions for start/end freq
Date: Tue,  5 Nov 2013 14:48:47 +0100
Message-Id: <1383659329-11023-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144916_521884_3351EB76)
In-Reply-To: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add helper fuctions for start/end freq.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/chan.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 3449664..1d25a46 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -277,6 +277,32 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 				     width, dfs_state);
 }
 
+static u32 cfg80211_get_start_freq(u32 center_freq,
+				   u32 bandwidth)
+{
+	u32 start_freq;
+
+	if (bandwidth <= 20)
+		start_freq = center_freq;
+	else
+		start_freq = center_freq - bandwidth/2 + 10;
+
+	return start_freq;
+}
+
+static u32 cfg80211_get_end_freq(u32 center_freq,
+				 u32 bandwidth)
+{
+	u32 end_freq;
+
+	if (bandwidth <= 20)
+		end_freq = center_freq;
+	else
+		end_freq = center_freq + bandwidth/2 - 10;
+
+	return end_freq;
+}
+
 static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 					    u32 center_freq,
 					    u32 bandwidth)
@@ -284,13 +310,8 @@ static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 	struct ieee80211_channel *c;
 	u32 freq, start_freq, end_freq;
 
-	if (bandwidth <= 20) {
-		start_freq = center_freq;
-		end_freq = center_freq;
-	} else {
-		start_freq = center_freq - bandwidth/2 + 10;
-		end_freq = center_freq + bandwidth/2 - 10;
-	}
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
 
 	for (freq = start_freq; freq <= end_freq; freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
@@ -337,13 +358,8 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 	struct ieee80211_channel *c;
 	u32 freq, start_freq, end_freq;
 
-	if (bandwidth <= 20) {
-		start_freq = center_freq;
-		end_freq = center_freq;
-	} else {
-		start_freq = center_freq - bandwidth/2 + 10;
-		end_freq = center_freq + bandwidth/2 - 10;
-	}
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
 
 	for (freq = start_freq; freq <= end_freq; freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
-- 
1.7.9.5

