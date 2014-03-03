Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7761 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbaCCLjj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 06:39:39 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Stable <stable@vger.kernel.org>,
	Eliad Peller <eliadx.peller@intel.com>
Subject: [PATCH] mac80211: consider virtual mon when calculating min_def
Date: Mon,  3 Mar 2014 13:37:14 +0200
Message-Id: <1393846634-21264-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140303_124152_467955_33842E2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

When calculating the current max bw required for
a channel context, we didn't consider the virtual
monitor interface, resulting in its channel context
being narrower than configured.

Fixes: 21f659bf1f93 ("mac80211: add min required channel definition field")
Cc: Stable <stable@vger.kernel.org>  [3.12+]
Reported-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 net/mac80211/chan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..bd1fd8e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -100,6 +100,12 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 		}
 		max_bw = max(max_bw, width);
 	}
+
+	/* use the configured bandwidth in case of monitor interface */
+	sdata = rcu_dereference(local->monitor_sdata);
+	if (sdata && rcu_access_pointer(sdata->vif.chanctx_conf) == conf)
+		max_bw = max(max_bw, conf->def.width);
+
 	rcu_read_unlock();
 
 	return max_bw;
-- 
1.8.3.2

