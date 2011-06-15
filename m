Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27611 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1FOWCx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 18:02:53 -0400
Subject: [PATCH] mac80211: use BUG_ON and return -EINVAL if
 rate_lowest_index() fails
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 15 Jun 2011 18:02:52 -0400
Message-ID: <20110615220252.1918.73638.stgit@mj.roinet.com> (sfid-20110616_000256_270703_19F4D5F9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARN_ON is not enough, as we cannot return a valid index, and the
callers will use whatever we return, causing a cascade of oopses and
eventually a panic.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e33fe79..d117019 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3108,10 +3108,10 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
 		if (rate_supported(sta, sband->band, i))
 			return i;
 
-	/* warn when we cannot find a rate. */
-	WARN_ON(1);
+	/* If we cannot find any rate, we are in trouble. */
+	BUG_ON(1);
 
-	return 0;
+	return -EINVAL;
 }
 
 static inline
