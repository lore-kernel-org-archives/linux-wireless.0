Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9782 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab3JVWZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:25:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/6] mwifiex: fix invalid memory access in mwifiex_ret_tx_rate_cfg()
Date: Tue, 22 Oct 2013 15:24:45 -0700
Message-ID: <1382480687-12720-5-git-send-email-bzhao@marvell.com> (sfid-20131023_002510_395501_7592D8E5)
In-Reply-To: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
References: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As tlv_buf_len is decremented at the end of the loop, we may have
accessed invalid memory in the last iteration.
Modify the while condition and add a break statement at the
begining of the loop to fix the problem.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 5edea4d..2675ca7 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -274,17 +274,20 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
 	struct mwifiex_ie_types_header *head;
-	u16 tlv, tlv_buf_len;
+	u16 tlv, tlv_buf_len, tlv_buf_left;
 	u8 *tlv_buf;
 	u32 i;
 
-	tlv_buf = ((u8 *)rate_cfg) +
-			sizeof(struct host_cmd_ds_tx_rate_cfg);
-	tlv_buf_len = le16_to_cpu(*(__le16 *) (tlv_buf + sizeof(u16)));
+	tlv_buf = ((u8 *)rate_cfg) + sizeof(struct host_cmd_ds_tx_rate_cfg);
+	tlv_buf_left = le16_to_cpu(resp->size) - S_DS_GEN - sizeof(*rate_cfg);
 
-	while (tlv_buf && tlv_buf_len > 0) {
-		tlv = (*tlv_buf);
-		tlv = tlv | (*(tlv_buf + 1) << 8);
+	while (tlv_buf_left >= sizeof(*head)) {
+		head = (struct mwifiex_ie_types_header *)tlv_buf;
+		tlv = le16_to_cpu(head->type);
+		tlv_buf_len = le16_to_cpu(head->len);
+
+		if (tlv_buf_left < (sizeof(*head) + tlv_buf_len))
+			break;
 
 		switch (tlv) {
 		case TLV_TYPE_RATE_SCOPE:
@@ -304,9 +307,8 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 			/* Add RATE_DROP tlv here */
 		}
 
-		head = (struct mwifiex_ie_types_header *) tlv_buf;
-		tlv_buf += le16_to_cpu(head->len) + sizeof(*head);
-		tlv_buf_len -= le16_to_cpu(head->len);
+		tlv_buf += (sizeof(*head) + tlv_buf_len);
+		tlv_buf_left -= (sizeof(*head) + tlv_buf_len);
 	}
 
 	priv->is_data_rate_auto = mwifiex_is_rate_auto(priv);
-- 
1.8.2.3

