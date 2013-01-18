Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:55560 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab3ARBpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 20:45:36 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: correction in status codes used for association failure
Date: Thu, 17 Jan 2013 17:41:57 -0800
Message-Id: <1358473317-27860-1-git-send-email-bzhao@marvell.com> (sfid-20130118_024540_263447_2278D24F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When AP responds with appropriate status code, we forward that
code correctly to cfg80211. But sometimes when there is no
response from AP, our firmware uses proprietary status codes.
We will map authentication timeout to WLAN_STATUS_AUTH_TIMEOUT
and other proprietary codes to WLAN_STATUS_UNSPECIFIED_FAILURE.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |    3 +++
 drivers/net/wireless/mwifiex/join.c |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 41c85dd..ebe2f6a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -330,6 +330,9 @@ enum P2P_MODES {
 #define HOST_SLEEP_CFG_GPIO_DEF		0xff
 #define HOST_SLEEP_CFG_GAP_DEF		0
 
+#define MWIFIEX_TIMEOUT_FOR_AP_RESP		0xfffc
+#define MWIFIEX_STATUS_CODE_AUTH_TIMEOUT	2
+
 #define CMD_F_HOSTCMD           (1 << 0)
 #define CMD_F_CANCELED          (1 << 1)
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 3c7cabe..893d809 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -615,23 +615,33 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	struct ieee_types_assoc_rsp *assoc_rsp;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u8 enable_data = true;
+	u16 cap_info, status_code;
 
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
+	cap_info = le16_to_cpu(assoc_rsp->cap_info_bitmap);
+	status_code = le16_to_cpu(assoc_rsp->status_code);
+
 	priv->assoc_rsp_size = min(le16_to_cpu(resp->size) - S_DS_GEN,
 				   sizeof(priv->assoc_rsp_buf));
 
 	memcpy(priv->assoc_rsp_buf, &resp->params, priv->assoc_rsp_size);
 
-	if (le16_to_cpu(assoc_rsp->status_code)) {
+	if (status_code) {
 		priv->adapter->dbg.num_cmd_assoc_failure++;
 		dev_err(priv->adapter->dev,
 			"ASSOC_RESP: failed, status code=%d err=%#x a_id=%#x\n",
-			le16_to_cpu(assoc_rsp->status_code),
-			le16_to_cpu(assoc_rsp->cap_info_bitmap),
-			le16_to_cpu(assoc_rsp->a_id));
+			status_code, cap_info, le16_to_cpu(assoc_rsp->a_id));
+
+		if (cap_info == MWIFIEX_TIMEOUT_FOR_AP_RESP) {
+			if (status_code == MWIFIEX_STATUS_CODE_AUTH_TIMEOUT)
+				ret = WLAN_STATUS_AUTH_TIMEOUT;
+			else
+				ret = WLAN_STATUS_UNSPECIFIED_FAILURE;
+		} else {
+			ret = status_code;
+		}
 
-		ret = le16_to_cpu(assoc_rsp->status_code);
 		goto done;
 	}
 
-- 
1.7.0.2

