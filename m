Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49173 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbZJVShL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:11 -0400
Date: Thu, 22 Oct 2009 20:19:23 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 01/28] mwl8k: fix GET_STAT firmware command packet layout
Message-ID: <20091022181923.GC1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GET_STAT command doesn't have an 'action' field like other
commands do, so remove it.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 746532e..3249998 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1590,7 +1590,6 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
  */
 struct mwl8k_cmd_802_11_get_stat {
 	struct mwl8k_cmd_pkt header;
-	__le16 action;
 	__le32 stats[64];
 } __attribute__((packed));
 
@@ -1611,7 +1610,6 @@ static int mwl8k_cmd_802_11_get_stat(struct ieee80211_hw *hw,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_GET_STAT);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le16(MWL8K_CMD_GET);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	if (!rc) {
-- 
1.5.6.4
