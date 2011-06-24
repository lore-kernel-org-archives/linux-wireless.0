Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64355 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab1FXNe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 09:34:27 -0400
Date: Fri, 24 Jun 2011 16:33:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: restore handling of NULL parameters
Message-ID: <20110624133335.GP14591@shale.localdomain> (sfid-20110624_153432_080187_38C989B0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to a5ffddb70c5cab "mwifiex: remove casts of void pointers" the
code assumed that the data_buf parameter could be a NULL pointer.
The patch preserved some NULL checks but not consistently, so there
was a potential for NULL dereferences and it changed the behavior.
This patch restores the original behavior.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested only.

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index d85a0a6..49b9c13 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -779,6 +779,8 @@ static int mwifiex_cmd_ibss_coalescing_status(struct host_cmd_ds_command *cmd,
 	case HostCmd_ACT_GEN_SET:
 		if (enable)
 			ibss_coal->enable = cpu_to_le16(*enable);
+		else
+			ibss_coal->enable = 0;
 		break;
 
 		/* In other case.. Nothing to do */
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index ad64c87..6804239 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -183,30 +183,32 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 				       struct host_cmd_ds_command *resp,
-				       u32 *ul_temp)
+				       u32 *data_buf)
 {
 	struct host_cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
 	u16 oid = le16_to_cpu(smib->oid);
 	u16 query_type = le16_to_cpu(smib->query_type);
+	u32 ul_temp;
 
 	dev_dbg(priv->adapter->dev, "info: SNMP_RESP: oid value = %#x,"
 			" query_type = %#x, buf size = %#x\n",
 			oid, query_type, le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
-		if (ul_temp)
-			*ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
+		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
+		if (data_buf)
+			*data_buf = ul_temp;
 		switch (oid) {
 		case FRAG_THRESH_I:
 			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: FragThsd =%u\n", *ul_temp);
+				"info: SNMP_RESP: FragThsd =%u\n", ul_temp);
 			break;
 		case RTS_THRESH_I:
 			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: RTSThsd =%u\n", *ul_temp);
+				"info: SNMP_RESP: RTSThsd =%u\n", ul_temp);
 			break;
 		case SHORT_RETRY_LIM_I:
 			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: TxRetryCount=%u\n", *ul_temp);
+				"info: SNMP_RESP: TxRetryCount=%u\n", ul_temp);
 			break;
 		default:
 			break;
@@ -622,22 +624,23 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 					 struct host_cmd_ds_command *resp,
-					 u16 *new_channel)
+					 u16 *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_channel *rf_channel =
 		&resp->params.rf_channel;
+	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
 
-	if (new_channel)
-		*new_channel = le16_to_cpu(rf_channel->current_channel);
-
-	if (priv->curr_bss_params.bss_descriptor.channel != *new_channel) {
+	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
 		dev_dbg(priv->adapter->dev, "cmd: Channel Switch: %d to %d\n",
 		       priv->curr_bss_params.bss_descriptor.channel,
-		       *new_channel);
+		       new_channel);
 		/* Update the channel again */
-		priv->curr_bss_params.bss_descriptor.channel = *new_channel;
+		priv->curr_bss_params.bss_descriptor.channel = new_channel;
 	}
 
+	if (data_buf)
+		*data_buf = new_channel;
+
 	return 0;
 }
 
