Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:53795 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0ADU4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:56:48 -0500
Date: Mon, 4 Jan 2010 21:56:46 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 11/14] mwl8k: allow setting HT channels
Message-ID: <20100104205646.GK1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5f4f26e..cea131d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2030,8 +2030,9 @@ struct mwl8k_cmd_set_rf_channel {
 } __attribute__((packed));
 
 static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
-				    struct ieee80211_channel *channel)
+				    struct ieee80211_conf *conf)
 {
+	struct ieee80211_channel *channel = conf->channel;
 	struct mwl8k_cmd_set_rf_channel *cmd;
 	int rc;
 
@@ -2043,10 +2044,17 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
 	cmd->current_channel = channel->hw_value;
+
 	if (channel->band == IEEE80211_BAND_2GHZ)
-		cmd->channel_flags = cpu_to_le32(0x00000081);
-	else
-		cmd->channel_flags = cpu_to_le32(0x00000000);
+		cmd->channel_flags |= cpu_to_le32(0x00000001);
+
+	if (conf->channel_type == NL80211_CHAN_NO_HT ||
+	    conf->channel_type == NL80211_CHAN_HT20)
+		cmd->channel_flags |= cpu_to_le32(0x00000080);
+	else if (conf->channel_type == NL80211_CHAN_HT40MINUS)
+		cmd->channel_flags |= cpu_to_le32(0x000001900);
+	else if (conf->channel_type == NL80211_CHAN_HT40PLUS)
+		cmd->channel_flags |= cpu_to_le32(0x000000900);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2926,7 +2934,7 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	if (rc)
 		goto out;
 
-	rc = mwl8k_cmd_set_rf_channel(hw, conf->channel);
+	rc = mwl8k_cmd_set_rf_channel(hw, conf);
 	if (rc)
 		goto out;
 
-- 
1.5.6.4
