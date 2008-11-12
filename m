Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13758 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYKLWWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 07/10] cfg80211: mark regdomains with > NL80211_MAX_SUPP_REG_RULES invalid
Date: Wed, 12 Nov 2008 14:22:01 -0800
Message-ID: <1226528524-32678-8-git-send-email-lrodriguez@atheros.com> (sfid-20081112_232222_012554_4E591532)
In-Reply-To: <1226528524-32678-7-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-3-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-4-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-5-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-6-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lets remain consistent and mark rds with > NL80211_MAX_SUPP_REG_RULES
number of reg rules as invalid in is_valid_rd().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f8e7beb..f0ff3d1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -352,6 +352,9 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 	if (!rd->n_reg_rules)
 		return false;
 
+	if (WARN_ON(rd->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
+		return false;
+
 	for (i = 0; i < rd->n_reg_rules; i++) {
 		reg_rule = &rd->reg_rules[i];
 		if (!is_valid_reg_rule(reg_rule))
-- 
1.5.6.3

