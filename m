Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:52597 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1DULbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:31:24 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, pnemavat@marvell.com,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH V3 4/4] mwl8k: Enable life time expiry for tx packets in the hardware
Date: Thu, 21 Apr 2011 16:34:59 +0530
Message-Id: <1303383899-3262-4-git-send-email-nishants@marvell.com>
In-Reply-To: <1303383899-3262-1-git-send-email-nishants@marvell.com>
References: <1303383899-3262-1-git-send-email-nishants@marvell.com>
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
index ed5413d..20c06be 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2504,7 +2504,8 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 
 	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT |
 				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP |
-				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON);
+				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON |
+				 MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY);
 	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
 	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
 
-- 
1.6.0.3

