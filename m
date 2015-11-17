Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbKQIY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 8/8] mac80211: don't teardown sdata on sdata stop
Date: Tue, 17 Nov 2015 10:24:40 +0200
Message-Id: <1447748680-23075-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092506_152322_F389191F)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Interfaces are being initialized (setup) on addition,
and torn down on removal.

However, p2p device is being torn down when stopped,
resulting in the next p2p start operation being done
on uninitialized interface.

Solve it by calling ieee80211_teardown_sdata() only
on interface removal (for the non-netdev case).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/iface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 53ee049..d6a1a46 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1861,6 +1861,7 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	if (sdata->dev) {
 		unregister_netdevice(sdata->dev);
 	} else {
+		ieee80211_teardown_sdata(sdata);
 		cfg80211_unregister_wdev(&sdata->wdev);
 		kfree(sdata);
 	}
@@ -1871,7 +1872,6 @@ void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata)
 	if (WARN_ON_ONCE(!test_bit(SDATA_STATE_RUNNING, &sdata->state)))
 		return;
 	ieee80211_do_stop(sdata, true);
-	ieee80211_teardown_sdata(sdata);
 }
 
 void ieee80211_remove_interfaces(struct ieee80211_local *local)
-- 
2.5.0

