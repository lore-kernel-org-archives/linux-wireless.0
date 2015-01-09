Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46276 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbbAIKto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 05:49:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211_hwsim: fix PS debugfs file locking
Date: Fri,  9 Jan 2015 11:49:38 +0100
Message-Id: <1420800579-18723-1-git-send-email-johannes@sipsolutions.net> (sfid-20150109_114948_632204_935B5E3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The functions called within the iterators must be called with
tasklets disabled, so use atomic iteration like the rest of
the code and disable tasklets around the whole operation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 057a99e01637..74f4e1c18322 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -626,22 +626,22 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
 	old_ps = data->ps;
 	data->ps = val;
 
+	local_bh_disable();
 	if (val == PS_MANUAL_POLL) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    hwsim_send_ps_poll, data);
+		ieee80211_iterate_active_interfaces_atomic(
+			data->hw, IEEE80211_IFACE_ITER_NORMAL,
+			hwsim_send_ps_poll, data);
 		data->ps_poll_pending = true;
 	} else if (old_ps == PS_DISABLED && val != PS_DISABLED) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    hwsim_send_nullfunc_ps,
-						    data);
+		ieee80211_iterate_active_interfaces_atomic(
+			data->hw, IEEE80211_IFACE_ITER_NORMAL,
+			hwsim_send_nullfunc_ps, data);
 	} else if (old_ps != PS_DISABLED && val == PS_DISABLED) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    hwsim_send_nullfunc_no_ps,
-						    data);
+		ieee80211_iterate_active_interfaces_atomic(
+			data->hw, IEEE80211_IFACE_ITER_NORMAL,
+			hwsim_send_nullfunc_no_ps, data);
 	}
+	local_bh_enable();
 
 	return 0;
 }
-- 
2.1.1

