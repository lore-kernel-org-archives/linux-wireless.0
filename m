Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55632 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374Ab3JVWZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:25:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/6] mwifiex: replace u16 with __le16 in struct mwifiex_types_power_group
Date: Tue, 22 Oct 2013 15:24:43 -0700
Message-ID: <1382480687-12720-3-git-send-email-bzhao@marvell.com> (sfid-20131023_002513_375079_54D8107E)
In-Reply-To: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
References: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

__le16 to u16 conversion is missing for "pg_tlv_hdr->length"
in mwifiex_get_power_level(). This creates a problem on big
endian machines.
It is resolved by changing definition of the structure
and making required endianness changes.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          | 4 ++--
 drivers/net/wireless/mwifiex/sta_cmd.c     | 4 ++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 4 ++--
 drivers/net/wireless/mwifiex/sta_ioctl.c   | 5 +++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index f80f30b..c8385ec 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1020,8 +1020,8 @@ struct mwifiex_power_group {
 } __packed;
 
 struct mwifiex_types_power_group {
-	u16 type;
-	u16 length;
+	__le16 type;
+	__le16 length;
 } __packed;
 
 struct host_cmd_ds_txpwr_cfg {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 7d66018..2181ee2 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -239,14 +239,14 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
 			memmove(cmd_txp_cfg, txp,
 				sizeof(struct host_cmd_ds_txpwr_cfg) +
 				sizeof(struct mwifiex_types_power_group) +
-				pg_tlv->length);
+				le16_to_cpu(pg_tlv->length));
 
 			pg_tlv = (struct mwifiex_types_power_group *) ((u8 *)
 				  cmd_txp_cfg +
 				  sizeof(struct host_cmd_ds_txpwr_cfg));
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
 				  sizeof(struct mwifiex_types_power_group) +
-				  pg_tlv->length);
+				  le16_to_cpu(pg_tlv->length));
 		} else {
 			memmove(cmd_txp_cfg, txp, sizeof(*txp));
 		}
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 58a6013..bdf50fd 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -340,7 +340,7 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 		((u8 *) data_buf + sizeof(struct host_cmd_ds_txpwr_cfg));
 	pg = (struct mwifiex_power_group *)
 		((u8 *) pg_tlv_hdr + sizeof(struct mwifiex_types_power_group));
-	length = pg_tlv_hdr->length;
+	length = le16_to_cpu(pg_tlv_hdr->length);
 	if (length > 0) {
 		max_power = pg->power_max;
 		min_power = pg->power_min;
@@ -356,7 +356,7 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 
 		length -= sizeof(struct mwifiex_power_group);
 	}
-	if (pg_tlv_hdr->length > 0) {
+	if (le16_to_cpu(pg_tlv_hdr->length) > 0) {
 		priv->min_tx_power_level = (u8) min_power;
 		priv->max_tx_power_level = (u8) max_power;
 	}
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f084412..c8e029d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -638,8 +638,9 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		txp_cfg->mode = cpu_to_le32(1);
 		pg_tlv = (struct mwifiex_types_power_group *)
 			 (buf + sizeof(struct host_cmd_ds_txpwr_cfg));
-		pg_tlv->type = TLV_TYPE_POWER_GROUP;
-		pg_tlv->length = 4 * sizeof(struct mwifiex_power_group);
+		pg_tlv->type = cpu_to_le16(TLV_TYPE_POWER_GROUP);
+		pg_tlv->length =
+			cpu_to_le16(4 * sizeof(struct mwifiex_power_group));
 		pg = (struct mwifiex_power_group *)
 		     (buf + sizeof(struct host_cmd_ds_txpwr_cfg)
 		      + sizeof(struct mwifiex_types_power_group));
-- 
1.8.2.3

