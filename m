Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57153 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZK3RMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:12:43 -0500
Date: Mon, 30 Nov 2009 18:12:49 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 06/12] mwl8k: allow more time for firmware commands to complete
Message-ID: <20091130171249.GI20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware commands can under some circumstances take more than 2
seconds to complete.  This patch bumps the timeout up to 10 seconds,
and prints a message whenever a command takes more than 2 seconds.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b87908b..2d4724b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1579,8 +1579,8 @@ static void mwl8k_fw_unlock(struct ieee80211_hw *hw)
  * Command processing.
  */
 
-/* Timeout firmware commands after 2000ms */
-#define MWL8K_CMD_TIMEOUT_MS	2000
+/* Timeout firmware commands after 10s */
+#define MWL8K_CMD_TIMEOUT_MS	10000
 
 static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 {
@@ -1631,12 +1631,21 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 		       MWL8K_CMD_TIMEOUT_MS);
 		rc = -ETIMEDOUT;
 	} else {
+		int ms;
+
+		ms = MWL8K_CMD_TIMEOUT_MS - jiffies_to_msecs(timeout);
+
 		rc = cmd->result ? -EINVAL : 0;
 		if (rc)
 			printk(KERN_ERR "%s: Command %s error 0x%x\n",
 			       wiphy_name(hw->wiphy),
 			       mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
 			       le16_to_cpu(cmd->result));
+		else if (ms > 2000)
+			printk(KERN_NOTICE "%s: Command %s took %d ms\n",
+			       wiphy_name(hw->wiphy),
+			       mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
+			       ms);
 	}
 
 	return rc;
-- 
1.5.6.4
