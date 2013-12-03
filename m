Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28435 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab3LCHSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 11/12] mwifiex: improvements in mwifiex_ret_tx_power_cfg()
Date: Mon, 2 Dec 2013 23:17:58 -0800
Message-ID: <1386055079-6623-12-git-send-email-bzhao@marvell.com> (sfid-20131203_081857_189498_78E64A89)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) Move common code out of switch case handling
2) Return from the function if number of bytes left in response buffer
are less than tlv size
3) Pass pg_tlv_hdr directly instead of txp_cfg to mwifiex_get_power_level()

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 35 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 2675ca7..5511946 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -338,8 +338,7 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 	if (!data_buf)
 		return -1;
 
-	pg_tlv_hdr = (struct mwifiex_types_power_group *)
-		((u8 *) data_buf + sizeof(struct host_cmd_ds_txpwr_cfg));
+	pg_tlv_hdr = (struct mwifiex_types_power_group *)((u8 *)data_buf);
 	pg = (struct mwifiex_power_group *)
 		((u8 *) pg_tlv_hdr + sizeof(struct mwifiex_types_power_group));
 	length = le16_to_cpu(pg_tlv_hdr->length);
@@ -383,19 +382,25 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 	struct mwifiex_types_power_group *pg_tlv_hdr;
 	struct mwifiex_power_group *pg;
 	u16 action = le16_to_cpu(txp_cfg->action);
+	u16 tlv_buf_left;
 
-	switch (action) {
-	case HostCmd_ACT_GEN_GET:
-		pg_tlv_hdr = (struct mwifiex_types_power_group *)
-			((u8 *) txp_cfg +
-			 sizeof(struct host_cmd_ds_txpwr_cfg));
+	pg_tlv_hdr = (struct mwifiex_types_power_group *)
+		((u8 *)txp_cfg +
+		 sizeof(struct host_cmd_ds_txpwr_cfg));
 
-		pg = (struct mwifiex_power_group *)
-			((u8 *) pg_tlv_hdr +
-			 sizeof(struct mwifiex_types_power_group));
+	pg = (struct mwifiex_power_group *)
+		((u8 *)pg_tlv_hdr +
+		 sizeof(struct mwifiex_types_power_group));
 
+	tlv_buf_left = le16_to_cpu(resp->size) - S_DS_GEN - sizeof(*txp_cfg);
+	if (tlv_buf_left <
+			le16_to_cpu(pg_tlv_hdr->length) + sizeof(*pg_tlv_hdr))
+		return 0;
+
+	switch (action) {
+	case HostCmd_ACT_GEN_GET:
 		if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
-			mwifiex_get_power_level(priv, txp_cfg);
+			mwifiex_get_power_level(priv, pg_tlv_hdr);
 
 		priv->tx_power_level = (u16) pg->power_min;
 		break;
@@ -404,14 +409,6 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 		if (!le32_to_cpu(txp_cfg->mode))
 			break;
 
-		pg_tlv_hdr = (struct mwifiex_types_power_group *)
-			((u8 *) txp_cfg +
-			 sizeof(struct host_cmd_ds_txpwr_cfg));
-
-		pg = (struct mwifiex_power_group *)
-			((u8 *) pg_tlv_hdr +
-			 sizeof(struct mwifiex_types_power_group));
-
 		if (pg->power_max == pg->power_min)
 			priv->tx_power_level = (u16) pg->power_min;
 		break;
-- 
1.8.2.3

