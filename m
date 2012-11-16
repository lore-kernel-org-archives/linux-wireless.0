Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:57552 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2KPIga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 03:36:30 -0500
Subject: [PATCH] ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Fri, 16 Nov 2012 10:28:04 +0200
Message-ID: <20121116082804.10073.67557.stgit@localhost6.localdomain6> (sfid-20121116_093641_729910_9B7E95C0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As ath6kl firmware can't do intersections the driver should only listen
to regdom changes from cellular base stations, all other requests need to
be refused.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index bf5e7d5..41dea0d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3500,11 +3500,18 @@ static int ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
 	int ret, i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
-		   "cfg reg_notify %c%c%s%s initiator %d\n",
+		   "cfg reg_notify %c%c%s%s initiator %d hint_type %d\n",
 		   request->alpha2[0], request->alpha2[1],
 		   request->intersect ? " intersect" : "",
 		   request->processed ? " processed" : "",
-		   request->initiator);
+		   request->initiator, request->user_reg_hint_type);
+
+	/*
+	 * As firmware is not able intersect regdoms, we can only listen to
+	 * cellular hints.
+	 */
+	if (request->user_reg_hint_type != NL80211_USER_REG_HINT_CELL_BASE)
+		return -EOPNOTSUPP;
 
 	ret = ath6kl_wmi_set_regdomain_cmd(ar->wmi, request->alpha2);
 	if (ret) {
@@ -3668,8 +3675,10 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	}
 
 	if (config_enabled(CONFIG_ATH6KL_REGDOMAIN) &&
-	    test_bit(ATH6KL_FW_CAPABILITY_REGDOMAIN, ar->fw_capabilities))
+	    test_bit(ATH6KL_FW_CAPABILITY_REGDOMAIN, ar->fw_capabilities)) {
 		wiphy->reg_notifier = ath6kl_cfg80211_reg_notify;
+		ar->wiphy->features |= NL80211_FEATURE_CELL_BASE_REG_HINTS;
+	}
 
 	/* max num of ssids that can be probed during scanning */
 	wiphy->max_scan_ssids = MAX_PROBED_SSIDS;

