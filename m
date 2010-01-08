Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58363 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0AHRai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:30:38 -0500
Date: Fri, 8 Jan 2010 18:30:36 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] mwl8k: add the AP version of USE_FIXED_RATE
Message-ID: <20100108173034.GY1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As with the STA version, unicast will use auto rate adaptation, but
the AP version allows setting the rates to be used for management and
multicast transmissions, which can be set based on the BSS basic rate
set.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 20e7cf2..ec79033 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2524,6 +2524,47 @@ static int mwl8k_cmd_use_fixed_rate_sta(struct ieee80211_hw *hw)
 }
 
 /*
+ * CMD_USE_FIXED_RATE (AP version).
+ */
+struct mwl8k_cmd_use_fixed_rate_ap {
+	struct mwl8k_cmd_pkt header;
+	__le32 action;
+	__le32 allow_rate_drop;
+	__le32 num_rates;
+	struct mwl8k_rate_entry_ap {
+		__le32 is_ht_rate;
+		__le32 enable_retry;
+		__le32 rate;
+		__le32 retry_count;
+	} rate_entry[4];
+	u8 multicast_rate;
+	u8 multicast_rate_type;
+	u8 management_rate;
+} __attribute__((packed));
+
+static int
+mwl8k_cmd_use_fixed_rate_ap(struct ieee80211_hw *hw, int mcast, int mgmt)
+{
+	struct mwl8k_cmd_use_fixed_rate_ap *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_USE_FIXED_RATE);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le32(MWL8K_USE_AUTO_RATE);
+	cmd->multicast_rate = mcast;
+	cmd->management_rate = mgmt;
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_ENABLE_SNIFFER.
  */
 struct mwl8k_cmd_enable_sniffer {
-- 
1.5.6.4
