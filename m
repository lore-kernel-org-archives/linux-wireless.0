Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47982 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3EKAvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 20:51:05 -0400
Received: by mail-pd0-f169.google.com with SMTP id bv13so3101671pdb.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 17:51:05 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, ashok@cozybit.com
Subject: [PATCH 2/3] cfg80211: Allow ieee80211g mandatory rate sets in 2.4GHz band
Date: Fri, 10 May 2013 17:50:52 -0700
Message-Id: <1368233453-10581-2-git-send-email-ashok@cozybit.com> (sfid-20130511_025125_243031_9E9F2BB4)
In-Reply-To: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the current logic of ieee80211_mandatory_rates(), only 11b mandatory rates
are returned when operating in 2.4GHz band. 802.11g mandatory rates are not
fetched even if the operating mode is 11g. This patch assumes 11g support
implies a 11g operation and returns the appropriate mandatory rates.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/wireless/util.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index d6727f2..d4e3dfa 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -43,12 +43,19 @@ u32 ieee80211_mandatory_rates(struct ieee80211_supported_band *sband)
 	if (WARN_ON(!sband))
 		return 1;
 
-	if (sband->band == IEEE80211_BAND_2GHZ)
-		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
-	else
+	bitrates = sband->bitrates;
+	if (sband->band == IEEE80211_BAND_5GHZ)
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
+	else {
+		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+		for (i = 0; i < sband->n_bitrates; i++)
+			if (bitrates[i].bitrate > 110) {
+				mandatory_flag =
+					IEEE80211_RATE_MANDATORY_G;
+				break;
+			}
+	}
 
-	bitrates = sband->bitrates;
 	for (i = 0; i < sband->n_bitrates; i++)
 		if (bitrates[i].flags & mandatory_flag)
 			mandatory_rates |= BIT(i);
-- 
1.7.5.4

