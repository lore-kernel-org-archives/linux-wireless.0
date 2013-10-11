Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gecko.sbs.de ([194.138.37.40]:20283 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466Ab3JKMUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 08:20:37 -0400
From: Dennis H Jensen <dennis.h.jensen@siemens.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Dennis H Jensen <dennis.h.jensen@siemens.com>
Subject: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz range
Date: Fri, 11 Oct 2013 13:59:40 +0200
Message-Id: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com> (sfid-20131011_142127_928295_0B71DA93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the frequencies (5910 - 5980) cannot be used because they
are mapped into the 4.9GHz channels; this patch closes that hole.

Signed-off-by: Dennis H Jensen <dennis.h.jensen@siemens.com>
---
 net/wireless/util.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3c8be61..59b763f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -79,6 +79,8 @@ int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
 	case IEEE80211_BAND_5GHZ:
 		if (chan >= 182 && chan <= 196)
 			return 4000 + chan * 5;
+		else if (chan > 196)
+			return 5000 + (chan - 15) * 5;
 		else
 			return 5000 + chan * 5;
 		break;
@@ -102,6 +104,8 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
+	else if (freq >= 5910)
+		return (freq - 5000) / 5 + 15;
 	else if (freq <= 45000) /* DMG band lower limit */
 		return (freq - 5000) / 5;
 	else if (freq >= 58320 && freq <= 64800)
-- 
1.7.9.5

