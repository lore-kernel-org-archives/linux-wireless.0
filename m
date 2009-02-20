Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZBTFnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 00:43:11 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 10/15] cfg80211: remove likely from an 11d hint case
Date: Fri, 20 Feb 2009 00:42:45 -0500
Message-Id: <1235108570-17652-11-git-send-email-lrodriguez@atheros.com> (sfid-20090220_065322_546001_AD31EF49)
In-Reply-To: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
References: <1235108570-17652-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Truth of the matter this was confusing people so mark it as
unlikely as that is the case now.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b474452..baf50ca 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1331,14 +1331,16 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	if (!rd)
 		goto out;
 
-	/* This will not happen right now but we leave it here for the
+	/*
+	 * This will not happen right now but we leave it here for the
 	 * the future when we want to add suspend/resume support and having
 	 * the user move to another country after doing so, or having the user
-	 * move to another AP. Right now we just trust the first AP. This is why
-	 * this is marked as likley(). If we hit this before we add this support
-	 * we want to be informed of it as it would indicate a mistake in the
-	 * current design  */
-	if (likely(WARN_ON(reg_same_country_ie_hint(wiphy, checksum))))
+	 * move to another AP. Right now we just trust the first AP.
+	 *
+	 * If we hit this before we add this support we want to be informed of
+	 * it as it would indicate a mistake in the current design
+	 */
+	if (WARN_ON(reg_same_country_ie_hint(wiphy, checksum)))
 		goto out;
 
 	/* We keep this around for when CRDA comes back with a response so
-- 
1.6.0.3

