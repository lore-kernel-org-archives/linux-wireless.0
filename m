Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbCWJgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 05:36:16 -0400
Date: Mon, 23 Mar 2015 12:35:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: remove an unneede NULL check in
 mwifiex_init_adapter()
Message-ID: <20150323093551.GC558@mwanda> (sfid-20150323_103620_999812_50490618)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"adapter->sleep_cfm" is always non-NULL at this point.  Static checkers
complain that we already dereference it at the start of the function
when we do:

	skb_put(adapter->sleep_cfm, sizeof(struct mwifiex_opt_sleep_confirm));

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 6936de8..e12192f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -266,18 +266,15 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	mwifiex_wmm_init(adapter);
 
-	if (adapter->sleep_cfm) {
-		sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
-						adapter->sleep_cfm->data;
-		memset(sleep_cfm_buf, 0, adapter->sleep_cfm->len);
-		sleep_cfm_buf->command =
-				cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
-		sleep_cfm_buf->size =
-				cpu_to_le16(adapter->sleep_cfm->len);
-		sleep_cfm_buf->result = 0;
-		sleep_cfm_buf->action = cpu_to_le16(SLEEP_CONFIRM);
-		sleep_cfm_buf->resp_ctrl = cpu_to_le16(RESP_NEEDED);
-	}
+	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
+					adapter->sleep_cfm->data;
+	memset(sleep_cfm_buf, 0, adapter->sleep_cfm->len);
+	sleep_cfm_buf->command = cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
+	sleep_cfm_buf->size = cpu_to_le16(adapter->sleep_cfm->len);
+	sleep_cfm_buf->result = 0;
+	sleep_cfm_buf->action = cpu_to_le16(SLEEP_CONFIRM);
+	sleep_cfm_buf->resp_ctrl = cpu_to_le16(RESP_NEEDED);
+
 	memset(&adapter->sleep_params, 0, sizeof(adapter->sleep_params));
 	memset(&adapter->sleep_period, 0, sizeof(adapter->sleep_period));
 	adapter->tx_lock_flag = false;
