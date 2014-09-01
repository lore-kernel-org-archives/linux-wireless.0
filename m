Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49078 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaIAHbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:42 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 08/17] mwifiex: fix left_len calculation issue
Date: Mon, 1 Sep 2014 18:28:56 +0530
Message-ID: <1409576345-13717-9-git-send-email-patila@marvell.com> (sfid-20140901_093145_905853_B64C8A6D)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

While updating 'left_len' in each iteration, we should subtract
last TLV length not the accumulated length of TLVs parsed till
now.
This bug in parsing logic is exposed by newer firmware which adds
two TLVs in GET_HW_SPEC command response. Earlier firmwares used to
add only one TLV.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index baf0aab..0c21239 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1567,7 +1567,8 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 			}
 			parsed_len += le16_to_cpu(tlv->len) +
 				      sizeof(struct mwifiex_ie_types_header);
-			left_len -= parsed_len;
+			left_len -= le16_to_cpu(tlv->len) +
+				      sizeof(struct mwifiex_ie_types_header);
 		}
 	}
 
-- 
1.8.1.4

