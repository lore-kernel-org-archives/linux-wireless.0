Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbZBRXZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:25:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 10/15] cfg80211: remove likely from an 11d hint case
Date: Wed, 18 Feb 2009 18:25:40 -0500
Message-Id: <1234999545-14357-11-git-send-email-lrodriguez@atheros.com> (sfid-20090219_005320_412474_EA841E80)
In-Reply-To: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Truth of the matter this was confusing people so mark it as
unlikely as that is the case now.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b474452..69cd4f0 100644
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
+	if (unlikely(WARN_ON(reg_same_country_ie_hint(wiphy, checksum))))
 		goto out;
 
 	/* We keep this around for when CRDA comes back with a response so
-- 
1.6.0.3

