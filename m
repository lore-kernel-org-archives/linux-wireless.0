Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63058 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3DWGyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 02:54:25 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Cover  60g regulatory class in ieee80211_operating_class_to_band
Date: Tue, 23 Apr 2013 09:54:21 +0300
Message-ID: <9494232.kA7XtV1HX3@lx-vladimir> (sfid-20130423_085429_424657_3814AC3E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In the function ieee80211_operating_class_to_band, introduced in commit
1ce3e82b0eb472161313183be0033e46d5c4bbaf cfg80211: add ieee80211_operating_class_to_band,
60GHz band is not covered. Patch below adds 60g.

Thanks, Vladimir

>From 6410ccd23df437531cd5b7c5d5c74f74cbfee3f1 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 23 Apr 2013 09:49:38 +0300
Subject: [PATCH] cfg80211: Cover  60g regulatory class in
 ieee80211_operating_class_to_band

Add regulatory class for 60GHz band, accordingly to the last specification.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/util.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index a7046a4..bb52486 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1169,6 +1169,9 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
 	case 84:
 		*band = IEEE80211_BAND_2GHZ;
 		return true;
+	case 180:
+		*band = IEEE80211_BAND_60GHZ;
+		return true;
 	}
 
 	return false;
-- 
1.7.10.4


