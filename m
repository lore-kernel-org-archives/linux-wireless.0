Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42491 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1BGVow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 16:44:52 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 7/7] mac80211:  Ensure power-level set properly for scanning.
Date: Mon,  7 Feb 2011 13:44:38 -0800
Message-Id: <1297115078-27773-7-git-send-email-greearb@candelatech.com>
In-Reply-To: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

My previous patch to optimize scanning on operating channel
accidentally removed the code that would ensure power was
set to maximum for scanning.

This patch re-adds that functionality.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 86562ce... e7eb2cf... M	net/mac80211/main.c
:100644 100644 1f277c9... ab8d2c6... M	net/mac80211/scan.c
 net/mac80211/main.c |    3 ++-
 net/mac80211/scan.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 86562ce..e7eb2cf 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -199,7 +199,8 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	if (scan_chan)
+	if ((local->scanning & SCAN_SW_SCANNING) ||
+	    (local->scanning & SCAN_HW_SCANNING))
 		power = chan->max_power;
 	else
 		power = local->power_constr_level ?
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1f277c9..ab8d2c6 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -307,11 +307,15 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
 	mutex_lock(&local->mtx);
 	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 
+	WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));
+
 	if (was_hw_scan || !on_oper_chan) {
 		if (WARN_ON(local->scan_channel))
 			local->scan_channel = NULL;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	}
+	} else
+		/* Set power back to normal operating levels. */
+		ieee80211_hw_config(local, 0);
 
 	if (!was_hw_scan) {
 		bool on_oper_chan2;
@@ -434,6 +438,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	ieee80211_configure_filter(local);
 
+	/* We need to set power level at maximum rate for scanning. */
+	ieee80211_hw_config(local, 0);
+
 	ieee80211_queue_delayed_work(&local->hw,
 				     &local->scan_work,
 				     IEEE80211_CHANNEL_TIME);
-- 
1.7.2.3

