Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57166 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZK3ROR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:14:17 -0500
Date: Mon, 30 Nov 2009 18:14:23 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 12/12] mwl8k: don't complain about oversized beacons in FINALIZE_JOIN
Message-ID: <20091130171423.GO20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FINALIZE_JOIN firmware command only looks at the first couple of
fields in the beacon, and therefore it's not necessary to complain if
the beacon is longer than 128 bytes.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   29 ++++++++---------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f80cef9..bd56412 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2469,8 +2469,6 @@ mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 /*
  * CMD_FINALIZE_JOIN.
  */
-
-/* FJ beacon buffer size is compiled into the firmware.  */
 #define MWL8K_FJ_BEACON_MAXLEN	128
 
 struct mwl8k_cmd_finalize_join {
@@ -2480,17 +2478,13 @@ struct mwl8k_cmd_finalize_join {
 } __attribute__((packed));
 
 static int mwl8k_finalize_join(struct ieee80211_hw *hw, void *frame,
-				__u16 framelen, __u16 dtim)
+			       int framelen, int dtim)
 {
 	struct mwl8k_cmd_finalize_join *cmd;
 	struct ieee80211_mgmt *payload = frame;
-	u16 hdrlen;
-	u32 payload_len;
+	int payload_len;
 	int rc;
 
-	if (frame == NULL)
-		return -EINVAL;
-
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -2499,24 +2493,17 @@ static int mwl8k_finalize_join(struct ieee80211_hw *hw, void *frame,
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->sleep_interval = cpu_to_le32(dtim ? dtim : 1);
 
-	hdrlen = ieee80211_hdrlen(payload->frame_control);
-
-	payload_len = framelen > hdrlen ? framelen - hdrlen : 0;
-
-	/* XXX TBD Might just have to abort and return an error */
-	if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
-		printk(KERN_ERR "%s(): WARNING: Incomplete beacon "
-		       "sent to firmware. Sz=%u MAX=%u\n", __func__,
-		       payload_len, MWL8K_FJ_BEACON_MAXLEN);
-
-	if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
+	payload_len = framelen - ieee80211_hdrlen(payload->frame_control);
+	if (payload_len < 0)
+		payload_len = 0;
+	else if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
 		payload_len = MWL8K_FJ_BEACON_MAXLEN;
 
-	if (payload && payload_len)
-		memcpy(cmd->beacon_data, &payload->u.beacon, payload_len);
+	memcpy(cmd->beacon_data, &payload->u.beacon, payload_len);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
+
 	return rc;
 }
 
-- 
1.5.6.4
