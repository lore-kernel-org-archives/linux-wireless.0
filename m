Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:42612 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3CZLKD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 07:10:03 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] iw: don't print DFS states of disabled frequencies
Date: Tue, 26 Mar 2013 12:09:49 +0100
Message-Id: <1364296189-10386-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130326_121014_344806_3043DD76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, fix indentation.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 info.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/info.c b/info.c
index 3d4eaeb..209e882 100644
--- a/info.c
+++ b/info.c
@@ -183,17 +183,18 @@ next:
 						printf(")");
 					printf("\n");
 
-				if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]) {
-					enum nl80211_dfs_state state = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]);
-					unsigned long time;
-
-					printf("\t\t\t  DFS state: %s", dfs_state_name(state));
-					if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]) {
-						time = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]);
-						printf(" (for %lu sec)", time/1000);
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED] && tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]) {
+						enum nl80211_dfs_state state = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]);
+						unsigned long time;
+
+						printf("\t\t\t  DFS state: %s", dfs_state_name(state));
+						if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]) {
+							time = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]);
+							printf(" (for %lu sec)", time/1000);
+						}
+						printf("\n");
 					}
-					printf("\n");
-				}
+
 				}
 			}
 
-- 
1.7.4.1

