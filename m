Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597AbZEMVEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:04:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] cfg80211: return immediately if num reg rules > NL80211_MAX_SUPP_REG_RULES
Date: Wed, 13 May 2009 17:04:39 -0400
Message-Id: <1242248682-22051-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no functional change except we save a kfree(rd) and
allows us to clean this code up a bit after this. We do
avoid an unnecessary kfree(NULL) but calling that was OK too.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f88dbbe..88cb4ab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2542,7 +2542,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			rem_reg_rules) {
 		num_rules++;
 		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
-			goto bad_reg;
+			return -EINVAL;
 	}
 
 	if (!reg_is_valid_request(alpha2))
-- 
1.6.0.6

