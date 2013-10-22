Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50019 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab3JVWZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 18:25:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/6] mwifiex: potential integer underflow in mwifiex_ret_wmm_get_status()
Date: Tue, 22 Oct 2013 15:24:42 -0700
Message-ID: <1382480687-12720-2-git-send-email-bzhao@marvell.com> (sfid-20131023_002527_781526_5917B3C4)
In-Reply-To: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
References: <1382480687-12720-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

Before we loop for next iteration we adjust the buffer pointer and
"resp_len":

		curr += (tlv_len + sizeof(tlv_hdr->header));
		resp_len -= (tlv_len + sizeof(tlv_hdr->header));

If "resp_len" gets set to negative then it counts as a high positive
value.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 5dd0ccc..13eaeed 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -722,6 +722,9 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 		tlv_hdr = (struct mwifiex_ie_types_data *) curr;
 		tlv_len = le16_to_cpu(tlv_hdr->header.len);
 
+		if (resp_len < tlv_len + sizeof(tlv_hdr->header))
+			break;
+
 		switch (le16_to_cpu(tlv_hdr->header.type)) {
 		case TLV_TYPE_WMMQSTATUS:
 			tlv_wmm_qstatus =
-- 
1.8.2.3

