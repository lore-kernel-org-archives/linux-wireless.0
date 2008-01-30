Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195AbYA3QgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 11:36:14 -0500
Subject: [PATCH] wireless: fix ERP rate flags
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 17:36:10 +0100
Message-Id: <1201710970.4149.23.camel@johannes.berg> (sfid-20080130_163631_794425_539D888C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the rate API patch I accidentally reverted the test for
ERP rates, this fixes it. All rates except 1, 2, 5.5 and 11
MBit are ERP rates, not those.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/util.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- everything.orig/net/wireless/util.c	2008-01-30 17:33:46.643217990 +0100
+++ everything/net/wireless/util.c	2008-01-30 17:33:59.603217177 +0100
@@ -73,10 +73,10 @@ static void set_mandatory_flags_band(str
 				want--;
 			}
 
-			if (sband->bitrates[i].bitrate == 10 ||
-			    sband->bitrates[i].bitrate == 20 ||
-			    sband->bitrates[i].bitrate == 55 ||
-			    sband->bitrates[i].bitrate == 110)
+			if (sband->bitrates[i].bitrate != 10 &&
+			    sband->bitrates[i].bitrate != 20 &&
+			    sband->bitrates[i].bitrate != 55 &&
+			    sband->bitrates[i].bitrate != 110)
 				sband->bitrates[i].flags |=
 					IEEE80211_RATE_ERP_G;
 		}


