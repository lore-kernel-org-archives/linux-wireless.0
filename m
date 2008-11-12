Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13695 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbYKLWWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 01/10] cfg80211: mark negative frequencies as invalid
Date: Wed, 12 Nov 2008 14:21:55 -0800
Message-ID: <1226528524-32678-2-git-send-email-lrodriguez@atheros.com> (sfid-20081112_232214_200518_3E66AB1E)
In-Reply-To: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regulatory rules with negative frequencies are now
marked as invalid in is_valid_reg_rule().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4c7e39d..7a2ce27 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -330,7 +330,7 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
 	u32 freq_diff;
 
-	if (freq_range->start_freq_khz == 0 || freq_range->end_freq_khz == 0)
+	if (freq_range->start_freq_khz <= 0 || freq_range->end_freq_khz <= 0)
 		return false;
 
 	if (freq_range->start_freq_khz > freq_range->end_freq_khz)
-- 
1.5.6.3

