Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59951 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaKXOfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:33 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so6017263wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/75] iwlwifi: mvm: Fix the keep_alive calculation
Date: Mon, 24 Nov 2014 16:33:58 +0200
Message-Id: <1416839691-28533-22-git-send-email-egrumbach@gmail.com> (sfid-20141124_154428_030603_1C0A9F1E)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

The driver must set the keep alive period regardless of power
management state. The keep alive period must be greater or equal to
both the NIC's maximum sleep period, and the listen interval.
However, we were confusing time units (TU) and msec, so fix that.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index cb653ac..2620dd0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -329,7 +329,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct iwl_mac_power_cmd *cmd)
 {
-	int dtimper, dtimper_msec, bi;
+	int dtimper, bi;
 	int keep_alive;
 	bool radar_detect = false;
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
@@ -346,10 +346,9 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	 * immediately after association. Check that keep alive period
 	 * is at least 3 * DTIM
 	 */
-	dtimper_msec = dtimper * bi;
-	keep_alive = max_t(int, 3 * dtimper_msec,
-			   MSEC_PER_SEC * POWER_KEEP_ALIVE_PERIOD_SEC);
-	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
+	keep_alive = DIV_ROUND_UP(ieee80211_tu_to_usec(3 * dtimper * bi),
+				  USEC_PER_SEC);
+	keep_alive = max(keep_alive, POWER_KEEP_ALIVE_PERIOD_SEC);
 	cmd->keep_alive_seconds = cpu_to_le16(keep_alive);
 
 	if (mvm->ps_disabled)
-- 
1.9.1

