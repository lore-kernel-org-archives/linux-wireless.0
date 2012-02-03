Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:39665 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754216Ab2BCEuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 23:50:51 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: cleanup in snmp_mib command preparation code
Date: Thu,  2 Feb 2012 20:48:57 -0800
Message-Id: <1328244538-23963-1-git-send-email-bzhao@marvell.com> (sfid-20120203_055055_041707_F5408788)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) Remove unnecessary switch case usage.
2) Replace "X=cpu_to_le16(le16_to_cpu(X) + Y)" by "le16_add_cpu(X, Y)"
3) Declare "ul_temp" variable as u16 instead of u32 to avoid
unnecessary typecasting

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c |   60 ++++---------------------------
 1 files changed, 8 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 6e443ff..324c651 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -103,7 +103,7 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 				       struct host_cmd_ds_command *cmd,
 				       u16 cmd_action, u32 cmd_oid,
-				       u32 *ul_temp)
+				       u16 *ul_temp)
 {
 	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
 
@@ -112,62 +112,18 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
 		- 1 + S_DS_GEN);
 
+	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
 		snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_GET);
 		snmp_mib->buf_size = cpu_to_le16(MAX_SNMP_BUF_SIZE);
-		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
-			+ MAX_SNMP_BUF_SIZE);
+		le16_add_cpu(&cmd->size, MAX_SNMP_BUF_SIZE);
+	} else if (cmd_action == HostCmd_ACT_GEN_SET) {
+		snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
+		snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
+		*((__le16 *) (snmp_mib->value)) = cpu_to_le16(*ul_temp);
+		le16_add_cpu(&cmd->size, sizeof(u16));
 	}
 
-	switch (cmd_oid) {
-	case FRAG_THRESH_I:
-		snmp_mib->oid = cpu_to_le16((u16) FRAG_THRESH_I);
-		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
-			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			*((__le16 *) (snmp_mib->value)) =
-				cpu_to_le16((u16) *ul_temp);
-			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
-				+ sizeof(u16));
-		}
-		break;
-	case RTS_THRESH_I:
-		snmp_mib->oid = cpu_to_le16((u16) RTS_THRESH_I);
-		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
-			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			*(__le16 *) (snmp_mib->value) =
-				cpu_to_le16((u16) *ul_temp);
-			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
-				+ sizeof(u16));
-		}
-		break;
-
-	case SHORT_RETRY_LIM_I:
-		snmp_mib->oid = cpu_to_le16((u16) SHORT_RETRY_LIM_I);
-		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
-			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			*((__le16 *) (snmp_mib->value)) =
-				cpu_to_le16((u16) *ul_temp);
-			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
-				+ sizeof(u16));
-		}
-		break;
-	case DOT11D_I:
-		snmp_mib->oid = cpu_to_le16((u16) DOT11D_I);
-		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
-			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			*((__le16 *) (snmp_mib->value)) =
-				cpu_to_le16((u16) *ul_temp);
-			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
-				+ sizeof(u16));
-		}
-		break;
-	default:
-		break;
-	}
 	dev_dbg(priv->adapter->dev,
 		"cmd: SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x,"
 		" Value=0x%x\n",
-- 
1.7.0.2

