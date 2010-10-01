Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab0JAMEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:04:42 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/6] Revert "iwlwifi: do not perferm force reset while doing scan"
Date: Fri,  1 Oct 2010 14:05:32 +0200
Message-Id: <1285934732-16087-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 7acc7c683a747689aaaaad4fce1683fc3f85e552. It was
applied to avoid possible warning in ieee80211_restart_hw, however
reason of the warning were races in mac80211, currently hopefully fixed.

Not reseting device when performing scan is bad for two reasons.

When forcing reset from iwl_check_stuck_queue(), in case of fail,
reset will be repeated until scan finish. But since firmware is in bad
shape, scan only finish after scan_check work (about 7s). So we will
delay the reset, what is not good behaviour.

When forcing reset from iwl_recover_from_statistics(), we will not
repeat the reset, so we will not perform reset at all when needed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5c56893..393f02d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2736,11 +2736,6 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EINVAL;
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "scan in progress.\n");
-		return -EINVAL;
-	}
-
 	if (mode >= IWL_MAX_FORCE_RESET) {
 		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
 		return -EINVAL;
-- 
1.7.1

