Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58360 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0AHRaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:30:18 -0500
Date: Fri, 8 Jan 2010 18:30:16 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mwl8k: simplify mwl8k_cmd_use_fixed_rate()
Message-ID: <20100108173016.GX1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we always use the auto rate adaptation feature and never pass in
a rate table, USE_FIXED_RATE can be simplified somewhat.  While we're
at it, rename it to *_sta, as this is the STA version of the command.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   88 ++++++++++-------------------------------
 1 files changed, 22 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8f5f7c9..20e7cf2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2482,49 +2482,30 @@ static int mwl8k_cmd_mimo_config(struct ieee80211_hw *hw, __u8 rx, __u8 tx)
 }
 
 /*
- * CMD_USE_FIXED_RATE.
+ * CMD_USE_FIXED_RATE (STA version).
  */
-#define MWL8K_RATE_TABLE_SIZE	8
-#define MWL8K_UCAST_RATE	0
-#define MWL8K_USE_AUTO_RATE	0x0002
-
-struct mwl8k_rate_entry {
-	/* Set to 1 if HT rate, 0 if legacy.  */
-	__le32	is_ht_rate;
-
-	/* Set to 1 to use retry_count field.  */
-	__le32	enable_retry;
-
-	/* Specified legacy rate or MCS.  */
-	__le32	rate;
-
-	/* Number of allowed retries.  */
-	__le32	retry_count;
-} __attribute__((packed));
-
-struct mwl8k_rate_table {
-	/* 1 to allow specified rate and below */
-	__le32	allow_rate_drop;
-	__le32	num_rates;
-	struct mwl8k_rate_entry rate_entry[MWL8K_RATE_TABLE_SIZE];
+struct mwl8k_cmd_use_fixed_rate_sta {
+	struct mwl8k_cmd_pkt header;
+	__le32 action;
+	__le32 allow_rate_drop;
+	__le32 num_rates;
+	struct {
+		__le32 is_ht_rate;
+		__le32 enable_retry;
+		__le32 rate;
+		__le32 retry_count;
+	} rate_entry[8];
+	__le32 rate_type;
+	__le32 reserved1;
+	__le32 reserved2;
 } __attribute__((packed));
 
-struct mwl8k_cmd_use_fixed_rate {
-	struct	mwl8k_cmd_pkt header;
-	__le32	action;
-	struct mwl8k_rate_table rate_table;
-
-	/* Unicast, Broadcast or Multicast */
-	__le32	rate_type;
-	__le32	reserved1;
-	__le32	reserved2;
-} __attribute__((packed));
+#define MWL8K_USE_AUTO_RATE	0x0002
+#define MWL8K_UCAST_RATE	0
 
-static int mwl8k_cmd_use_fixed_rate(struct ieee80211_hw *hw,
-	u32 action, u32 rate_type, struct mwl8k_rate_table *rate_table)
+static int mwl8k_cmd_use_fixed_rate_sta(struct ieee80211_hw *hw)
 {
-	struct mwl8k_cmd_use_fixed_rate *cmd;
-	int count;
+	struct mwl8k_cmd_use_fixed_rate_sta *cmd;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2533,32 +2514,8 @@ static int mwl8k_cmd_use_fixed_rate(struct ieee80211_hw *hw,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_USE_FIXED_RATE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-
-	cmd->action = cpu_to_le32(action);
-	cmd->rate_type = cpu_to_le32(rate_type);
-
-	if (rate_table != NULL) {
-		/*
-		 * Copy over each field manually so that endian
-		 * conversion can be done.
-		 */
-		cmd->rate_table.allow_rate_drop =
-				cpu_to_le32(rate_table->allow_rate_drop);
-		cmd->rate_table.num_rates =
-				cpu_to_le32(rate_table->num_rates);
-
-		for (count = 0; count < rate_table->num_rates; count++) {
-			struct mwl8k_rate_entry *dst =
-				&cmd->rate_table.rate_entry[count];
-			struct mwl8k_rate_entry *src =
-				&rate_table->rate_entry[count];
-
-			dst->is_ht_rate = cpu_to_le32(src->is_ht_rate);
-			dst->enable_retry = cpu_to_le32(src->enable_retry);
-			dst->rate = cpu_to_le32(src->rate);
-			dst->retry_count = cpu_to_le32(src->retry_count);
-		}
-	}
+	cmd->action = cpu_to_le32(MWL8K_USE_AUTO_RATE);
+	cmd->rate_type = cpu_to_le32(MWL8K_UCAST_RATE);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -3062,8 +3019,7 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		if (rc)
 			goto out;
 
-		rc = mwl8k_cmd_use_fixed_rate(hw, MWL8K_USE_AUTO_RATE,
-			MWL8K_UCAST_RATE, NULL);
+		rc = mwl8k_cmd_use_fixed_rate_sta(hw);
 		if (rc)
 			goto out;
 	}
-- 
1.5.6.4
