Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYLATdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:33:25 -0500
Subject: [PATCH] cfg80211: "fix" 11d oops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 18:13:05 +0100
Message-Id: <1228151585.10627.1.camel@johannes.berg> (sfid-20081201_203329_385094_759344CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This "fixes" the 11d oops I was seeing. This needs some more work but I
cannot work on it now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    3 +++
 1 file changed, 3 insertions(+)

--- everything.orig/net/wireless/reg.c	2008-12-01 18:10:15.000000000 +0100
+++ everything/net/wireless/reg.c	2008-12-01 18:10:24.000000000 +0100
@@ -989,6 +989,9 @@ void regulatory_hint_11d(struct wiphy *w
 	u32 checksum = 0;
 	enum environment_cap env = ENVIRON_ANY;
 
+	if (!last_request)
+		return;
+
 	mutex_lock(&cfg80211_drv_mutex);
 
 	/* IE len must be evenly divisible by 2 */


