Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2KETav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 14:30:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use kstrtoull return value
Date: Mon,  5 Nov 2012 20:31:27 +0100
Message-Id: <1352143887-30654-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_203102_312615_D3ED23D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If kstrtoull() returns an error code (a value
smaller than zero), use it since it can be an
error other than -EINVAL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 99ce871..9b6afb3 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -423,7 +423,7 @@ static ssize_t ieee80211_if_parse_tsf(
 		}
 		ret = kstrtoull(buf, 10, &tsf);
 		if (ret < 0)
-			return -EINVAL;
+			return ret;
 		if (tsf_is_delta)
 			tsf = drv_get_tsf(local, sdata) + tsf_is_delta * tsf;
 		if (local->ops->set_tsf) {
-- 
1.8.0

