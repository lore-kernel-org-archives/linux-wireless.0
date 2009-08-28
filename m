Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZH1Qou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: use sleep interval succession
Date: Fri, 28 Aug 2009 09:44:48 -0700
Message-Id: <1251477889-13732-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
References: <1251477889-13732-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Some concerns were raised about the automatic adjustment
of sleep intervals to all the same, potentially high,
value, and I can imagine the hardware behaving better
when we don't ask too much of it.

So let's convert to use a succession of sleep levels
when requesting to go to deeper sleeps (which can only
happen with large DTIM intervals), using the succession
values from power level three, which have the benefit of
also having been tested extensively already.

As a result, the automatic sleep level adjustment will
now be mostly equivalent to power level three, except
for the RX/TX timeouts and possibly using smaller sleep
vectors to account for networking latency.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 0b16841..081a7ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -216,8 +216,27 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 				     struct iwl_powertable_cmd *cmd,
 				     int dynps_ms, int wakeup_period)
 {
+	/*
+	 * These are the original power level 3 sleep successions. The
+	 * device may behave better with such succession and was also
+	 * only tested with that. Just like the original sleep commands,
+	 * also adjust the succession here to the wakeup_period below.
+	 * The ranges are the same as for the sleep commands, 0-2, 3-9
+	 * and >10, which is selected based on the DTIM interval for
+	 * the sleep index but here we use the wakeup period since that
+	 * is what we need to do for the latency requirements.
+	 */
+	static const u8 slp_succ_r0[IWL_POWER_VEC_SIZE] = { 2, 2, 2, 2, 2 };
+	static const u8 slp_succ_r1[IWL_POWER_VEC_SIZE] = { 2, 4, 6, 7, 9 };
+	static const u8 slp_succ_r2[IWL_POWER_VEC_SIZE] = { 2, 7, 9, 9, 0xFF };
+	const u8 *slp_succ = slp_succ_r0;
 	int i;
 
+	if (wakeup_period > IWL_DTIM_RANGE_0_MAX)
+		slp_succ = slp_succ_r1;
+	if (wakeup_period > IWL_DTIM_RANGE_1_MAX)
+		slp_succ = slp_succ_r2;
+
 	memset(cmd, 0, sizeof(*cmd));
 
 	cmd->flags = IWL_POWER_DRIVER_ALLOW_SLEEP_MSK |
@@ -230,7 +249,8 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 	cmd->tx_data_timeout = cpu_to_le32(1000 * dynps_ms);
 
 	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
-		cmd->sleep_interval[i] = cpu_to_le32(wakeup_period);
+		cmd->sleep_interval[i] =
+			cpu_to_le32(min_t(int, slp_succ[i], wakeup_period));
 
 	IWL_DEBUG_POWER(priv, "Automatic sleep command\n");
 }
-- 
1.5.6.3

