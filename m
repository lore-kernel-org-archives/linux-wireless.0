Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbbKQIYy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/8] mac80211: ensure we don't update tx power on a non-running sdata
Date: Tue, 17 Nov 2015 10:24:39 +0200
Message-Id: <1447748680-23075-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092504_033142_93D1F422)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't update the Tx power on the device unless it is
running.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=101521.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/iface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d0dc1bf..53ee049 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -76,7 +76,8 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata,
 			      bool update_bss)
 {
-	if (__ieee80211_recalc_txpower(sdata) || update_bss)
+	if (__ieee80211_recalc_txpower(sdata) ||
+	    (update_bss && ieee80211_sdata_running(sdata)))
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
 }
 
-- 
2.5.0

