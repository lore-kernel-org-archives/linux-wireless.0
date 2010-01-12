Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58851 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0ALMuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:50:15 -0500
Date: Tue, 12 Jan 2010 13:50:14 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 14/17] mwl8k: prepare for posting per-vif firmware commands
Message-ID: <20100112125014.GD1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the bytes in the mwl8k firmware command header is the 'macid'
byte, which for per-vif commands indicates which of the BSSes this
command is intended for.  (For commands that are not per-vif commands,
this byte can just be 0.)

This patch adds mwl8k_post_pervif_cmd(), which will take the macid
assigned to this interface (to be done in ->add_interface()), copy it
into the command packet macid field, and post the command as usual.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ee7d8a6..ea39ef6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -214,6 +214,9 @@ struct mwl8k_vif {
 	struct list_head list;
 	struct ieee80211_vif *vif;
 
+	/* Firmware macid for this vif.  */
+	int macid;
+
 	/* Non AMPDU sequence number assigned by driver.  */
 	u16 seqno;
 };
@@ -419,7 +422,8 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 struct mwl8k_cmd_pkt {
 	__le16	code;
 	__le16	length;
-	__le16	seq_num;
+	__u8	seq_num;
+	__u8	macid;
 	__le16	result;
 	char	payload[0];
 } __attribute__((packed));
@@ -477,6 +481,7 @@ static int mwl8k_load_fw_image(struct mwl8k_priv *priv,
 
 	cmd->code = cpu_to_le16(MWL8K_CMD_CODE_DNLD);
 	cmd->seq_num = 0;
+	cmd->macid = 0;
 	cmd->result = 0;
 
 	done = 0;
@@ -1595,6 +1600,15 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	return rc;
 }
 
+static int mwl8k_post_pervif_cmd(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct mwl8k_cmd_pkt *cmd)
+{
+	if (vif != NULL)
+		cmd->macid = MWL8K_VIF(vif)->macid;
+	return mwl8k_post_cmd(hw, cmd);
+}
+
 /*
  * Setup code shared between STA and AP firmware images.
  */
@@ -3283,6 +3297,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 	mwl8k_vif->vif = vif;
+	mwl8k_vif->macid = 0;
 	mwl8k_vif->seqno = 0;
 
 	list_add_tail(&mwl8k_vif->list, &priv->vif_list);
-- 
1.5.6.4
