Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0AGWZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:25:01 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] cfg80211: add debug print when we drop a bogus country IE
Date: Thu,  7 Jan 2010 17:24:54 -0500
Message-Id: <1262903097-2129-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f79d661..389247c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1806,8 +1806,10 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 		goto out;
 
 	rd = country_ie_2_rd(country_ie, country_ie_len, &checksum);
-	if (!rd)
+	if (!rd) {
+		REG_DBG_PRINT("cfg80211: Ignoring bogus country IE\n");
 		goto out;
+	}
 
 	/*
 	 * This will not happen right now but we leave it here for the
-- 
1.6.3.3

