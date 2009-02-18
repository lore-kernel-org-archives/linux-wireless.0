Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26621 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZBREeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 23:34:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 20:34:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 10/15] cfg80211: remove likely from an 11d hint case
Date: Tue, 17 Feb 2009 20:21:57 -0800
Message-ID: <1234930922-29367-11-git-send-email-lrodriguez@atheros.com> (sfid-20090218_053417_434804_E1950F3E)
In-Reply-To: <1234930922-29367-1-git-send-email-lrodriguez@atheros.com>
References: <1234930922-29367-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
1.6.1.2.253.ga34a

