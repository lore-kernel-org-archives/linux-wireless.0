Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35998 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbcE3CzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 22:55:02 -0400
Date: Sun, 29 May 2016 19:54:52 -0700
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ruchandani.tina@gmail.com,
	netdev@vger.kernel.org, Julian.Calaby@gmail.com
Subject: [PATCH v2 10/10] nl80211: Prefer kcalloc over kzalloc
Message-ID: <ca13e9bde679512a872e5136c177676d0238dc25.1464576022.git.kirtika.ruchandani@gmail.com> (sfid-20160530_045517_961853_10E8370F)
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl warning -
"prefer kcalloc over kzalloc with multiply"

Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46757af..2964406 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9482,7 +9482,7 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
 	struct nlattr **tb;
 	int err;

-	tb = kzalloc(NUM_NL80211_ATTR * sizeof(*tb), GFP_KERNEL);
+	tb = kcalloc(NUM_NL80211_ATTR, sizeof(*tb), GFP_KERNEL);
 	if (!tb)
 		return -ENOMEM;

--
2.8.0.rc3.226.g39d4020

