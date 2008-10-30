Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22488 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYJ3Ud7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:33:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:33:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/5] cfg80211: a reg rule is invalid if freq diff is 0
Date: Thu, 30 Oct 2008 13:33:52 -0700
Message-ID: <1225398836-28633-2-git-send-email-lrodriguez@atheros.com> (sfid-20081030_213403_960979_DB76CB8C)
In-Reply-To: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com>
References: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A regulatory rule is invalid when the frequency difference
between the end of the frequency range and the start is 0.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9dff716..a23cc82 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -321,7 +321,7 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 
-	if (freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_diff <= 0 || freq_range->max_bandwidth_khz > freq_diff)
 		return false;
 
 	return true;
-- 
1.5.6.3

