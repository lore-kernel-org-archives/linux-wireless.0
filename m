Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61877 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936308Ab3DJHV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 03:21:57 -0400
Received: by mail-pa0-f46.google.com with SMTP id lb1so161096pab.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 00:21:57 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: qca_vkondrat@qca.qualcomm.com, yunsenw@qca.qualcomm.com,
	kandala@qca.qualcomm.com, wireless-regdb@lists.infradead.org,
	green@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] wireless-regdb: enable VHT80 and VHT160 for JP
Date: Wed, 10 Apr 2013 00:21:50 -0700
Message-Id: <1365578510-4665-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130410_092201_548745_0E20FCD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

As per Michael Green we can enable VHT80 and VHT160 on
the enabled JP channels now. I've enabled them only for
the channels where either 80 MHz or 160 MHz actually fits
on the channel spacing for the band defined.

When passed to the kernel I have verified we get:

cfg80211: Regulatory domain changed to country: JP
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
cfg80211:   (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
cfg80211:   (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm)
cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2000 mBm)
cfg80211:   (5490000 KHz - 5710000 KHz @ 160000 KHz), (N/A, 2300 mBm)

Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Yunsen Wang <yunsenw@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index c878b27..22c975c 100644
--- a/db.txt
+++ b/db.txt
@@ -431,9 +431,9 @@ country JP:
 	(2474 - 2494 @ 20), (N/A, 20), NO-OFDM
 	(4910 - 4990 @ 40), (N/A, 23)
 	(5030 - 5090 @ 40), (N/A, 23)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 23), DFS
+	(5170 - 5250 @ 80), (N/A, 20)
+	(5250 - 5330 @ 80), (N/A, 20), DFS
+	(5490 - 5710 @ 160), (N/A, 23), DFS
 
 country JO:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4

