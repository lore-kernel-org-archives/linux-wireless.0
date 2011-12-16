Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142Ab1LPQh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/24] iwlagn: remove iwlagn_build_addsta_hcmd
Date: Fri, 16 Dec 2011 07:37:29 -0800
Message-Id: <1324049849-831-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173852_260156_5B6DC883)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is not needed:
 * we already have the "cmd" input to it in the
   same type (and on the stack elsewhere)
 * the "legacy_reserved" parameter is never set,
   so will always be zero

Remove the function and the stack copy of the
input command.

This is still left from when iwlegacy was part
of the driver -- then we needed a translation
for the command for 3945.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 6bf3311..7353826 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -130,25 +130,15 @@ int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	return iwl_process_add_sta_resp(priv, addsta, pkt);
 }
 
-static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
-{
-	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
-	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
-	memcpy(addsta, cmd, size);
-	/* resrved in agn */
-	addsta->legacy_reserved = cpu_to_le16(0);
-	return size;
-}
-
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
 	int ret = 0;
-	u8 data[sizeof(*sta)];
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
 		.flags = flags,
-		.data = { data, },
+		.data = { sta, },
+		.len = { sizeof(*sta), },
 	};
 	u8 sta_id __maybe_unused = sta->sta.sta_id;
 
@@ -160,7 +150,6 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		might_sleep();
 	}
 
-	cmd.len[0] = iwlagn_build_addsta_hcmd(sta, data);
 	ret = iwl_trans_send_cmd(trans(priv), &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
-- 
1.7.0.4

