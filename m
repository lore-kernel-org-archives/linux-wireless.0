Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31043 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258AbaBYM0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 07:26:01 -0500
Date: Tue, 25 Feb 2014 17:41:58 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 1/3 v3] mwl8k: Adding support to access BBP registers
Message-ID: <20140225121157.GA5640@markyou.marvell.com> (sfid-20140225_132609_566726_85885001)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding AP firmware command to access BBP
regs. This will be used for retrieving
different counters CCA/RX needed for ACS

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---

v2: Freeing allocated buffer before returning.
	Reported-by: Jonas Gorski <jogo@openwrt.org>

v3: Fixing build failure.

 drivers/net/wireless/mwl8k.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4987c3f..6c002f3 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -396,6 +396,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_SET_HW_SPEC		0x0004
 #define MWL8K_CMD_MAC_MULTICAST_ADR	0x0010
 #define MWL8K_CMD_GET_STAT		0x0014
+#define MWL8K_CMD_BBP_REG_ACCESS	0x001a
 #define MWL8K_CMD_RADIO_CONTROL		0x001c
 #define MWL8K_CMD_RF_TX_POWER		0x001e
 #define MWL8K_CMD_TX_POWER		0x001f
@@ -2987,6 +2988,47 @@ static int mwl8k_cmd_set_pre_scan(struct ieee80211_hw *hw)
 }
 
 /*
+ * CMD_BBP_REG_ACCESS.
+ */
+struct mwl8k_cmd_bbp_reg_access {
+	struct mwl8k_cmd_pkt header;
+	__le16 action;
+	__le16 offset;
+	u8 value;
+	u8 rsrv[3];
+} __packed;
+
+static int
+mwl8k_cmd_bbp_reg_access(struct ieee80211_hw *hw,
+			 u16 action,
+			 u16 offset,
+			 u8 *value)
+{
+	struct mwl8k_cmd_bbp_reg_access *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_BBP_REG_ACCESS);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le16(action);
+	cmd->offset = cpu_to_le16(offset);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+
+	if (!rc)
+		*value = cmd->value;
+	else
+		*value = 0;
+
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_SET_POST_SCAN.
  */
 struct mwl8k_cmd_set_post_scan {
-- 
1.8.3.4

