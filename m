Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3ACOpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/12] iwlwifi: don't treat a bool as an error code
Date: Thu,  3 Jan 2013 15:46:12 +0100
Message-Id: <1357224376-27803-8-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154938_883500_CE2CF657)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_trans_grab_nic_access returns a boolean. So ret should
explicitely set to an error code and not rely on the value
returned by iwl_trans_grab_nic_access.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 9c1f055..1ed4bc6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -459,11 +459,11 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		spin_lock_irqsave(&priv->trans->reg_lock, flags);
-		ret = iwl_trans_grab_nic_access(priv->trans, true);
-		if (likely(ret == 0)) {
+		if (iwl_trans_grab_nic_access(priv->trans, true)) {
 			iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, base);
 			status = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 			iwl_trans_release_nic_access(priv->trans);
+			ret = 0;
 		}
 		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
-- 
1.8.0

