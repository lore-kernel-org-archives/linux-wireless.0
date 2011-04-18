Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1DRRFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlagn: use huge command for beacon
Date: Mon, 18 Apr 2011 09:44:11 -0700
Message-Id: <1303145057-6545-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When testing some new P2P code, Angie found that the
driver might crash because the beacon command ended
up being bigger than a regular command. This is quite
obvious -- a normal command is limited to roughly 360
bytes but a beacon may be much larger of course.

To fix this, use the huge command buffer.

Reported-by: Angie Chinchilla <angie.v.chinchilla@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0daeded..3cfd7eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -253,6 +253,10 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	struct iwl_frame *frame;
 	unsigned int frame_size;
 	int rc;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_TX_BEACON,
+		.flags = CMD_SIZE_HUGE,
+	};
 
 	frame = iwl_get_free_frame(priv);
 	if (!frame) {
@@ -268,8 +272,10 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 		return -EINVAL;
 	}
 
-	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
-			      &frame->u.cmd[0]);
+	cmd.len = frame_size;
+	cmd.data = &frame->u.cmd[0];
+
+	rc = iwl_send_cmd_sync(priv, &cmd);
 
 	iwl_free_frame(priv, frame);
 
-- 
1.7.0.4

