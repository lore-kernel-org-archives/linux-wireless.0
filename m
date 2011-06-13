Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:33332 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1FMLYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 07:24:04 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Tell firmware to generate CCMP header
Date: Mon, 13 Jun 2011 16:26:15 +0530
Message-Id: <1307962575-16100-1-git-send-email-nishants@marvell.com> (sfid-20110613_132409_482317_6228141C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Post commit e4eefec73ea0a740bfe8736e3ac30dfe92fe392b, the stack is
not generating the CCMP header for us anymore. This broke the CCMP
functionality since firmware was not doing this either. Set a flag
to tell the firmware to generate the CCMP header

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 25981f7..06ec7a7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2474,6 +2474,7 @@ struct mwl8k_cmd_set_hw_spec {
  * faster client.
  */
 #define MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY	0x00000400
+#define MWL8K_SET_HW_SPEC_FLAG_GENERATE_CCMP_HDR	0x00000200
 #define MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT		0x00000080
 #define MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP	0x00000020
 #define MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON		0x00000010
@@ -2510,7 +2511,8 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT |
 				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP |
 				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON |
-				 MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY);
+				 MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY |
+				 MWL8K_SET_HW_SPEC_FLAG_GENERATE_CCMP_HDR);
 	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
 	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
 
-- 
1.6.0.3

