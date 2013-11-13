Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:56752 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab3KMRyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:54:21 -0500
Received: by mail-we0-f180.google.com with SMTP id u57so297243wes.25
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:54:20 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/5] cfg80211: distinguish unset DFS region from unknown
Date: Wed, 13 Nov 2013 18:54:04 +0100
Message-Id: <1384365246-24768-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185424_388207_50611294)
In-Reply-To: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 068cb40..740eccb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2152,6 +2152,9 @@ static void print_dfs_region(enum nl80211_dfs_regions dfs_region)
 		return;
 
 	switch (dfs_region) {
+	case NL80211_DFS_UNSET:
+		pr_info(" DFS Master region unset");
+		break;
 	case NL80211_DFS_FCC:
 		pr_info(" DFS Master region FCC");
 		break;
-- 
1.8.4.rc3

