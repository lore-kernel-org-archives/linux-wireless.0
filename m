Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4935 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab0JNSEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 8/9] iwlagn: check beacon frame size
Date: Thu, 14 Oct 2010 11:02:49 -0700
Message-Id: <1287079370-20587-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the beacon_skb is NULL, we might still
attempt to use it in this code path (if we
ever get here) -- make the code a bit more
defensive and check the return value of
iwl_fill_beacon_frame() against zero.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7079efb..c2636a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -385,6 +385,8 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
 	if (WARN_ON_ONCE(frame_size > MAX_MPDU_SIZE))
 		return 0;
+	if (!frame_size)
+		return 0;
 
 	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
-- 
1.7.0.4

