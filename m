Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:37822 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1EJBzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 21:55:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove unnecessary struct mwifiex_opt_sleep_confirm_buffer
Date: Mon,  9 May 2011 19:00:18 -0700
Message-Id: <1304992818-9859-1-git-send-email-bzhao@marvell.com> (sfid-20110510_035558_684632_18A22C92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The structure definition is
struct mwifiex_opt_sleep_confirm_buffer {
       u8 hdr[4];
       struct mwifiex_opt_sleep_confirm ps_cfm_sleep;
} __packed;

For sleep_confirm command we already reserve 4 bytes (using skb_reserve())
for an interface header. It will be filled later by interface specific code.
We don't need "hdr[4]" element in above structure. So we can use
"struct mwifiex_opt_sleep_confirm" directly instead of
"struct mwifiex_opt_sleep_confirm_buffer".

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   17 ++++++++---------
 drivers/net/wireless/mwifiex/fw.h     |    5 -----
 drivers/net/wireless/mwifiex/init.c   |   26 ++++++++++++--------------
 3 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 1c8b4f7..5c75399 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -223,24 +223,23 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 {
 	int ret;
-	u16 cmd_len;
 	struct mwifiex_private *priv;
-	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf =
-				(struct mwifiex_opt_sleep_confirm_buffer *)
+	struct mwifiex_opt_sleep_confirm *sleep_cfm_buf =
+				(struct mwifiex_opt_sleep_confirm *)
 				adapter->sleep_cfm->data;
-	cmd_len = sizeof(struct mwifiex_opt_sleep_confirm);
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-	sleep_cfm_buf->ps_cfm_sleep.seq_num =
+	sleep_cfm_buf->seq_num =
 		cpu_to_le16((HostCmd_SET_SEQ_NO_BSS_INFO
 					(adapter->seq_num, priv->bss_num,
 					 priv->bss_type)));
 	adapter->seq_num++;
 
+	skb_push(adapter->sleep_cfm, INTF_HEADER_LEN);
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
 					     adapter->sleep_cfm->data,
-					     adapter->sleep_cfm->len +
-					     INTF_HEADER_LEN, NULL);
+					     adapter->sleep_cfm->len, NULL);
+	skb_pull(adapter->sleep_cfm, INTF_HEADER_LEN);
 
 	if (ret == -1) {
 		dev_err(adapter->dev, "SLEEP_CFM: failed\n");
@@ -249,14 +248,14 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	}
 	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
 			== MWIFIEX_BSS_ROLE_STA) {
-		if (!sleep_cfm_buf->ps_cfm_sleep.resp_ctrl)
+		if (!sleep_cfm_buf->resp_ctrl)
 			/* Response is not needed for sleep
 			   confirm command */
 			adapter->ps_state = PS_STATE_SLEEP;
 		else
 			adapter->ps_state = PS_STATE_SLEEP_CFM;
 
-		if (!sleep_cfm_buf->ps_cfm_sleep.resp_ctrl
+		if (!sleep_cfm_buf->resp_ctrl
 				&& (adapter->is_hs_configured
 					&& !adapter->sleep_period.period)) {
 			adapter->pm_wakeup_card_req = true;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6d1c454..c6b2681 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1198,9 +1198,4 @@ struct mwifiex_opt_sleep_confirm {
 	__le16 action;
 	__le16 resp_ctrl;
 } __packed;
-
-struct mwifiex_opt_sleep_confirm_buffer {
-	u8 hdr[4];
-	struct mwifiex_opt_sleep_confirm ps_cfm_sleep;
-} __packed;
 #endif /* !_MWIFIEX_FW_H_ */
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 6a8fd99..3f1559e 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -175,7 +175,7 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->sleep_cfm =
-		dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm_buffer)
+		dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
 				+ INTF_HEADER_LEN);
 
 	if (!adapter->sleep_cfm) {
@@ -197,10 +197,10 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
  */
 static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf = NULL;
+	struct mwifiex_opt_sleep_confirm *sleep_cfm_buf = NULL;
 
-	skb_put(adapter->sleep_cfm, sizeof(sleep_cfm_buf->ps_cfm_sleep));
-	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm_buffer *)
+	skb_put(adapter->sleep_cfm, sizeof(struct mwifiex_opt_sleep_confirm));
+	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
 						(adapter->sleep_cfm->data);
 
 	adapter->cmd_sent = false;
@@ -268,16 +268,14 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	mwifiex_wmm_init(adapter);
 
 	if (adapter->sleep_cfm) {
-		memset(&sleep_cfm_buf->ps_cfm_sleep, 0,
-			adapter->sleep_cfm->len);
-		sleep_cfm_buf->ps_cfm_sleep.command =
-			cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
-		sleep_cfm_buf->ps_cfm_sleep.size =
-			cpu_to_le16(adapter->sleep_cfm->len);
-		sleep_cfm_buf->ps_cfm_sleep.result = 0;
-		sleep_cfm_buf->ps_cfm_sleep.action = cpu_to_le16(SLEEP_CONFIRM);
-		sleep_cfm_buf->ps_cfm_sleep.resp_ctrl =
-			cpu_to_le16(RESP_NEEDED);
+		memset(sleep_cfm_buf, 0, adapter->sleep_cfm->len);
+		sleep_cfm_buf->command =
+				cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
+		sleep_cfm_buf->size =
+				cpu_to_le16(adapter->sleep_cfm->len);
+		sleep_cfm_buf->result = 0;
+		sleep_cfm_buf->action = cpu_to_le16(SLEEP_CONFIRM);
+		sleep_cfm_buf->resp_ctrl = cpu_to_le16(RESP_NEEDED);
 	}
 	memset(&adapter->sleep_params, 0, sizeof(adapter->sleep_params));
 	memset(&adapter->sleep_period, 0, sizeof(adapter->sleep_period));
-- 
1.7.0.2

