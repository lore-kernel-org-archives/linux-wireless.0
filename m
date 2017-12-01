Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48300 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752124AbdLALvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 06:51:02 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Adiel Aloni <adiel.aloni@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  1 Dec 2017 13:50:53 +0200
Message-Id: <20171201115053.29608-4-luca@coelho.fi> (sfid-20171201_125108_438839_92663106)
In-Reply-To: <20171201115053.29608-1-luca@coelho.fi>
References: <20171201115053.29608-1-luca@coelho.fi>
Subject: [PATCH 3/3] mac80211_hwsim: enforce PS_MANUAL_POLL to be set after PS_ENABLED
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adiel Aloni <adiel.aloni@intel.com>

Enforce using PS_MANUAL_POLL in ps hwsim debugfs to trigger a poll,
only if PS_ENABLED was set before.
This is required due to commit c9491367b759 ("mac80211: always update the
PM state of a peer on MGMT / DATA frames") that enforces the ap to
check only mgmt/data frames ps bit, and then update station's power save
accordingly.
When sending only ps-poll (control frame) the ap will not be aware that
the station entered power save.
Setting ps enable before triggering ps_poll, will send NDP with PM bit
enabled first.

Signed-off-by: Adiel Aloni <adiel.aloni@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ec2f4c31425a..719ce06007c6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -727,16 +727,21 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
 	    val != PS_MANUAL_POLL)
 		return -EINVAL;
 
-	old_ps = data->ps;
-	data->ps = val;
-
-	local_bh_disable();
 	if (val == PS_MANUAL_POLL) {
+		if (data->ps != PS_ENABLED)
+			return -EINVAL;
+		local_bh_disable();
 		ieee80211_iterate_active_interfaces_atomic(
 			data->hw, IEEE80211_IFACE_ITER_NORMAL,
 			hwsim_send_ps_poll, data);
-		data->ps_poll_pending = true;
-	} else if (old_ps == PS_DISABLED && val != PS_DISABLED) {
+		local_bh_enable();
+		return 0;
+	}
+	old_ps = data->ps;
+	data->ps = val;
+
+	local_bh_disable();
+	if (old_ps == PS_DISABLED && val != PS_DISABLED) {
 		ieee80211_iterate_active_interfaces_atomic(
 			data->hw, IEEE80211_IFACE_ITER_NORMAL,
 			hwsim_send_nullfunc_ps, data);
-- 
2.15.0
