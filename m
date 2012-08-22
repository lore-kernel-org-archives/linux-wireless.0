Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1434 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2HVIwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 04:52:39 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20532.40315.58985.214038@gargle.gargle.HOWL> (sfid-20120822_105254_956438_70E24DE4)
Date: Wed, 22 Aug 2012 14:21:07 +0530
To: <johannes@sipsolutions.net>
CC: <eyal@wizery.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix AP mode regression
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit mac80211: avoid using synchronize_rcu in ieee80211_set_probe_resp
changed the return value when the probe response template is not present.
Revert to the earlier value of 1 - this fixes AP mode for drivers like
ath9k.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 69b322f..929f897 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -740,7 +740,7 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	struct probe_resp *new, *old;
 
 	if (!resp || !resp_len)
-		return -EINVAL;
+		return 1;
 
 	old = rtnl_dereference(sdata->u.ap.probe_resp);
 
-- 
1.7.12

