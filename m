Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48393 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2DMLH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 07:07:58 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] cfg80211: increse bss expire time
Date: Fri, 13 Apr 2012 16:38:40 +0530
Message-ID: <1334315320-4913-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120413_130801_478464_4B59ACFC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The background scan completion takes more time when the station is
having heavy uplink traffic. The scan state machine decides to fall
back to home channel on every off-channel visit when there are pending
frames in tx queue. bgscan completion took ~30sec on dual band US
regulatory card.

scan period = (20 active channels * probe timeout) +
              (12 passive channels * passive probe timeout) +
              (32 * timeout on home channel) +
              (32 * flush timeout)

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index fdbcfe6..1442bb6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -18,7 +18,7 @@
 #include "nl80211.h"
 #include "wext-compat.h"
 
-#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
+#define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
-- 
1.7.10

