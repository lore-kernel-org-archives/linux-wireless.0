Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZBUFEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:04:42 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 11/15] cfg80211: free rd on unlikely event on 11d hint
Date: Sat, 21 Feb 2009 00:04:29 -0500
Message-Id: <1235192673-6314-12-git-send-email-lrodriguez@atheros.com> (sfid-20090221_060449_644419_81A0EA8B)
In-Reply-To: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was never happening but it was still wrong, so correct it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index baf50ca..af762be 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1341,7 +1341,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	 * it as it would indicate a mistake in the current design
 	 */
 	if (WARN_ON(reg_same_country_ie_hint(wiphy, checksum)))
-		goto out;
+		goto free_rd_out;
 
 	/* We keep this around for when CRDA comes back with a response so
 	 * we can intersect with that */
@@ -1350,6 +1350,10 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	__regulatory_hint(wiphy, REGDOM_SET_BY_COUNTRY_IE,
 		country_ie_regdomain->alpha2, checksum, env);
 
+	goto out;
+
+free_rd_out:
+	kfree(rd);
 out:
 	mutex_unlock(&cfg80211_mutex);
 }
-- 
1.6.0.3

