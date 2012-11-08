Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42318 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab2KHNrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 08:47:47 -0500
Date: Thu, 8 Nov 2012 19:10:44 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Send BASTREAM firmware commands per vif
Message-ID: <20121108134040.GA10800@markyou.marvell.com> (sfid-20121108_144804_970201_B23BD652)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware supports 8 macid's corresponding to 8 BSS that can be
created in an MBSS environment. Currently, BASTREAM commands were always
sent with macid 0. This macid is used to configure the hardware ampdu
registers with appropriate BSS address in an MBSS environment.
This mac address is used by the hardware for various ampdu related requirements
e.g. source address in BAR generation, BA interpretation e.t.c.
Using invalid macid results in this mac address not getting appropriately
configured in the hardware which results in issues during ampdu traffic.

Fix this by sending the BASTREAM commands with appropriate macid.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3db4950..0cdae66 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3686,7 +3686,8 @@ struct mwl8k_cmd_bastream {
 } __packed;
 
 static int
-mwl8k_check_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
+mwl8k_check_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream,
+	       struct ieee80211_vif *vif)
 {
 	struct mwl8k_cmd_bastream *cmd;
 	int rc;
@@ -3709,7 +3710,7 @@ mwl8k_check_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
 		cpu_to_le32(BASTREAM_FLAG_IMMEDIATE_TYPE) |
 		cpu_to_le32(BASTREAM_FLAG_DIRECTION_UPSTREAM);
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 
 	kfree(cmd);
 
@@ -3718,7 +3719,7 @@ mwl8k_check_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
 
 static int
 mwl8k_create_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream,
-		u8 buf_size)
+		u8 buf_size, struct ieee80211_vif *vif)
 {
 	struct mwl8k_cmd_bastream *cmd;
 	int rc;
@@ -3752,7 +3753,7 @@ mwl8k_create_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream,
 		cpu_to_le32(BASTREAM_FLAG_IMMEDIATE_TYPE |
 					BASTREAM_FLAG_DIRECTION_UPSTREAM);
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
+	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 
 	wiphy_debug(hw->wiphy, "Created a BA stream for %pM : tid %d\n",
 		stream->sta->addr, stream->tid);
@@ -5144,7 +5145,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				return -EBUSY;
 			}
 
-			rc = mwl8k_check_ba(hw, stream);
+			rc = mwl8k_check_ba(hw, stream, vif);
 
 			/* If HW restart is in progress mwl8k_post_cmd will
 			 * return -EBUSY. Avoid retrying mwl8k_check_ba in
@@ -5184,7 +5185,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		BUG_ON(stream == NULL);
 		BUG_ON(stream->state != AMPDU_STREAM_IN_PROGRESS);
 		spin_unlock(&priv->stream_lock);
-		rc = mwl8k_create_ba(hw, stream, buf_size);
+		rc = mwl8k_create_ba(hw, stream, buf_size, vif);
 		spin_lock(&priv->stream_lock);
 		if (!rc)
 			stream->state = AMPDU_STREAM_ACTIVE;
-- 
1.7.9.2

