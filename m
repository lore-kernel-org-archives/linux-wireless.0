Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40656 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1DSRMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 13:12:44 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: [PATCH V2 4/4] mwl8k: Enable life time expiry for tx packets in the hardware
Date: Tue, 19 Apr 2011 22:16:22 +0530
Message-Id: <1303231582-17333-4-git-send-email-nishants@marvell.com>
In-Reply-To: <1303231582-17333-1-git-send-email-nishants@marvell.com>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tell the firmware to enable the life time expiry of tx packets
in the hardware. The hardware will now refer to the timestamp
in every tx packet and decide whether the packet needs to be
dropped or transmitted.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 82cd725..7db4bb9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2502,7 +2502,8 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 
 	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT |
 				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP |
-				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON);
+				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON |
+				 MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY);
 	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
 	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
 
-- 
1.6.0.3

