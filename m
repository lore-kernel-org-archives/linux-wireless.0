Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab1GILHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 07:07:45 -0400
Received: by wyg8 with SMTP id 8so1766096wyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jul 2011 04:07:44 -0700 (PDT)
From: Olivier Sobrie <olivier@sobrie.be>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org,
	Olivier Sobrie <olivier@sobrie.be>
Subject: [PATCH] libertas: fix errors in functions accessing module registers
Date: Sat,  9 Jul 2011 12:57:05 +0200
Message-Id: <1310209025-16516-1-git-send-email-olivier@sobrie.be> (sfid-20110709_131610_332293_7DB90164)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Problems located in the two functions lbs_set_reg() and lbs_get_reg():
- The offset field of struct cmd_ds_reg_access was not filled in
- The test on the return code of lbs_cmd_with_response() in function
  lbs_get_reg() was inverted

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
---
 drivers/net/wireless/libertas/cmd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 71c8f3f..3e8123c 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -873,6 +873,7 @@ int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_GET);
+	cmd.offset = cpu_to_le16(offset);
 
 	if (reg != CMD_MAC_REG_ACCESS &&
 	    reg != CMD_BBP_REG_ACCESS &&
@@ -882,7 +883,7 @@ int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value)
 	}
 
 	ret = lbs_cmd_with_response(priv, reg, &cmd);
-	if (ret) {
+	if (!ret) {
 		if (reg == CMD_BBP_REG_ACCESS || reg == CMD_RF_REG_ACCESS)
 			*value = cmd.value.bbp_rf;
 		else if (reg == CMD_MAC_REG_ACCESS)
@@ -915,6 +916,7 @@ int lbs_set_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 value)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.offset = cpu_to_le16(offset);
 
 	if (reg == CMD_BBP_REG_ACCESS || reg == CMD_RF_REG_ACCESS)
 		cmd.value.bbp_rf = (u8) (value & 0xFF);
-- 
1.7.6

