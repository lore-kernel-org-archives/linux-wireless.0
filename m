Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22492 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbYJ3UeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:34:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:34:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/5] cfg80211: make use of reg macros on REG_RULE
Date: Thu, 30 Oct 2008 13:33:55 -0700
Message-ID: <1225398836-28633-5-git-send-email-lrodriguez@atheros.com> (sfid-20081030_213408_746889_DB20670B)
In-Reply-To: <1225398836-28633-4-git-send-email-lrodriguez@atheros.com>
References: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-2-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-3-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure regulatory converstion macros safely accept
multiple arguments and make REG_RULE() use them.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 03e1e88..81c97a7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -331,19 +331,19 @@ struct ieee80211_regdomain {
 	struct ieee80211_reg_rule reg_rules[];
 };
 
-#define MHZ_TO_KHZ(freq) (freq * 1000)
-#define KHZ_TO_MHZ(freq) (freq / 1000)
-#define DBI_TO_MBI(gain) (gain * 100)
-#define MBI_TO_DBI(gain) (gain / 100)
-#define DBM_TO_MBM(gain) (gain * 100)
-#define MBM_TO_DBM(gain) (gain / 100)
+#define MHZ_TO_KHZ(freq) ((freq) * 1000)
+#define KHZ_TO_MHZ(freq) ((freq) / 1000)
+#define DBI_TO_MBI(gain) ((gain) * 100)
+#define MBI_TO_DBI(gain) ((gain) / 100)
+#define DBM_TO_MBM(gain) ((gain) * 100)
+#define MBM_TO_DBM(gain) ((gain) / 100)
 
 #define REG_RULE(start, end, bw, gain, eirp, reg_flags) { \
-	.freq_range.start_freq_khz = (start) * 1000, \
-	.freq_range.end_freq_khz = (end) * 1000, \
-	.freq_range.max_bandwidth_khz = (bw) * 1000, \
-	.power_rule.max_antenna_gain = (gain) * 100, \
-	.power_rule.max_eirp = (eirp) * 100, \
+	.freq_range.start_freq_khz = MHZ_TO_KHZ(start), \
+	.freq_range.end_freq_khz = MHZ_TO_KHZ(end), \
+	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw), \
+	.power_rule.max_antenna_gain = DBI_TO_MBI(gain), \
+	.power_rule.max_eirp = DBM_TO_MBM(eirp), \
 	.flags = reg_flags, \
 	}
 
-- 
1.5.6.3

