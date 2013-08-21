Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3HUGEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 2/8] iwlwifi: mvm: fix MCAST in AP mode
Date: Wed, 21 Aug 2013 09:04:20 +0300
Message-Id: <1377065066-13030-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080437_072014_07E90DA2)
In-Reply-To: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 9116a3683902583a302ac5dcb283416d504d9bb4 upstream.

In multicast, there is no retries nor RTS since there is no
specific recipient that can ACK or send CTS. This means
that we must not use the rate scale table for multicast
frames.
This true for any frame that doesn't have a valid
ieee80211_sta pointer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 48c1891..b9ba4e7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -175,7 +175,7 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 	 * table is controlled by LINK_QUALITY commands
 	 */
 
-	if (ieee80211_is_data(fc)) {
+	if (ieee80211_is_data(fc) && sta) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_STA_RATE);
 		return;
-- 
1.7.10.4

