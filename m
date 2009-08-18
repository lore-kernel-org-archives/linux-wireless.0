Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40177 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbZHRDwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:52:06 -0400
Date: Tue, 18 Aug 2009 05:52:08 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/29] mwl8k: remove MWL8K_*_SLOTTIME defines
Message-ID: <20090818035208.GM18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c9bb9b1..9f54204 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -274,14 +274,6 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 	{ .bitrate = 540, .hw_value = 108, },
 };
 
-/* Slot time */
-
-/* Short Slot: 9us slot time */
-#define MWL8K_SHORT_SLOTTIME		1
-
-/* Long slot: 20us slot time */
-#define MWL8K_LONG_SLOTTIME		0
-
 /* Set or get info from Firmware */
 #define MWL8K_CMD_SET			0x0001
 #define MWL8K_CMD_GET			0x0000
@@ -1895,7 +1887,7 @@ struct mwl8k_cmd_set_slot {
 	__u8 short_slot;
 } __attribute__((packed));
 
-static int mwl8k_cmd_set_slot(struct ieee80211_hw *hw, int slot_time)
+static int mwl8k_cmd_set_slot(struct ieee80211_hw *hw, bool short_slot_time)
 {
 	struct mwl8k_cmd_set_slot *cmd;
 	int rc;
@@ -1907,7 +1899,7 @@ static int mwl8k_cmd_set_slot(struct ieee80211_hw *hw, int slot_time)
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_SLOT);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
-	cmd->short_slot = slot_time == MWL8K_SHORT_SLOTTIME ? 1 : 0;
+	cmd->short_slot = short_slot_time;
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -3045,8 +3037,7 @@ static int mwl8k_bss_info_changed_wt(struct work_struct *wt)
 			goto mwl8k_bss_info_changed_exit;
 
 		/* Set slot time */
-		if (mwl8k_cmd_set_slot(hw, info->use_short_slot ?
-				MWL8K_SHORT_SLOTTIME : MWL8K_LONG_SLOTTIME))
+		if (mwl8k_cmd_set_slot(hw, info->use_short_slot))
 			goto mwl8k_bss_info_changed_exit;
 
 		/* Update peer rate info */
-- 
1.5.6.4
