Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3J1OIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:08:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] nl80211: fix error path in nl80211_get_key()
Date: Mon, 28 Oct 2013 15:08:22 +0100
Message-Id: <1382969304-25611-2-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150834_298269_E4589C6E)
In-Reply-To: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net>
References: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Coverity pointed out that in the (practically impossible)
error case we leak the message - fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1fef427..22df144 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2668,7 +2668,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_NEW_KEY);
 	if (!hdr)
-		return -ENOBUFS;
+		goto nla_put_failure;
 
 	cookie.msg = msg;
 	cookie.idx = key_idx;
-- 
1.8.4.rc3

