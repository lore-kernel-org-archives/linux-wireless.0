Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47368 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932193AbcLMIlc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 03:41:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't call drv_set_default_unicast_key() for VLANs
Date: Tue, 13 Dec 2016 09:41:29 +0100
Message-Id: <20161213084129.8268-1-johannes@sipsolutions.net> (sfid-20161213_094135_577435_195D0687)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since drivers know nothing about AP_VLAN interfaces, trying to
call drv_set_default_unicast_key() just results in a warning
and no call to the driver. Avoid the warning by not calling the
driver for this on AP_VLAN interfaces.

This means that drivers that somehow need this call for AP mode
will fail to work properly in the presence of VLAN interfaces,
but the current drivers don't seem to use it, and mac80211 will
select and indicate the key - so drivers should be OK now.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index edd6f2945f69..a98fc2b5e0dc 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -265,7 +265,8 @@ static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 	if (uni) {
 		rcu_assign_pointer(sdata->default_unicast_key, key);
 		ieee80211_check_fast_xmit_iface(sdata);
-		drv_set_default_unicast_key(sdata->local, sdata, idx);
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+			drv_set_default_unicast_key(sdata->local, sdata, idx);
 	}
 
 	if (multi)
-- 
2.9.3
