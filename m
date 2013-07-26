Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3GZITe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 3/7] iwlwifi: mvm: set SSID bits for passive channels
Date: Fri, 26 Jul 2013 10:19:24 +0200
Message-Id: <1374826768-2440-3-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101946_345590_B10FCA2B)
In-Reply-To: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
 <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Set SSID bitmap for direct scan even on passive channels,
for the passive-to-active feature. Without this patch only
the SSID from probe request template is sent on passive
channels, after passive-to-active switching, causing us to
not find all desired networks.

Remove the unused passive scan mask constant.

Cc: stable@vger.kernel.org
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  1 -
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index b60d141..365095a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -69,7 +69,6 @@
 /* Scan Commands, Responses, Notifications */
 
 /* Masks for iwl_scan_channel.type flags */
-#define SCAN_CHANNEL_TYPE_PASSIVE	0
 #define SCAN_CHANNEL_TYPE_ACTIVE	BIT(0)
 #define SCAN_CHANNEL_NARROW_BAND	BIT(22)
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 268f027..acdff6b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -178,19 +178,12 @@ static void iwl_mvm_scan_fill_channels(struct iwl_scan_cmd *cmd,
 	struct iwl_scan_channel *chan = (struct iwl_scan_channel *)
 		(cmd->data + le16_to_cpu(cmd->tx_cmd.len));
 	int i;
-	__le32 chan_type_value;
-
-	if (req->n_ssids > 0)
-		chan_type_value = cpu_to_le32(BIT(req->n_ssids) - 1);
-	else
-		chan_type_value = SCAN_CHANNEL_TYPE_PASSIVE;
 
 	for (i = 0; i < cmd->channel_count; i++) {
 		chan->channel = cpu_to_le16(req->channels[i]->hw_value);
+		chan->type = cpu_to_le32(BIT(req->n_ssids) - 1);
 		if (req->channels[i]->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			chan->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		else
-			chan->type = chan_type_value;
+			chan->type &= cpu_to_le32(~SCAN_CHANNEL_TYPE_ACTIVE);
 		chan->active_dwell = cpu_to_le16(active_dwell);
 		chan->passive_dwell = cpu_to_le16(passive_dwell);
 		chan->iteration_count = cpu_to_le16(1);
-- 
1.8.0

