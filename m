Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28768 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKFUpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 15:45:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 12:45:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] cfg80211: mark regdomains with > NL80211_MAX_SUPP_REG_RULES invalid
Date: Thu, 6 Nov 2008 12:45:26 -0800
Message-ID: <1226004327-10290-3-git-send-email-lrodriguez@atheros.com> (sfid-20081106_214539_185815_93094F6F)
In-Reply-To: <1226004327-10290-2-git-send-email-lrodriguez@atheros.com>
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
 <1226004327-10290-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lets remain consistent and mark rds with > NL80211_MAX_SUPP_REG_RULES
number of reg rules as invalid in is_valid_rd().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
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

