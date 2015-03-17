Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44758 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752814AbbCQOgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 10:36:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 16:36:01 +0200
Message-Id: <1426602961-9484-1-git-send-email-luca@coelho.fi> (sfid-20150317_153620_917673_C079DBB6)
Subject: [PATCH] nl80211: add net-detect delay to wowlan info
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Pass the initial net-detect delay (NL80211_ATTR_SCHED_SCAN_DELAY)
attribute in the WoWLAN info response.

Additionally, remove a bogus TODO comment.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9f14e32..7561338 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1099,8 +1099,6 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 	if (large && nl80211_send_wowlan_tcp_caps(rdev, msg))
 		return -ENOBUFS;
 
-	/* TODO: send wowlan net detect */
-
 	nla_nest_end(msg, nl_wowlan);
 
 	return 0;
@@ -8831,6 +8829,9 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_INTERVAL, req->interval))
 		return -ENOBUFS;
 
+	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_DELAY, req->delay))
+		return -ENOBUFS;
+
 	freqs = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
 	if (!freqs)
 		return -ENOBUFS;
-- 
2.1.4

