Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61604 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaIHQ4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:36 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/12] iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
Date: Mon,  8 Sep 2014 19:56:12 +0300
Message-Id: <1410195377-10075-7-git-send-email-egrumbach@gmail.com> (sfid-20140908_185642_729677_3DFEECD3)
In-Reply-To: <540DDF37.5030801@gmail.com>
References: <540DDF37.5030801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Using the LQ table which is initially set according to
the rssi could lead to EAPOLs being sent in high legacy
rates like 54mbps.
It's better to avoid sending EAPOLs in high rates as it reduces
the chances of a successful 4-Way handshake.
Avoid this and treat them like other mgmt frames which would
initially get sent at the basic rate.

Cc: <stable@vger.kernel.org> [3.13+]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index dbc8707..9ee410b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -168,10 +168,14 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 
 	/*
 	 * for data packets, rate info comes from the table inside the fw. This
-	 * table is controlled by LINK_QUALITY commands
+	 * table is controlled by LINK_QUALITY commands. Exclude ctrl port
+	 * frames like EAPOLs which should be treated as mgmt frames. This
+	 * avoids them being sent initially in high rates which increases the
+	 * chances for completion of the 4-Way handshake.
 	 */
 
-	if (ieee80211_is_data(fc) && sta) {
+	if (ieee80211_is_data(fc) && sta &&
+	    !(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_STA_RATE);
 		return;
-- 
1.9.1

